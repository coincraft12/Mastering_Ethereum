const Faucet = artifacts.require("Faucet");

module.exports = async function(callback) {
  try {
    const accounts = await web3.eth.getAccounts();
    const sender = accounts[0];

    const faucet = await Faucet.deployed();

    // Step 1: Faucet 컨트랙트에 이더 충전
    console.log("🪙 Faucet에 1 ETH 보내는 중...");
    await web3.eth.sendTransaction({
      from: sender,
      to: faucet.address,
      value: web3.utils.toWei("0.1", "ether")
    });

    // Step 2: 가스 가격 가져오기
    const gasPrice = await web3.eth.getGasPrice();
    console.log("✅ 현재 가스 가격:", gasPrice, "wei");

    // Step 3: withdraw 함수 가스 추정
    const gasEstimate = await faucet.withdraw.estimateGas(
      web3.utils.toWei("0.1", "ether"),
      { from: sender }
    );
    console.log("🧮 가스 예상량:", gasEstimate, "units");

    // Step 4: 총 비용 계산
    const totalGasCostWei = BigInt(gasEstimate) * BigInt(gasPrice);
    const totalGasCostEth = web3.utils.fromWei(totalGasCostWei.toString(), 'ether');

    console.log("💸 예상 가스 비용:", totalGasCostWei.toString(), "wei");
    console.log("💸 예상 가스 비용:", totalGasCostEth, "ether");

    callback();
  } catch (err) {
    console.error("❌ 에러 발생:", err);
    callback(err);
  }
};
