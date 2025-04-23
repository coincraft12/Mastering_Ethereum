import Web3 from "web3";
import dotenv from "dotenv";
dotenv.config();

const RPC_URL = process.env.RPC_URL;
const CONTRACT_ADDRESS = ""; // 여기에 컨트랙트 주소 입력

const web3 = new Web3(RPC_URL);

const checkBalance = async () => {
  const balance = await web3.eth.getBalance(CONTRACT_ADDRESS);
  console.log(`💰 컨트랙트 잔액: ${web3.utils.fromWei(balance, "ether")} ETH`);
};

checkBalance();
