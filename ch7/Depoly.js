import fs from "fs";
import Web3 from "web3";

// === RPC & 계정 설정 ===
const RPC_URL = "https://holesky.gateway.tenderly.co";
const PRIVATE_KEY = ""; // 테스트용

// === ABI & Bytecode 로드 ===
const abi = JSON.parse(fs.readFileSync("Example_DataType_sol_Example_DataType.abi", "utf8"));
const bytecode = fs.readFileSync("Example_DataType_sol_Example_DataType.bin", "utf8");

// === Web3 인스턴스 생성 ===
const web3 = new Web3(RPC_URL);

// === 계정 설정 ===
const account = web3.eth.accounts.privateKeyToAccount(PRIVATE_KEY);
web3.eth.accounts.wallet.add(account);
web3.eth.defaultAccount = account.address;

console.log(`배포 계정: ${account.address}`);

try {

  const chainId = await web3.eth.getChainId();
  const blockNum = await web3.eth.getBlockNumber();
  console.log(`현재 연결된 체인 ID: ${chainId}`);
  console.log(`현재 블록 번호: ${blockNum}`);

  // === 잔액 출력 ===
  const balance = await web3.eth.getBalance(account.address);
  console.log(`현재 잔액: ${web3.utils.fromWei(balance, "ether")} ETH`);

  // === 컨트랙트 인스턴스 생성 ===
  const contract = new web3.eth.Contract(abi);
  const tx = contract.deploy({
    data: "0x" + bytecode,
    arguments: [] // 생성자 인자 필요 시 입력
  });

  // === 가스 수동 지정 ===
  const gasLimit = 3_000_000;

  // === 트랜잭션 전송 ===
  const deployed = await tx.send({
    from: account.address,
    gas: gasLimit,
  });

  console.log(`🎉 컨트랙트 배포 완료! 주소: ${deployed.options.address}`);
} catch (err) {
  console.error("❌ 배포 중 오류 발생:", err.message || err);
}
