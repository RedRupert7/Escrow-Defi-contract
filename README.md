# DeFi Escrow Smart Contract (Clarity)

## Overview
This project is a **secure decentralized escrow smart contract** built using **Clarity** on the **Stacks blockchain**. It facilitates escrow transactions between buyers and sellers, ensuring funds are securely held until the agreed conditions are met. It also incorporates user verification to enhance security.

## Features
- **Escrow creation**: Buyers can create an escrow agreement with sellers.
- **Escrow funding**: Buyers deposit funds into the escrow smart contract.
- **Funds release**: Sellers can claim funds once conditions are met.
- **Escrow cancellation**: Buyers can cancel the escrow before funding.
- **Dispute mechanism**: Either party can dispute the escrow if issues arise.
- **User verification**: Only verified users can participate in escrow transactions.

## Smart Contract Functions
### **User Verification**
- `verify-user(user principal)`: Marks a user as verified.
- `is-verified(user principal)`: Checks if a user is verified.

### **Escrow Management**
- `create-escrow(seller principal, amount uint)`: Creates an escrow agreement.
- `fund-escrow(seller principal)`: Funds an existing escrow.
- `release-funds(buyer principal)`: Releases escrowed funds to the seller.
- `cancel-escrow(seller principal)`: Cancels an escrow (only if not funded).
- `dispute-escrow(buyer principal)`: Disputes an existing escrow transaction.

## Security Measures
- **User verification requirement**: Only verified users can create, fund, or release escrow funds.
- **Immutable transaction tracking**: All transactions are recorded on the blockchain.
- **Dispute resolution mechanism**: Allows disputes to be raised for arbitration.

## How to Deploy
1. **Set up Clarity environment**: Install Clarity tools and dependencies.
2. **Deploy the smart contract**: Use the Stacks CLI or Clarity IDE.
3. **Interact with the contract**: Use the Stacks explorer or API to call contract functions.

## License
This project is open-source and licensed under the MIT License.

