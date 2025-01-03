const hre = require("hardhat");

async function main() {
  const accounts = await hre.ethers.getSigners();

  if (accounts.length < 2) {
    throw new Error("Not enough accounts are configured. Ensure at least two accounts are available.");
  }

  const owner = accounts[0];
  const treasury = accounts[1];

  console.log(`Deploying contract with owner: ${owner.address}`);
  console.log(`Treasury address: ${treasury.address}`);

  const RewardCity = await hre.ethers.getContractFactory("RewardCity");
  const rewardCity = await RewardCity.deploy(owner.address, treasury.address); // Deploy o contrato

  // Espere pela confirmação da transação de deploy
  await rewardCity.waitForDeployment();

  console.log(`RewardCity deployed to: ${rewardCity.target}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
