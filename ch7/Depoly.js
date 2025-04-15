const fs = require("fs");
const Web3 = require("web3");

// Holesky RPC (신뢰할 수 있는 엔드포인트 사용)
const RPC_URL = "https://rpc.holesky.ethpandaops.io";
const PRIVATE_KEY = "YOUR_HOLESKY_PRIVATE_KEY"; // 테스트용 개인키

const abi = JSON.parse(fs.readFileSync("MyContract_sol_MyContract.abi", "utf8"));
const bytecode = fs.readFileSync("MyContract_sol_MyContract.bin", "utf8");

const web3 = new Web3(RPC_URL);

(async () => {
  const account = web3.eth.accounts.privateKeyToAccount(PRIVATE_KEY);
  web3.eth.accounts.wallet.add(account);
  web3.eth.defaultAccount = account.address;

  console.log(`배포 계정: ${account.address}`);

  const contract = new web3.eth.Contract(abi);

  const tx = contract.deploy({
    data: "0x" + bytecode,
    arguments: [] // 생성자 인자 필요시 입력
  });

  const gas = await tx.estimateGas({ from: account.address });
  const deployed = await tx.send({
    from: account.address,
    gas
  });

  console.log(`컨트랙트 배포 완료! 주소: ${deployed.options.address}`);
})();
