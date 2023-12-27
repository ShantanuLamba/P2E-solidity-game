# Solidity P2E Simple Game

## Overview
This repository contains the code for a Play-to-Earn (P2E) game developed in Solidity, a programming language for writing smart contracts on various blockchain platforms. In this game, users can bet tokens and have a chance to win up to 5 times their stake based on random outcomes.

## Files in the Repository
There are two main Solidity files in this repository:

1. **game.sol**: This file contains the smart contract for the game using block randomness. While this method is straightforward, it's important to note that using block properties (like blockhash) for randomness can be insecure in certain contexts, as it might be predictable to an extent.

2. **gamevrf.sol**: This is an improved version of the game contract using Chainlink's Verifiable Random Function (VRF). Chainlink VRF provides secure and verifiable randomness, making it a more reliable choice for decentralized applications that require random number generation. This approach is recommended for production environments.

## How to Play
- To play the game, users need to bet a certain amount of tokens.
- The smart contract then generates a random number.
- If the number meets certain pre-defined criteria, the user wins and earns up to 5 times their bet.

## Security Considerations
- **game.sol**: As it uses block randomness, it's more vulnerable to manipulation and is not recommended for environments where security is a primary concern.
- **gamevrf.sol**: Utilizes Chainlink VRF for randomness, ensuring fair play and security against manipulation.

## Getting Started
To get started with this project:

1. Clone the repository.
2. Compile the smart contracts using `truffle compile` or a similar tool or use remix for simplicity.
3. Deploy the contracts to a testnet (like Goerli or sepolia) for testing.

## Contributing
Contributions are welcome! 


---

**Disclaimer**: This project is for educational purposes only and is not intended for use in production environments where real assets are at stake.
