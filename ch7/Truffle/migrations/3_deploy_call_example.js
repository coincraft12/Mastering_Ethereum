const CalledContract = artifacts.require("CalledContract");
const CalledLibrary = artifacts.require("CalledLibrary");
const Caller = artifacts.require("Caller");

module.exports = async function (deployer) {
  await deployer.deploy(CalledContract);
  await deployer.deploy(CalledLibrary);
  await deployer.link(CalledLibrary, Caller);  // 🔗 라이브러리 링크!
  await deployer.deploy(Caller);
};
