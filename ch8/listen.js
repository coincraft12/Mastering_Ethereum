import Web3 from "web3";
import fs from "fs";
import dotenv from "dotenv";
dotenv.config();

// === 설정 ===
const RPC_URL = process.env.RPC_URL;
const CONTRACT_ADDRESS = ""; // ← 실제 배포 주소로 교체
const ABI = JSON.parse(fs.readFileSync("faucet.abi", "utf8"));

const web3 = new Web3(RPC_URL);
const contract = new web3.eth.Contract(ABI, CONTRACT_ADDRESS);

const FROM_BLOCK = 0;
const TO_BLOCK = "latest";

async function main() {
  console.log(`📜 과거 이벤트 전체 조회 시작...`);

  try {
    // Deposit 이벤트
    const deposits = await contract.getPastEvents("Deposit", {
        fromBlock: FROM_BLOCK,
        toBlock: TO_BLOCK,
      });
      for (const e of deposits) {
        const { sender, amount } = e.returnValues;
        if (!amount) {
          console.log(`❌ 잘못된 Deposit 이벤트 (sender: ${sender})`, e.returnValues);
          continue;
        }
        const amountEth = web3.utils.fromWei(amount.toString(), "ether");
        console.log(`📥 Deposit | From: ${sender} | Amount: ${amountEth} ETH`);
      }

    // Withdrawal 이벤트
    const withdrawals = await contract.getPastEvents("Withdrawal", {
      fromBlock: FROM_BLOCK,
      toBlock: TO_BLOCK,
    });
    for (const e of withdrawals) {
        const { receiver, amount } = e.returnValues;
        if (!amount) {
          console.log("❌ 잘못된 Withdrawal 이벤트", e.returnValues);
          continue;
        }
        const amountEth = web3.utils.fromWei(amount.toString(), "ether");
        console.log(`📤 Withdrawal | To: ${receiver} | Amount: ${amountEth} ETH`);
    }

    // LimitChanged 이벤트
    const limits = await contract.getPastEvents("LimitChanged", {
      fromBlock: FROM_BLOCK,
      toBlock: TO_BLOCK,
    });
    for (const e of limits) {
        const { new_limit } = e.returnValues;
        if (!new_limit) {
          console.log("❌ 잘못된 LimitChanged 이벤트", e.returnValues);
          continue;
        }
        const limitEth = web3.utils.fromWei(new_limit.toString(), "ether");
        console.log(`⚙️ LimitChanged | New Limit: ${limitEth} ETH`);
    }

    console.log("✅ 이벤트 전체 조회 완료!");
  } catch (err) {
    console.error("❌ 이벤트 조회 실패:", err.message);
  }
}

main();
