require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

module.exports = {
  solidity: "0.8.24",
  paths: {
    sources: "./contracts",
    artifacts: "./artifacts",
    cache: "./cache",
  },
  networks: {
    sepolia: {
      url: process.env.ALCHEMY_API_URL, // Substitua pelo link correto da Sepolia no Alchemy ou outro provedor
      accounts: process.env.PRIVATE_KEY ? [process.env.PRIVATE_KEY] : [],
      chainId: 11155111, // Chain ID da rede Sepolia
    },
    polygonAmoyTestnet: {
      url: process.env.ALCHEMY_API_URL,
      accounts: process.env.PRIVATE_KEY ? [process.env.PRIVATE_KEY] : [],
      chainId: 80002,
    },
  },
};
