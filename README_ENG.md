# RewardCity - Token RWCT

## Overview

**RewardCity** is an ERC20 smart contract that implements a basic token named **RWCT**, with functionalities such as transfers, approvals, and events.

---

## Requirements

- **Node.js** (recommended: version 20 or higher)
- **NPM**
- **Hardhat**

---

## Usage Instructions

### 1. Clone the Repository

```bash
git clone <REPOSITORY_URL>
cd RewardCity
2. Install Dependencies
bash
Copiar código
npm install
3. Compile the Contract
To compile the RewardCity contract, run:

bash
Copiar código
npx hardhat compile
If successful, the artifact files will be created in the artifacts/ folder.

4. Deploy the Contract on a Local Network
Start the Hardhat local network:

bash
Copiar código
npx hardhat node
Deploy the contract:

bash
Copiar código
npx hardhat run scripts/deploy.js --network localhost
Note the contract address displayed in the terminal.

5. Test the Contract
To run the automated tests:

bash
Copiar código
npx hardhat test
Token Functionalities
name(): Returns the token name ("RewardCity").
symbol(): Returns the token symbol ("RWCT").
decimals(): Returns the number of decimal places (18).
totalSupply(): Returns the total token supply.
transfer(address, uint256): Transfers tokens to another user.
approve(address, uint256): Approves another user to spend tokens on your behalf.
transferFrom(address, address, uint256): Transfers tokens from one address to another, with permission.
balanceOf(address): Returns the balance of a user.
License
This project is licensed under the MIT License.

css
Copiar código

Você pode usar este arquivo como seu `README.md` no repositório para a versão em inglês.












