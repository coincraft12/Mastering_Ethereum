# 🏗 Ethereum Auction DApp on Holesky (Truffle + Vue)

이 프로젝트는 `ERC721` 기반 NFT 경매 DApp을 Holesky 테스트넷에 Truffle을 사용해 배포하고, 스마트 컨트랙트를 테스트하는 실습입니다.

## 🧰 프로젝트 환경 구성

```bash
truffle init
npm init -y
npm install --save dotenv
npm install --save-dev @truffle/hdwallet-provider
```

## 📁 폴더 구조 예시

```bash
.
├── contracts/
│   ├── DeedRepository.sol
│   └── AuctionRepository.sol
├── migrations/
│   ├── 1_deploy_contracts.js
├── truffle-config.js
├── .env
└── README.md
```

## 🔐 .env 파일 설정 (경매 - 입찰을 위해서 두개의 계정 필요)

```env
PRIVATE_KEYS=0x<첫번째_프라이빗키>,0x<두번째_프라이빗키>
INFURA_PROJECT_ID=<infura_project_id>
```

## ⚙ truffle-config.js 설정 (Holesky)

```js
const HDWalletProvider = require('@truffle/hdwallet-provider');
require('dotenv').config();

const privateKeys = process.env.PRIVATE_KEYS.split(',');

module.exports = {
  networks: {
    holesky: {
      provider: () => new HDWalletProvider(
        privateKeys,
        `https://holesky.infura.io/v3/${process.env.INFURA_PROJECT_ID}`
      ),
      network_id: 17000,
      gas: 6000000,
      gasPrice: 10000000000,
      confirmations: 2,
      timeoutBlocks: 200,
      networkCheckTimeout: 100000,
      skipDryRun: true
    }
  },
  compilers: {
    solc: {
      version: "0.8.20",
      settings: {
        optimizer: {
          enabled: true,
          runs: 200
        }
      }
    }
  }
};
```

## 📜 스마트 컨트랙트 배포

```bash
truffle compile
truffle migrate --network holesky --reset
```

## 🧪 Truffle 콘솔 실행

```bash
truffle console --network holesky
```

### ▶️ 인스턴스 및 계정 로드

```js
const deed = await DeedRepository.deployed()
const auction = await AuctionRepository.deployed()
const accounts = await web3.eth.getAccounts()
```

### ▶️ NFT 민팅 및 경매 준비

```js
await deed.mint(accounts[0], { from: accounts[0] })
await deed.transferFrom(accounts[0], auction.address, 0, { from: accounts[0] })

const now = parseInt(Date.now() / 1000)
const deadline = now + 3600

await auction.createAuction(
  deed.address,
  0,
  "My First Auction",
  "Auction metadata here",
  web3.utils.toWei("0.1", "ether"),
  deadline,
  { from: accounts[0] }
)
```

### ▶️ 다른 계정으로 입찰

```js
await auction.bidOnAuction(0, {
  from: accounts[1],
  value: web3.utils.toWei("0.3", "ether")
})
```

### ▶️ 입찰 확인

```js
await auction.getCurrentBid(0)
```

### ▶️ 경매 종료 시간 확인

```js
const auc = await auction.getAuctionById(0)
const blockDeadline = auc[1].toNumber()
const now = parseInt(Date.now() / 1000)
blockDeadline - now
```

### ▶️ finalizeAuction 실행 (마감 이후)

```js
await auction.finalizeAuction(0, { from: accounts[0] })
```

### ▶️ 결과 확인

```js
await auction.getAuctionById(0)
await deed.ownerOf(0)
```

## ✅ 마무리

이 실습을 통해 NFT 발행 → 경매 등록 → 입찰 → 낙찰까지의 전체 DApp 흐름을 테스트넷에서 직접 구현해볼 수 있습니다.  
Web3 개발 여정의 훌륭한 출발점이 될 거예요 🚀

📚 정리자: Coincraft(2025년 최신 기준)