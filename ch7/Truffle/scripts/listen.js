import Web3 from "web3";
import FaucetArtifact from "../build/contracts/Faucet.json" assert { type: "json" };

const RPC_URL = "https://ethereum-holesky.publicnode.com";
const CONTRACT_ADDRESS = ""; // 네가 배포한 Faucet 주소

const web3 = new Web3(RPC_URL);
const contract = new web3.eth.Contract(FaucetArtifact.abi, CONTRACT_ADDRESS);

async function main() {
  console.log("📜 과거 이벤트 조회 시작...");
  
  try {
    const events = await contract.getPastEvents("allEvents", {
      fromBlock: 0,
      toBlock: "latest",
    });

    if (events.length === 0) {
      console.log("❗ 조회된 이벤트가 없습니다.");
    }

    for (const event of events) {
      console.log(`🟢 [${event.event}]`);
      console.log(event.returnValues);
    }
  } catch (err) {
    console.error("❌ 이벤트 조회 실패:", err);
  }
}

main();
