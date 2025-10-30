#!/usr/bin/env node
/**
 * Non-interactive job runner for Cloud Run Jobs
 * Usage: bun job.ts --job=<job-type> [--replay]
 *
 * Examples:
 *   bun job.ts --job=fanout-abis
 *   bun job.ts --job=fanout-abis --replay
 *   bun job.ts --job=extract-waveydb
 *   bun job.ts --job=extract-manuals
 */

// IMPORTANT: Must import lib/global first to setup BigInt.prototype.toJSON
import 'lib/global'
import dotenv from 'dotenv'
import path from 'path'
import { mq } from 'lib'

const envPath = path.join(__dirname, '../..', '.env')
dotenv.config({ path: envPath })

// Parse command line arguments
function parseArgs() {
  const args = process.argv.slice(2)
  const parsed: { job?: string; replay?: boolean } = {}

  for (const arg of args) {
    if (arg.startsWith('--job=')) {
      parsed.job = arg.split('=')[1]
    } else if (arg === '--replay') {
      parsed.replay = true
    }
  }

  return parsed
}

// Map job string to job definition and data
function getJobConfig(jobString: string, replay: boolean) {
  switch (jobString) {
  case 'fanout-abis':
    return {
      job: mq.job.fanout.abis,
      data: replay ? { replay: { enabled: true } } : {}
    }
  case 'fanout-events':
    return {
      job: mq.job.fanout.events,
      data: {}
    }
  case 'fanout-timeseries':
    return {
      job: mq.job.fanout.timeseries,
      data: {}
    }
  case 'fanout-webhooks':
    return {
      job: mq.job.fanout.webhooks,
      data: {}
    }
  case 'extract-waveydb':
    return {
      job: mq.job.extract.waveydb,
      data: {}
    }
  case 'extract-manuals':
    return {
      job: mq.job.extract.manuals,
      data: {}
    }
  default:
    throw new Error(`Unknown job: ${jobString}. Available jobs: fanout-abis, fanout-events, fanout-timeseries, fanout-webhooks, extract-waveydb, extract-manuals`)
  }
}

async function main() {
  const args = parseArgs()

  if (!args.job) {
    console.error('Error: --job argument is required')
    console.error('Usage: bun job.ts --job=<job-type> [--replay]')
    console.error('Available jobs:')
    console.error('  - fanout-abis')
    console.error('  - fanout-events')
    console.error('  - fanout-timeseries')
    console.error('  - fanout-webhooks')
    console.error('  - extract-waveydb')
    console.error('  - extract-manuals')
    process.exit(1)
  }

  console.log(`🚀 Starting job: ${args.job}${args.replay ? ' (replay mode)' : ''}`)

  const config = getJobConfig(args.job, args.replay || false)
  console.log(`📋 Queue: ${config.job.queue}, Job: ${config.job.name}`)

  try {
    const result = await mq.add(config.job, config.data)
    console.log(`✅ Job added successfully: ${result.id}`)
    console.log('📊 Job details:', {
      id: result.id,
      name: result.name,
      queue: config.job.queue,
      data: config.data
    })

    // Close connections
    await mq.down()
    console.log('👋 Done')
    process.exit(0)
  } catch (error) {
    console.error('❌ Failed to add job:', error)
    await mq.down()
    process.exit(1)
  }
}

main()
