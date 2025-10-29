import * as fs from 'fs'
import * as yaml from 'js-yaml'
import path from 'path'
import { defineChain } from 'viem'
import { arbitrum, mainnet } from 'viem/chains'

export const customChains = {
  filecoin: /*#__PURE__*/ defineChain({
    // id: 314,
    // name: 'Filecoin - Mainnet',
    id: 314159,
    name: 'Filecoin - Testnet',
    nativeCurrency: {
      name: 'Filecoin',
      symbol: 'FIL',
      decimals: 18,
    },
    rpcUrls: {
      default: {
        // http: ['https://api.node.glif.io/rpc/v1'],
        http: ['https://api.calibration.node.glif.io/rpc/v1'],
      },
    },
    blockExplorers: {
      default: {
        name: 'Filfox',
        url: 'https://filfox.info/en',
      },
    },
    contracts: {
      multicall3: {
        address: '0xca11bde05977b3631167028862be2a173976ca11',
        blockCreated: 0,
      },
    },
    testnet: true,
  })
}

// const viemchains = { arbitrum, base, fantom, gnosis, mainnet, optimism, polygon, ...customChains }
const viemchains = { arbitrum, mainnet, ...customChains }

interface YamlConfig { chains: string [] }

const yamlPath = (() => {
  const local = path.join(__dirname, '../../config', 'chains.local.yaml')
  const production = path.join(__dirname, '../../config', 'chains.yaml')
  if(fs.existsSync(local)) return local
  return production
})()

const yamlFile = fs.readFileSync(yamlPath, 'utf8')
const config = yaml.load(yamlFile) as YamlConfig
const chains = config.chains.map(name => {
  const viemchain = viemchains[name as keyof typeof viemchains]
  if(!viemchain) throw new Error(`chain not found, ${name}`)
  return viemchain
})

export { chains }
export default chains
