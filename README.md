# DEX Platform

A decentralized exchange (DEX) platform inspired by Uniswap V2, built from scratch as a comprehensive Web3 portfolio project.

## Architecture

The platform uses a constant product automated market maker (AMM) model ($x \cdot y = k$).

- **DEXFactory**: Registry for trading pairs. Uses `CREATE2` for deterministic pair addresses.
- **DEXPair**: Core AMM logic. Handles reserves, swaps, and minting/burning of LP tokens. Each pair is its own ERC20 token representing liquidity provider shares.
- **DEXRouter**: User-facing contract for multi-hop swaps, slippage protection, and automated liquidity calculations.

## Features

- **Token Swaps**: Swap ERC20 tokens with a 0.3% protocol fee.
- **Liquidity Provision**: Add or remove liquidity to earn trading fees.
- **LP Tokens**: Proportional share representation for liquidity providers.
- **Slippage Protection**: Ensure transactions revert if the price impact is too high.
- **Deadline Checks**: Protect users from long-pending transactions.
- **Modern UI**: A sleek, glassmorphism-style dashboard for swapping and pooling.

## Tech Stack

- **Smart Contracts**: Solidity 0.8.24, Foundry (Testing & Deployment), OpenZeppelin.
- **Frontend**: React, Vite, CSS (Vanilla Glassmorphism), ethers.js.

## Getting Started

### Smart Contracts (dex-contracts)

1. Navigate to the directory:
   ```bash
   cd dex-contracts
   ```
2. Build the contracts:
   ```bash
   forge build
   ```
3. Run tests:
   ```bash
   forge test
   ```

### Frontend (dex-frontend)

1. Navigate to the directory:
   ```bash
   cd dex-frontend
   ```
2. Install dependencies:
   ```bash
   npm install
   ```
3. Run the development server:
   ```bash
   npm run dev
   ```

## License

MIT
