const METoken = artifacts.require("METoken");

module.exports = function (deployer) {
  const initialSupply = 21_000_000; // 21 million MET
  deployer.deploy(METoken, initialSupply);
};
