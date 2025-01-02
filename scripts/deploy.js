const hre = require("hardhat");

async function main() {
  // Get the contract factory
  const RewardCity = await hre.ethers.getContractFactory("RewardCity");

  // Deploy the contract
  const rewardCity = await RewardCity.deploy();

  // Wait for deployment to complete
  await rewardCity.waitForDeployment(); // Updated for Ethers.js 6.x

  // Log the deployed contract address
  console.log("RewardCity deployed to:", await rewardCity.getAddress());
}

// Run the main deployment function
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
