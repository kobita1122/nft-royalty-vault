# NFT Royalty Vault

This repository contains a professional-grade Solidity smart contract for handling secondary sale royalties. It allows project owners to collect funds in a central vault and enables stakeholders to withdraw their share based on pre-defined percentages.

### Features
* **Automated Distribution:** Splitting logic handles precise calculations for multiple addresses.
* **Pull-Payment Pattern:** Secure withdrawal pattern to prevent "reentrancy" and "gas limit" issues.
* **Transparent Accounting:** Total funds received and shares already released are tracked on-chain.

### Usage
1. Deploy the `RoyaltyVault.sol` with a list of stakeholder addresses and their respective shares.
2. Set this contract address as the recipient of royalties on NFT marketplaces (OpenSea, Rarible, etc.).
3. Stakeholders can call the `release()` function at any time to claim their accrued ETH.
