# RewardCity - RWCT Token

## English

### Overview

**RewardCity** is an ERC20 smart contract that implements a basic token called **RWCT**, with functionalities such as transfers, approvals, and events.

---

### Requirements

- **Node.js** (recommended: version 20 or higher)
- **NPM**
- **Hardhat**

---

### Usage Instructions

#### 1. Clone the Repositorynpx hardhat test

git clone https://github.com/tales1982/RewardCity

cd RewardCity

2. Install Dependencies

`npm install`

3. Compile the Contract

To compile the RewardCity contract, run:

`npx hardhat compile`

If the compilation is successful, the artifact files will be created in the artifacts/ folder.

4. Deploy the Contract to a Local Network
Start the Hardhat local network:
npx hardhat node

Deploy the contract:
`npx hardhat run scripts/deploy.js --network localhost`
Note the contract address displayed in the terminal.

5. Test the Contract
To run automated tests:
`npx hardhat test`

Token Functionality
name(): Returns the name of the token ("RewardCity").
symbol(): Returns the token symbol ("RWCT").
decimals(): Returns the number of decimal places (18).
totalSupply(): Returns the total supply of tokens.
transfer(address, uint256): Transfers tokens to another user.
approve(address, uint256): Approves another user to spend tokens on your behalf.
transferFrom(address, address, uint256): Transfers tokens from one address to another, with permission.
balanceOf(address): Returns the balance of a user.
License
This project is licensed under the MIT license.
# How to Deploy the RewardCity Contract
# # # Prerequisites
1. **Node.js**
- Make sure you have Node.js installed (version 20 or higher).
2. **MetaMask Account**
- Set up a MetaMask account with the desired network (testnet or mainnet).
3. **Private Key and Alchemy**
- **Private Key:** Extracted from MetaMask.
- **RPC API URL:** Use Alchemy or another provider for the desired network.
### Project Setup

#### 1. Configure Environment Variables
Create an `.env` file in the root of the project with the following variables:

```
ALCHEMY_API_URL=<ALCHEMY_API_URL>
PRIVATE_KEY=<YOUR_PRIVATE_KEY>
```

**Example:**

```
ALCHEMY_API_URL=https://polygon-mumbai.g.alchemy.com/v2/your-api-key
PRIVATE_KEY=00000000000000000000000000000000000000000000000000000000000000000
```

#### 2. Check the `hardhat.config.js` File
Make sure the `hardhat.config.js` file is `hardhat.config.js` is configured for the desired network:

### Deploy Script
Make sure the `scripts/deploy.js` file is configured correctly:

### Performing the Deployment

#### 1. Make sure you are using the correct version of Node.js
```bash
nvm use 20
```

#### 2. Compile the Contract
```bash
npx hardhat compile
```

#### 3. Perform the Deployment
```bash
npx hardhat run scripts/deploy.js --network sepolia

```

### Expected Result
If the deploy is successful, you will see something like:

```
RewardCity deployed to: 0x0000000000000000000000000000000000000000
```

The address displayed is where the contract was deployed on the network.

### Verifying the Contract

1. **Access a Block Explorer**
- Use a compatible explorer (such as PolygonScan for Polygon networks).

2. **Enter Contract Address**
- Paste the address of the deployed contract to verify its existence and interact with it.

### Additional Tips

- **Get Faucet Tokens:**
- To interact with the testnet, get test tokens using faucets such as [Polygon Faucet](https://faucet.polygon.technology/).

- **Fix Common Errors:**
- **Invalid Private Key:** Make sure the private key is valid and 64 characters long. - **Incorrect Chain ID:** Make sure the `chainId` in `hardhat.config.js` matches the network configured in Alchemy and MetaMask.

# ERC20 Standard Features

1. **totalSupply:**
Returns the total tokens issued in the contract.

2. **balanceOf:**
Returns the token balance of a specific account.

3. **transfer:**
Allows the sender to transfer tokens to a recipient, minus a transaction fee.

4. **allowance:**
Returns the amount an address is authorized to spend from another address.

5. **approve:**
Authorizes an address to spend a specified amount of tokens on behalf of the sender.

6. **transferFrom:**
Transfers tokens from one account to another using the permission previously granted by approve.

## Additional Features

### Tokenomics

7. **Transaction Fee (_transactionFee):**
Fee applied to each token transfer.

Configurable by the owner up to a limit of 5%.

8. **Treasury (_treasury):**
Address that accumulates transaction fees.
Can be updated by the owner.

## Security

9. **Blacklist (blacklistAddress, isBlacklisted):**
Allows the owner to add or remove addresses from the blacklist.
Transfers involving blacklisted addresses are blocked.

10. **Pause and Resume Functions (pauseTransfers, unpauseTransfers):**
Allows the owner to pause and resume token transfers in case of emergency.

11. **Reentrant Protection (nonReentrant):**
Prevents reentrant attacks on critical functions.

## Token Manipulation

12. **Token Burn (burn):**
Allows a user to reduce their token holdings, decreasing the total tokens issued.

13. **Token Minting (Mint):**
Allows the owner to mint new tokens and credit them to a specific address.

## Other Features

14. **Name and Symbol Settings:**
name: Name of the token ("RewardCity").
symbol: Symbol of the token ("REWA").

15. **Decimals:**
Sets the minimum unit of the token to 10^(-18).

## Events

16. **Transfer:**
Issued on token transfers, including burns and rewards.

17. **Approval:**
Issued when granting permission to an address to spend tokens.