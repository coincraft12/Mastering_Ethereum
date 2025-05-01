const Example_DataType = artifacts.require("Example_DataType");

module.exports = async function (deployer) {
  await deployer.deploy(Example_DataType);
};