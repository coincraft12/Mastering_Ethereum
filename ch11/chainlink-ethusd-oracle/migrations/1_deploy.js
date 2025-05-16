// migrations/1_deploy.js

const ChainlinkEthUsdConsumer = artifacts.require("ChainlinkEthUsdConsumer");

module.exports = async function (deployer) {
  const aggregatorAddress = "0x694AA1769357215DE4FAC081bf1f309aDC325306"; // Sepolia ETH/USD feed
  await deployer.deploy(ChainlinkEthUsdConsumer, aggregatorAddress);
};