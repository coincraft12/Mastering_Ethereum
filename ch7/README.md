
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

## 테스트 환경

  ### ✅ **Windows + Node.js + Truffle**
   - 좀 더 로컬에서 프로젝트 단위로 개발하고 싶다면, Hardhat 또는 Truffle 같은 프레임워크를 설치

  ### ✅ **설치 (Truffle 기준)**
  
  #### 1. Node.js 설치 → https://nodejs.org
  
  - 설치 확인 (둘 다 버전이 출력되면 OK)
  ```bash
  node -v
  npm -v
  ```
  
  #### 2. VS Code 설치 (또는 다른 에디터)
  
  #### 3. Truffle 전역 설치
  ```bash
  npm install -g truffle
  ```
  - 설치 완료 확인:
  ```bash
  truffle version
  ```
---

## 코드 실행
  ### ✅ **코드 다운로드**
  ```bash
  git clone https://github.com/coincraft12/Mastering_Ethereum.git
  ```
  
  #### 1. 디렉토리 구조
  ```
  ch7/
  ├── nodejs/                    # solc-js를 사용한 스마트컨트랙트 수동 컴파일 및 배포 실습
  │   └── ...                    # 각종 JS 파일 기반 실습 코드
  ├── Truffle/                   # Truffle 기반 스마트컨트랙트 실습 프로젝트
  │   ├── build/                 # 컴파일된 ABI 및 바이트코드가 자동 저장되는 폴더
  │   ├── contracts/             # Solidity 스마트컨트랙트 (.sol 파일들)
  │   ├── migrations/            # Truffle 배포 스크립트
  │   ├── scripts/               # 트랜잭션 가스 측정, 이벤트 조회 등의 JS 유틸 스크립트
  │   ├── tests/                 # 스마트컨트랙트 테스트 코드 (Mocha + Chai 등 활용 가능)
  │   ├── package.json           # Truffle 프로젝트 설정 및 의존성 정의
  │   ├── package-lock.json      # 의존성 버전 고정 파일 (자동 생성)
  │   └── truffle-config.js      # Truffle 네트워크 및 컴파일러 설정 파일
  ```
  
  #### 2. 폴더별 설명
   - **`nodejs/`**  
   Truffle 없이 `solc-js`를 사용해 스마트컨트랙트를 컴파일하고 Web3.js로 배포하는 수동 실습 코드들이 포함되어 있습니다.
   - **`Truffle/`**  
   Truffle 프레임워크를 활용한 프로젝트 전용 폴더입니다. Solidity 컨트랙트를 컴파일, 마이그레이션, 테스트하며 아래와 같은 하위 폴더를 포함합니다:
     - `contracts/` – 실제 작성한 Solidity (.sol) 스마트컨트랙트 파일
     - `migrations/` – 배포 시 실행되는 마이그레이션 스크립트
     - `scripts/` – 가스 측정, 이벤트 리스너 등 보조 기능을 담당하는 JS 스크립트
     - `tests/` – 컨트랙트 기능을 검증하기 위한 테스트 코드 (작성 예정 또는 완료)
     - `build/` – Truffle이 자동 생성하는 ABI와 컴파일 결과 파일
     - `truffle-config.js` – Holesky 테스트넷 등 네트워크 및 컴파일러 설정
     - `package.json`, `package-lock.json` – 의존성 및 프로젝트 메타 정보

 ### ✅ **의존성 (Dependencies) 패키지 설치**

  #### 1. Holesky 연결을 위한 의존성 추가
  ```bash
  npm install @truffle/hdwallet-provider
  ```
  
  #### 2. 패키지 설치 (node_modules)
  ```bash
  npm install
  ```
  - package.json 파일이 있는 디렉토리(\ch7\)에서 실행해야 정상 작동됨
  - 설치 완료 후 루트 디렉토리에 node_modules/ 디렉토리 생성됨

 ### ✅ **컴파일 및 배포**
   
   #### 1. 컴파일
   ```bash
   truffle compile
   ```

   #### 2. 블록체인 배포
   - 실행 전 truffle-config.js 코드 내 MetaMask 개인키 입력 (주의)
   ```js
   const PRIVATE_KEY = ["YOUR PRIVATE_KEY"];
   ```
   ```bash
   truffle migrate --network holesky
   ```

   #### ※ 기존 마이그레이션 무시하고 다치 처음 부터 배포
   ```bash
   truffle complie --all
   truffle migrate --network holesky --reset
   ```

 ### ✅ **실행**

   #### 1. 가스 예상 가격 출력
   - 실행 전 truffle-config.js 코드 내 MetaMask 개인키 입력 (주의)
   ```js
   const PRIVATE_KEY = ["YOUR PRIVATE_KEY"];
   ```
   ```bash
   cd scripts/
   truffle console --network holesky
   ```
   - truffle 콘솔 창에 진입 시:
   ```bash
   truffle(holesky)> exec gas_estimate.js
   ```

   #### 2. 트랜잭션 이벤트 출력
   ```bash
   cd scripts
   node listen.js
   ```
 
 ### 🧰 **solc-js + nodejs 수동 배포 예제**
   Truffle 프레임워크 없이 solc-js와 web3.js를 활용하여 스마트 컨트랙트를 수동으로 컴파일하고 Holesky 테스트넷에 배포하는 과정입니다.
   ```bash
   # 1. 프로젝트 폴더로 이동
   cd ch7/nodejs
   
   # 2. solcjs 및 web3 설치
   npm install solc web3
   
   # 3. solcjs로 컴파일
   solcjs --bin --abi Example_DataType.sol
   
   # 4. 배포 스크립트 실행 (Deploy.js)
   node Deploy.js
   ```
   - PRIVATE_KEY와 RPC_URL은 사용자의 환경에 맞게 설정해야 함
   - output/MyContract_sol_MyContract.abi와 .bin 파일을 배포 스크립트에서 읽어옴
   - 배포가 성공하면 콘솔에 컨트랙트 주소가 출력됨
---

## 📚 참고

- 실습 기반 도서: 『Mastering Ethereum』 by Andreas M. Antonopoulos, Gavin Wood
- 테스트넷 사용을 위한 Faucet 필요 (Google: "Holesky faucet")

---

## 🙌 기타

이 저장소는 이더리움 스마트 컨트랙트 학습을 위한 교육/실습 목적입니다.  
자유롭게 포크하거나 교육 콘텐츠로 활용하셔도 좋습니다.
