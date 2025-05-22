const DeedRepository = artifacts.require("DeedRepository");
const AuctionRepository = artifacts.require("AuctionRepository");

module.exports = async function (deployer, network, accounts) {
  await deployer.deploy(DeedRepository, accounts[0]);
  const deedInstance = await DeedRepository.deployed();
  console.log("DeedRepository deployed at:", deedInstance.address);

  await deployer.deploy(AuctionRepository);
  const auctionInstance = await AuctionRepository.deployed();
  console.log("AuctionRepository deployed at:", auctionInstance.address);
};
