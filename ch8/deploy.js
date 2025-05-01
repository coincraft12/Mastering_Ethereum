import fs from "fs";
import Web3 from "web3";
import dotenv from "dotenv";
dotenv.config();

// === 환경 설정 ===
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const RPC_URL = process.env.RPC_URL;

const abi = JSON.parse(fs.readFileSync("faucet.abi", "utf8"));
const bytecodeRaw = fs.readFileSync("faucet.bytecode", "utf8").trim();
const bytecode = bytecodeRaw.startsWith("0x") ? bytecodeRaw : "0x" + bytecodeRaw;

const web3 = new Web3(RPC_URL);
const account = web3.eth.accounts.privateKeyToAccount(PRIVATE_KEY);
web3.eth.accounts.wallet.add(account);
web3.eth.defaultAccount = account.address;

console.log(`🔐 배포 계정: ${account.address}`);

const deploy = async () => {
  try {
    const Contract = new web3.eth.Contract(abi);
    const tx = Contract.deploy({ data: bytecode });

    const gas = await tx.estimateGas({ from: account.address });
    const gasLimit = gas + 50000n;

    const deployed = await tx.send({
      from: account.address,
      gas: gasLimit,
    });

    console.log(`✅ 컨트랙트 배포 성공! 주소: ${deployed.options.address}`);
  } catch (err) {
    console.error("❌ 배포 중 오류 발생:", err);
  }
};

deploy();
