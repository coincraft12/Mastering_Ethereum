
# 📘 Chapter 7 – 스마트 컨트랙트와 솔리디티 실습

『Mastering Ethereum』 7장 내용을 기반으로 진행한 스마트 컨트랙트 및 Solidity 실습 저장소입니다.

Truffle 프레임워크를 사용하여 Solidity로 스마트 컨트랙트를 작성, 컴파일, 배포하고  
Holesky 이더리움 테스트넷에 직접 배포하는 과정까지 포함되어 있습니다.

---

## 🛠 사용 기술

- Solidity `^0.8.20`
- Truffle `v5.11.5`
- Node.js `v20.9.0`
- Holesky Ethereum Testnet
- MetaMask + Infura 또는 Custom RPC
- VSCode + Git + GitHub
- Windows 10 Home

---

## 테스트 환경 구축 및 실행

✅ 1. Remix IDE (웹 기반, 추천)
가장 쉬운 방법!
설치 없이 브라우저에서 바로 Solidity 코드를 작성하고 컴파일하고 배포까지 가능.

🔗 접속: https://remix.ethereum.org

✔️ 장점:
설치 필요 없음
학습/실습에 적합
자동 컴파일, 디버깅, 가스 사용 분석 등 지원

✅ 2. Windows + Node.js + Hardhat or Truffle
좀 더 로컬에서 프로젝트 단위로 개발하고 싶다면,
Hardhat 또는 Truffle 같은 프레임워크를 설치하면 돼.

설치 순서 (Truffle 기준):
① Node.js 설치 → https://nodejs.org
설치 확인
```bash
node -v
npm -v
```
둘 다 버전이 출력되면 OK

② VS Code 설치 (또는 다른 에디터)
③ Truffle 전역 설치
```bash
npm install -g truffle
```
※ 시간 오래 걸림

- 설치 완료 확인:
```bash
truffle version
```

④ 프로젝트 생성:
```bash
mkdir my-contract && cd my-contract
truffle init
```

⑤ 생성되는 디렉토리 구조
```bash
my-contract/
├── contracts/
├── migrations/
├── scripts/
├── truffle-config.js
```

⑥ Holesky 연결을 위한 의존성 설치
```bash
npm install @truffle/hdwallet-provider
```

⑦ Solidity 코딩: contracts/ 폴더에 .sol 파일 작성


⑧ Holesky 네트워크 연결 설정
- truffle-config.js 파일 속 가장 아래쪽에 Holesky 네트워크 설정 코드를 추가:
```js
const HDWalletProvider = require('@truffle/hdwallet-provider');

// 네가 사용하는 지갑의 니모닉 또는 private key
const PRIVATE_KEY = '0xYOUR_PRIVATE_KEY'; // ⚠️ 비공개로 관리

module.exports = {
  networks: {
    holesky: {
      provider: () => new HDWalletProvider(PRIVATE_KEY, "https://ethereum-holesky.publicnode.com"),
      network_id: 17000,
      gas: 3000000,
      gasPrice: 1000000000
    }
  },
  compilers: {
    solc: {
      version: "0.8.20"
    }
  }
};
```

⑨ 배포 마이그레이션 스크립트 추가
- migrations/1_deploy.js
```js
const MyContract = artifacts.require("my-contract");

module.exports = function (deployer) {
  deployer.deploy(MyContract);
};
```

⑩ 배포
```bash
truffle migrate --network holesky
```
- 기존 마이그레이션 무시하고 다시 처음 부터 배포
```bash
truffle complie --all
truffle migrate --network holesky --reset
```

✔️ 장점:

진짜 개발 환경과 유사
테스트, 디버깅, 배포 자동화 가능
메인넷 연동도 쉬움

### 📁 프로젝트 디렉토리 구조

```
ch7/
├── node_modules/             # npm으로 설치된 외부 라이브러리들 (Git에는 포함하지 않음)
├── nodejs/                   # solc-js를 사용한 스마트컨트랙트 컴파일 및 배포 실습
│   └── ...                   # 개별 JS 파일을 통한 수동 컴파일 & 배포 예제 포함
├── Truffle/                  # Truffle 기반 스마트컨트랙트 실습 모음
│   ├── Ex_DataType/          # Solidity 자료형 실습 (bool, uint, string, enum, struct, mapping 등)
│   ├── faucet-logger/        # 이벤트(Event) 발생 및 로그 확인 실습 (Deposit, Withdrawal)
│   ├── CallExample/          # 컨트랙트 간 호출(call, delegatecall) 실습
│   ├── gas_estimation/       # 가스 추정 및 계산 실습
│   └── ...                   # 기타 Truffle 기반 실습 프로젝트
├── scripts/                  # type: module 자동 토글 등 유틸리티 스크립트
├── package.json              # 프로젝트 메타 정보 및 의존성 정의
├── package-lock.json         # 의존성 버전 고정 파일 (자동 생성됨)
└── README.md                 # 프로젝트 설명 파일
```

---

## 📝 폴더별 설명

- **`node_modules/`**: `npm install`로 설치된 외부 라이브러리 저장소. Git에는 포함하지 않음.
- **`nodejs/`**: Truffle 없이 `solc-js`와 `web3.js`로 직접 스마트컨트랙트를 컴파일하고 배포하는 실습 자료.
- **`Truffle/`**: Truffle 프레임워크 기반 실습 프로젝트 모음.
  - `Ex_DataType/`: 다양한 Solidity 데이터 타입 실습.
  - `faucet-logger/`: 이벤트 발생 및 과거 이벤트 로그 조회 실습.
  - `CallExample/`: 다른 컨트랙트를 호출하거나 위임 호출하는 실습.
  - `gas_estimation/`: 트랜잭션 가스 사용량을 예측하고 계산하는 실습.
- **`scripts/`**: `package.json`의 `"type": "module"`을 자동으로 토글하는 유틸리티 스크립트 등이 포함.
- **`package.json` / `package-lock.json`**: 프로젝트 정보 및 의존성 관리 파일.
- **`README.md`**: 본 프로젝트 설명서.

---



## 🔁 자동 모듈 설정 토글 스크립트 예시

```json
// package.json
"scripts": {
  "toggle:module": "node scripts/toggle-module-type.cjs",
  "truffle:migrate": "npm run toggle:module && truffle migrate --network holesky --reset && npm run toggle:module"
}
```

스크립트 예시 (`scripts/toggle-module-type.cjs`):

```js
const fs = require('fs');
const path = require('path');

const packageJsonPath = path.join(__dirname, '..', 'package.json');
const pkg = JSON.parse(fs.readFileSync(packageJsonPath, 'utf-8'));

if (pkg.type === 'module') {
  delete pkg.type;
  console.log('🟡 "type": "module" → 제거 완료');
} else {
  pkg.type = 'module';
  console.log('🟢 "type": "module" → 추가 완료');
}

fs.writeFileSync(packageJsonPath, JSON.stringify(pkg, null, 2));
```

---

## 📚 참고

- 실습 기반 도서: 『Mastering Ethereum』 by Andreas M. Antonopoulos, Gavin Wood
- 테스트넷 사용을 위한 Faucet 필요 (Google: "Holesky faucet")

---

## 🙌 기타

이 저장소는 이더리움 스마트 컨트랙트 학습을 위한 교육/실습 목적입니다.  
자유롭게 포크하거나 교육 콘텐츠로 활용하셔도 좋습니다.
