import Web3 from "web3";
import FaucetArtifact from "../build/contracts/Faucet.json" assert { type: "json" };

// ✅ Holesky HTTP RPC URL (Infura 등)
const RPC_HTTP = "https://holesky.infura.io/v3/394bd27afc274796bcffb691cdd64df7";
const CONTRACT_ADDRESS = "0xD1E4C7c049049D49D21170851529f60C0cfa1C07"; // 네가 배포한 Faucet 주소

const web3 = new Web3(RPC_HTTP);
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
