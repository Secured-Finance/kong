import { defineChain } from 'viem'
// import { arbitrum, base, fantom, gnosis, mainnet, optimism, polygon } from 'viem/chains'
import { mainnet } from 'viem/chains'

export const customChains = {
  filecoin: /*#__PURE__*/ defineChain({
    id: 314,
    name: 'Filecoin - Mainnet',
    nativeCurrency: {
      name: 'Filecoin',
      symbol: 'FIL',
      decimals: 18,
    },
    rpcUrls: {
      default: {
        http: ['https://api.node.glif.io/rpc/v1'],
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
    testnet: false,
  }),
  filecoinCalibration: /*#__PURE__*/ defineChain({
    id: 314159,
    name: 'Filecoin - Testnet',
    nativeCurrency: {
      name: 'Filecoin',
      symbol: 'tFIL',
      decimals: 18,
    },
    rpcUrls: {
      default: {
        http: ['https://api.calibration.node.glif.io/rpc/v1'],
      },
    },
    blockExplorers: {
      default: {
        name: 'Filfox',
        url: 'https://calibration.filfox.info/en',
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

const chains = [
  mainnet,
  // optimism,
  // gnosis,
  // polygon,
  // customChains.sonic,
  // fantom,
  // base,
  // customChains.mode,
  // arbitrum,
  // customChains.bera,
  // customChains.katana
  customChains.filecoin,
  customChains.filecoinCalibration
]

export default chains
