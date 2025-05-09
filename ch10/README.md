# Mastering Ethereum - Chapter 10: ERC20 Token 실습 가이드

이 문서는 『Mastering Ethereum』 10장 토큰 챕터의 실습 내용을 최신 환경에 맞춰 정리한 가이드입니다.  
OpenZeppelin 기반 ERC20 토큰을 Holesky 테스트넷에 배포하고 테스트했으며, `transferFrom` 함수 테스트만 Ganache 로컬 환경에서 진행했습니다.

---

## ✅ 1. 환경 설정

```bash
# Truffle 프로젝트 생성
mkdir METoken && cd METoken
truffle init
npm init -y

# 필수 패키지 설치
npm install @openzeppelin/contracts dotenv @truffle/hdwallet-provider
```

---

## ✅ 2. 디렉토리 구조

```bash
METoken/
├── contracts/
│   ├── Migrations.sol
│   └── METoken.sol
├── migrations/
│   └── 2_deploy_contracts.js
├── test/
├── .env (직접 생성)
├── package.json
└── truffle-config.js
```

---

## ✅ 3. .env 파일 설정 예시

```env
PRIVATE_KEY=0x당신의프라이빗키
RPC_URL=https://rpc.ankr.com/eth_holesky
```

---

## ✅ 4. METoken.sol 작성

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract METoken is ERC20 {
    constructor(uint256 initialSupply) ERC20("Mastering Ethereum Token", "MET") {
        _mint(msg.sender, initialSupply * 10 ** decimals());
    }
}
```

---

## ✅ 5. 배포 스크립트 작성 (2_deploy_contracts.js)

```js
const METoken = artifacts.require("METoken");

module.exports = function (deployer) {
  const initialSupply = 21000000; // 21 million
  deployer.deploy(METoken, initialSupply);
};
```

---

## ✅ 6. truffle-config.js 설정 (Holesky 포함 예시)

```js
require('dotenv').config();
const HDWalletProvider = require('@truffle/hdwallet-provider');

module.exports = {
  networks: {
    holesky: {
      provider: () =>
        new HDWalletProvider({
          privateKeys: [process.env.PRIVATE_KEY],
          providerOrUrl: process.env.RPC_URL
        }),
      network_id: 17000,
      gas: 5500000,
      gasPrice: 1000000000,
      confirmations: 2,
      timeoutBlocks: 400,
      skipDryRun: true
    },
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*"
    }
  },
  compilers: {
    solc: {
      version: "0.8.20"
    }
  }
};
```

---

## ✅ 7. 배포 (Holesky 테스트넷)

### Holesky 배포

```bash
truffle migrate --network holesky --reset
```

---

## ✅ 8. 트러플 콘솔에서 실습 (Holesky 테스트넷)

```bash
truffle console --network holesky
```

### 기본 함수 사용

```js
let token = await METoken.deployed()
await token.name()        // "Mastering Ethereum Token"
await token.symbol()      // "MET"
(await token.totalSupply()).toString()
```

### 전송 실습

```js
let token = await METoken.deployed()

// 1 MET을 다른 주소로 전송 (단위는 18자리 소수 포함된 Wei)
let recipient = "0x다른주소여기에입력"
await token.transfer(recipient, web3.utils.toWei("1", "ether"))

// 잔액 확인
(await token.balanceOf(recipient)).toString()
```

---

## 🧪 MetaMask에 토큰 추가

- 토큰 계약 주소: `배포된 주소 입력`
- 심볼: `MET`
- 소수 자릿수: `18`

---

## approve & transferFrom 실습

### Ganache 로컬 배포 (`transferFrom` 전용 테스트용)

```bash
npx ganache
truffle migrate --network development --reset
```

### Truffle 콘솔에서 approve & transferFrom 실습

```bash
truffle console --network development
```

```js
// 계정 불러오기
let accounts = await web3.eth.getAccounts()
let owner = accounts[0]
let spender = accounts[1]
let recipient = accounts[2]

// 배포된 토큰 인스턴스
let token = await METoken.deployed()

// 1. owner가 spender에게 5 MET 위임
await token.approve(spender, web3.utils.toWei("5", "ether"), {from: owner})

// 2. allowance 확인
(await token.allowance(owner, spender)).toString()
// 결과: 5000000000000000000

// 3. spender가 recipient에게 3 MET 전송
await token.transferFrom(owner, recipient, web3.utils.toWei("3", "ether"), {from: spender})

// 4. recipient 잔액 확인
(await token.balanceOf(recipient)).toString()
// 결과: 3000000000000000000
```
---

## 🎯 보충 실습 제안

- 토큰 소각(`_burn`), 추가 발행(`_mint`) 확장
- DApp과 연동하는 Web3.js 또는 Ethers.js 연습
- Truffle 테스트 코드 작성

---

📚 정리자: Coincraft(2025년 최신 기준)