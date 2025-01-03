const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("RewardCity", function () {
  let rewardCity;
  let owner, addr1, addr2, treasury;

  beforeEach(async function () {
    [owner, addr1, addr2, treasury] = await ethers.getSigners();

    const RewardCity = await ethers.getContractFactory("RewardCity");
    rewardCity = await RewardCity.deploy(owner.address, treasury.address);
    await rewardCity.waitForDeployment();
  });

  it("Should allow the owner to burn tokens", async function () {
    const initialBalance = await rewardCity.balanceOf(owner.address);
    const burnAmount = BigInt("5000000000000000000"); // 5 tokens
    await rewardCity.burn(burnAmount);
    const finalBalance = await rewardCity.balanceOf(owner.address);

    expect(finalBalance).to.equal(initialBalance - burnAmount);
  });

  it("Should reject burning more tokens than balance", async function () {
    const burnAmount = BigInt("200000000000000000000000"); // Exceeds total supply
    await expect(rewardCity.burn(burnAmount)).to.be.revertedWith(
      "Insufficient balance to burn"
    );
  });

  it("Should allow the owner to mint new tokens", async function () {
    const mintAmount = BigInt("1000000000000000000"); // 1 token
    await rewardCity.mint(addr1.address, mintAmount);
    const balance = await rewardCity.balanceOf(addr1.address);

    expect(balance).to.equal(mintAmount);
  });


  it("Should apply dynamic transaction fee correctly", async function () {
    await rewardCity.setTransactionFee(30); // 3%
    const transferAmount = BigInt("1000000000000000000"); // 1 token
    const fee = BigInt("30000000000000000"); // 3% de 1 token
    const amountAfterFee = transferAmount - fee;

    await rewardCity.transfer(addr1.address, transferAmount);
    const balanceAddr1 = await rewardCity.balanceOf(addr1.address);
    const balanceTreasury = await rewardCity.balanceOf(treasury.address);

    expect(balanceAddr1).to.equal(amountAfterFee);
    expect(balanceTreasury).to.equal(fee);
  });

  it("Should reject setting a transaction fee higher than 5%", async function () {
    await expect(rewardCity.setTransactionFee(60)).to.be.revertedWith(
      "Fee too high"
    );
  });

  it("Should add and remove addresses from blacklist", async function () {
    await rewardCity.blacklistAddress(addr1.address, true);
    expect(await rewardCity.isBlacklisted(addr1.address)).to.equal(true);

    await rewardCity.blacklistAddress(addr1.address, false);
    expect(await rewardCity.isBlacklisted(addr1.address)).to.equal(false);
  });

  it("Should reject transfers involving blacklisted addresses", async function () {
    await rewardCity.blacklistAddress(addr1.address, true);

    await expect(
      rewardCity.transfer(addr1.address, BigInt("1000000000000000000"))
    ).to.be.revertedWith("Recipient is blacklisted");
    await expect(
      rewardCity
        .connect(addr1)
        .transfer(addr2.address, BigInt("1000000000000000000"))
    ).to.be.revertedWith("Sender is blacklisted");
  });

  it("Should reject executing a proposal with blacklisted recipients", async function () {
    const recipients = [addr1.address, addr2.address];
    await rewardCity.createProposal("Distribute rewards", recipients);

    await rewardCity.blacklistAddress(addr1.address, true);
    await rewardCity.vote(0);

    await expect(rewardCity.executeProposal(0)).to.be.revertedWith(
      "Recipient is blacklisted"
    );
  });

  it("Should allow transferFrom with allowance", async function () {
    const allowanceAmount = BigInt("1000000000000000000"); // 1 token
    const transferAmount = BigInt("500000000000000000"); // 0.5 token

    await rewardCity.approve(addr1.address, allowanceAmount);
    await rewardCity
      .connect(addr1)
      .transferFrom(owner.address, addr2.address, transferAmount);

    const balanceAddr2 = await rewardCity.balanceOf(addr2.address);
    const remainingAllowance = await rewardCity.allowance(
      owner.address,
      addr1.address
    );

    expect(balanceAddr2).to.equal(transferAmount);
    expect(remainingAllowance).to.equal(allowanceAmount - transferAmount);
  });

  it("Should create and execute a campaign proposal", async function () {
    const recipients = [addr1.address, addr2.address];
    await rewardCity.createProposal("Distribute rewards", recipients);
  
    // Transfira tokens para addr1 e vote na proposta
    const voteAmount = BigInt("1000000000000000000"); // 1 token
    await rewardCity.transfer(addr1.address, voteAmount);
    await rewardCity.connect(addr1).vote(0);
  
    // Execute a proposta
    await rewardCity.executeProposal(0);
  
    // Verifique se a proposta foi executada
    const proposal = await rewardCity.proposals(0);
    expect(proposal.executed).to.equal(true);
  
    // Verifique os saldos atualizados
    const balance1 = await rewardCity.balanceOf(addr1.address);
    const balance2 = await rewardCity.balanceOf(addr2.address);
  
    expect(balance1).to.be.gt(0); // Saldo de addr1 deve aumentar
    expect(balance2).to.be.gt(0); // Saldo de addr2 deve aumentar
  });
  
  
  
  

});
