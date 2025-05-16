# 🧪 Chainlink ETH/USD Oracle 실습 가이드 (Sepolia 테스트넷)

이 가이드는 **Truffle 개발환경에서 Chainlink 오라클을 활용하여 ETH/USD 실시간 가격을 불러오는 과정**을 상세히 설명합니다.  
테스트넷은 Sepolia를 사용하며, Infura/Alchemy 없이도 **공용 RPC**만으로 실습이 가능합니다.

---

## ✅ 환경 구성 요약

- 테스트넷: Sepolia
- 개발 프레임워크: Truffle
- 오라클: Chainlink Price Feed (ETH/USD)
- 사용 도구: Truffle, dotenv, @chainlink/contracts

---

## 📁 1. 프로젝트 초기화

```bash
mkdir chainlink-ethusd-oracle
cd chainlink-ethusd-oracle
truffle init
npm init -y
```

---

## 📦 2. 패키지 설치

```bash
npm install @truffle/hdwallet-provider dotenv @chainlink/contracts
```

---

## 🔐 3. `.env` 파일 생성

```bash
touch .env
```

```env
PRIVATE_KEY=your_private_key_without_0x
SEPOLIA_RPC_URL=https://ethereum-sepolia.publicnode.com
```

---

## ⚙️ 4. `truffle-config.js` 설정

```js
require("dotenv").config();
const HDWalletProvider = require("@truffle/hdwallet-provider");

const privateKey = process.env.PRIVATE_KEY;
const sepoliaRpc = process.env.SEPOLIA_RPC_URL;

module.exports = {
  networks: {
    sepolia: {
      provider: () =>
        new HDWalletProvider({
          privateKeys: [privateKey],
          providerOrUrl: sepoliaRpc,
        }),
      network_id: 11155111,
      gas: 6000000,
      gasPrice: 15000000000, // 15 Gwei 이상 권장
    },
  },
  compilers: {
    solc: {
      version: "0.8.20",
    },
  },
};
```

---

## 🧾 5. Chainlink 인터페이스 파일 준비

```bash
mkdir -p contracts/interfaces
```

```solidity
// contracts/interfaces/AggregatorV3Interface.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface AggregatorV3Interface {
  function decimals() external view returns (uint8);
  function description() external view returns (string memory);
  function version() external view returns (uint256);

  function getRoundData(uint80 _roundId)
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );

  function latestRoundData()
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );
}
```

---

## 🧠 6. 스마트 컨트랙트 작성

```bash
mkdir contracts
touch contracts/ChainlinkEthUsdConsumer.sol
```

```solidity
// contracts/ChainlinkEthUsdConsumer.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./interfaces/AggregatorV3Interface.sol";

contract ChainlinkEthUsdConsumer {
    AggregatorV3Interface internal priceFeed;

    constructor(address aggregator) {
        priceFeed = AggregatorV3Interface(aggregator);
    }

    function getLatestPrice() public view returns (int256) {
        (, int256 price,,,) = priceFeed.latestRoundData();
        return price;
    }

    function getDecimals() public view returns (uint8) {
        return priceFeed.decimals();
    }
}
```

---

## 🚀 7. 마이그레이션 스크립트 작성

```bash
mkdir migrations
touch migrations/1_deploy.js
```

```js
// migrations/1_deploy.js

const ChainlinkEthUsdConsumer = artifacts.require("ChainlinkEthUsdConsumer");

module.exports = async function (deployer) {
  const aggregatorAddress = "0x694AA1769357215DE4FAC081bf1f309aDC325306"; // Sepolia ETH/USD feed
  await deployer.deploy(ChainlinkEthUsdConsumer, aggregatorAddress);
};
```

---

## 🔨 8. 컴파일 및 배포

```bash
truffle compile
truffle migrate --network sepolia
```

---

## 🧪 9. Truffle 콘솔에서 테스트

```bash
truffle console --network sepolia
```

```js
let c = await ChainlinkEthUsdConsumer.deployed()
(await c.getLatestPrice()).toString()  // 예: '259618002800'
(await c.getDecimals()).toString()     // 예: '8'
```

> ✅ `259618002800` = 2596.18002800 USD (소수점 8자리 기준)

---

## ✅ 실습 완료!

이제 Chainlink를 활용한 Oracle 기반 가격 피드 연동을 마쳤습니다.  
다음 단계로는 아래와 같은 확장이 가능합니다:

- 프론트엔드에서 실시간 가격 표시 (React + ethers.js)
- Chainlink VRF (무작위 숫자) 오라클 연동
- Chainlink Automation을 통한 주기적 트리거

---

## 📂 폴더 구조 예시

```
chainlink-ethusd-oracle/
├── contracts/
│   ├── ChainlinkEthUsdConsumer.sol
│   └── interfaces/
│       └── AggregatorV3Interface.sol
├── migrations/
│   └── 1_deploy.js
├── .env
├── truffle-config.js
└── package.json
```

---

🛡️ 테스트넷용 키와 프라이빗키는 `.env`를 통해 안전하게 관리하세요!  
Git 업로드 전에는 반드시 `.gitignore`에 `.env` 추가하세요.