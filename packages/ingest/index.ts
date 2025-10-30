import 'lib/global'

import dotenv from 'dotenv'
import path from 'path'
const envPath = path.join(__dirname, '../..', '.env')
dotenv.config({ path: envPath })

import fs from 'fs'
import http from 'http'
import { abisConfig, cache, chains, crons as cronsConfig, mq } from 'lib'
import { Processor, ProcessorPool } from 'lib/processor'
import { camelToSnake } from 'lib/strings'
import db from './db'
import { rpcs } from './rpcs'

const exportsProcessor = (filePath: string): boolean => {
  const fileContent = fs.readFileSync(filePath, 'utf8')
  const regex = /export default class \S+ implements Processor/
  return regex.test(fileContent)
}

console.log('🔗', 'chain', `[${chains.map(c => c.name.toLowerCase()).join(' x ')}]`)
console.log('🎯', 'abi target', `[${abisConfig.abis.map(c => c.abiPath).join(' x ')}]`)

const pools = fs.readdirSync(__dirname, { withFileTypes: true }).map(dirent => {
  const tenMinutes = 10 * 60 * 1000
  if (dirent.isDirectory()) {
    const indexPath = path.join(__dirname, dirent.name, 'index.ts')
    if (fs.existsSync(indexPath) && exportsProcessor(indexPath)) {
      console.log('⬆', 'processor up', dirent.name)
      const ProcessorClass = require(indexPath).default
      return new ProcessorPool(ProcessorClass, 1, tenMinutes)
    }
  }
}).filter(p => p) as Processor[]

const crons = cronsConfig.default
  .filter(cron => cron.start)
  .map(cron => new Promise((resolve, reject) => {
    const job = mq.job[cron.queue][cron.job]
    if (job.bychain) {
      for (const chain of chains) {
        mq.add(job, { id: camelToSnake(cron.name), chainId: chain.id }, {
          repeat: { pattern: cron.schedule }
        }).then(() => {
          console.log('⬆', 'cron up', cron.name, chain.id)
          resolve(null)
        }).catch(error => {
          console.error('❌ cron add failed', cron.name, chain.id, error)
          reject(error)
        })
      }

    } else {
      mq.add(job, { id: camelToSnake(cron.name) }, {
        repeat: { pattern: cron.schedule }
      }).then(() => {
        console.log('⬆', 'cron up', cron.name)
        resolve(null)
      }).catch(error => {
        console.error('❌ cron add failed', cron.name, error)
        reject(error)
      })

    }
  }))

const abis = abisConfig.cron.start
  ? mq.add(mq.job.fanout.abis, { id: 'mq.job.fanout.abis' }, {
    repeat: { pattern: abisConfig.cron.schedule }
  }).then(() => {
    console.log('⬆', 'abis up')
  }).catch(error => {
    console.error('❌ abis cron add failed', error)
    throw error
  }) : Promise.resolve(null)

// Health check server for Cloud Run
const port = process.env.PORT || 8080
const healthServer = http.createServer((req, res) => {
  if (req.url === '/health' || req.url === '/') {
    res.writeHead(200, { 'Content-Type': 'text/plain' })
    res.end('OK')
  } else {
    res.writeHead(404)
    res.end()
  }
})

function up() {
  healthServer.listen(port, () => {
    console.log(`🏥 health check server listening on port ${port}`)
  })

  Promise.all([
    rpcs.up(),
    cache.up(),
    ...pools.map(pool => pool.up()),
    ...crons,
    abis,
  ]).then(() => {
    console.log('🐒 ingest up')
  }).catch(error => {
    console.error('🤬', error)
    process.exit(1)
  })

}

function down() {
  healthServer.close()
  Promise.all([
    ...pools.map(pool => pool.down()),
    rpcs.down(),
    cache.down(),
    db.end()
  ]).then(() => {

    console.log('🐒 ingest down')
    process.exit(0)

  }).catch(error => {
    console.error('🤬', error)
    process.exit(1)
  })
}

up()
process.on('SIGINT', down)
process.on('SIGTERM', down)
