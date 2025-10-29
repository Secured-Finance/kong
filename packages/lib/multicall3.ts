import { arbitrum, mainnet } from 'viem/chains'
import { customChains } from './chains'
// const { mode, sonic, bera, katana } = customChains
const { filecoin } = customChains

export const activations = {
  [mainnet.id]: BigInt(mainnet.contracts.multicall3.blockCreated),
  [arbitrum.id]: BigInt(arbitrum.contracts.multicall3.blockCreated),
  [filecoin.id]: BigInt(filecoin.contracts.multicall3.blockCreated)
}

export function getActivation(chainId: number) {
  if(!Object.keys(activations).includes(chainId.toString())) {
    throw new Error(`Chain ${chainId} not supported`)
  }
  return activations[chainId as keyof typeof activations]
}

export function supportsBlock(chainId: number, blockNumber: bigint) {
  if(!Object.keys(activations).includes(chainId.toString())) {
    throw new Error(`Chain ${chainId} not supported`)
  }

  return blockNumber >= activations[chainId as keyof typeof activations]
}
