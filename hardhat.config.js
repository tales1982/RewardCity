require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

module.exports = {
  solidity: "0.8.24",
  networks: {
    sepolia: {
      url: process.env.ALCHEMY_API_URL,
      accounts:
        process.env.PRIVATE_KEY && process.env.PRIVATE_KEY_TREASURY
          ? [process.env.PRIVATE_KEY, process.env.PRIVATE_KEY_TREASURY]
          : [],
      chainId: 11155111, // Chain ID da Sepolia
    },
  },
};
