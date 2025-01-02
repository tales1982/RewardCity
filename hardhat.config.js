require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

module.exports = {
  solidity: "0.8.24",
  networks: {
    polygonAmoyTestnet: {
      url: process.env.ALCHEMY_API_URL,
      accounts: [process.env.PRIVATE_KEY],
      chainId: 80002, // Verifique se o Chain ID da Amoy é 80001 ou outro específico
    },
  },
};
