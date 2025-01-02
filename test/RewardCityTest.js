const { expect } = require("chai");

describe("RewardCity", function () {
  let rewardCity;
  let owner, addr1, addr2;

  beforeEach(async function () {
    // Get test accounts
    [owner, addr1, addr2] = await ethers.getSigners();

    // Deploy the contract
    const RewardCity = await ethers.getContractFactory("RewardCity");
    rewardCity = await RewardCity.deploy();
    await rewardCity.waitForDeployment();
  });

  it("Should return the correct token name", async function () {
    expect(await rewardCity.name()).to.equal("RewardCity");
  });

  it("Should return the correct token symbol", async function () {
    expect(await rewardCity.symbol()).to.equal("RWCT");
  });

  it("Should return the correct number of decimals", async function () {
    expect(await rewardCity.decimals()).to.equal(18);
  });

  it("Should return the correct totalSupply", async function () {
    const totalSupply = await rewardCity.totalSupply();
    expect(BigInt(totalSupply)).to.equal(BigInt("100000000000000000000000"));
  });

  it("Should assign the entire initial supply to the owner", async function () {
    const balance = await rewardCity.balanceOf(owner.address);
    expect(BigInt(balance)).to.equal(BigInt("100000000000000000000000"));
  });

  it("Should allow transfers between accounts", async function () {
    await rewardCity.transfer(addr1.address, BigInt("1000000000000000000")); // 1 token
    const balance1 = await rewardCity.balanceOf(addr1.address);
    const balanceOwner = await rewardCity.balanceOf(owner.address);

    expect(BigInt(balance1)).to.equal(BigInt("1000000000000000000"));
    expect(BigInt(balanceOwner)).to.equal(BigInt("99999000000000000000000"));
  });

  it("Should emit a Transfer event when transferring tokens", async function () {
    await expect(rewardCity.transfer(addr1.address, BigInt("1000000000000000000")))
      .to.emit(rewardCity, "Transfer")
      .withArgs(owner.address, addr1.address, BigInt("1000000000000000000"));
  });

  it("Should allow approving another address to spend tokens", async function () {
    await rewardCity.approve(addr1.address, BigInt("5000000000000000000")); // 5 tokens
    const allowance = await rewardCity.allowances(owner.address, addr1.address);

    expect(BigInt(allowance)).to.equal(BigInt("5000000000000000000"));
  });

  it("Should emit an Approval event when approving tokens", async function () {
    await expect(rewardCity.approve(addr1.address, BigInt("5000000000000000000")))
      .to.emit(rewardCity, "Approval")
      .withArgs(owner.address, addr1.address, BigInt("5000000000000000000"));
  });

  it("Should allow transfers using transferFrom", async function () {
    await rewardCity.approve(addr1.address, BigInt("5000000000000000000")); // 5 tokens
    await rewardCity.connect(addr1).transferFrom(owner.address, addr2.address, BigInt("1000000000000000000")); // 1 token

    const balanceOwner = await rewardCity.balanceOf(owner.address);
    const balance2 = await rewardCity.balanceOf(addr2.address);

    expect(BigInt(balanceOwner)).to.equal(BigInt("99999000000000000000000"));
    expect(BigInt(balance2)).to.equal(BigInt("1000000000000000000"));
  });

  it("Should emit a Transfer event when using transferFrom", async function () {
    await rewardCity.approve(addr1.address, BigInt("5000000000000000000"));
    await expect(rewardCity.connect(addr1).transferFrom(owner.address, addr2.address, BigInt("1000000000000000000")))
      .to.emit(rewardCity, "Transfer")
      .withArgs(owner.address, addr2.address, BigInt("1000000000000000000"));
  });

  it("Should reject transfers with insufficient balance", async function () {
    await expect(rewardCity.connect(addr1).transfer(addr2.address, BigInt("1000000000000000000")))
      .to.be.revertedWith("Insufficient balance");
  });

  it("Should reject transfers with insufficient allowance", async function () {
    await rewardCity.approve(addr1.address, BigInt("500000000000000000"));
    await expect(rewardCity.connect(addr1).transferFrom(owner.address, addr2.address, BigInt("1000000000000000000")))
      .to.be.revertedWith("Insufficient allowance");
  });
});
