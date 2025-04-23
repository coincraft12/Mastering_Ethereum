import Web3 from "web3";
import fs from "fs";
import dotenv from "dotenv";
dotenv.config();

const PRIVATE_KEY = process.env.PRIVATE_KEY;
const RPC_URL = process.env.RPC_URL;
const CONTRACT_ADDRESS = ""; // 컨트랙트 주소 입력
const ABI = JSON.parse(fs.readFileSync("faucet.abi", "utf8"));

const web3 = new Web3(RPC_URL);
const account = web3.eth.accounts.privateKeyToAccount(PRIVATE_KEY);
web3.eth.accounts.wallet.add(account);
web3.eth.defaultAccount = account.address;

const contract = new web3.eth.Contract(ABI, CONTRACT_ADDRESS);

async function withdraw() {
  try {
    const amountInEth = "0.05";
    const amountInWei = web3.utils.toWei(amountInEth, "ether");

    const tx = await contract.methods.withdraw(amountInWei).send({
      from: account.address,
      gas: 100_000, // 넉넉하게 설정
    });

    console.log(`✅ 출금 성공! Tx Hash: ${tx.transactionHash}`);
  } catch (err) {
    console.error("❌ 출금 실패:", err.message);
  }
}

withdraw();
