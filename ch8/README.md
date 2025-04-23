
# 📘 Chapter 8 – 스마트 컨트랙트와 바이퍼 (Mastering Ethereum)

이 저장소는 『Mastering Ethereum』 8장을 기반으로 진행한 Vyper 스마트 컨트랙트 실습 환경 구성 및 CLI 기반 배포 흐름을 문서화한 것입니다.

---

## 🧱 사전 준비 사항

- 운영체제: Windows 10 이상 (WSL 또는 PowerShell 지원)
- Python: 3.10 이상 필수
- Vyper: 0.3.10 고정 사용

---

## ⚙️ 환경 설정 (Windows 기준 CLI)

### 1. Python 설치

- https://www.python.org/downloads/windows/ 접속
- Python 3.10.x 설치
  - ✅ Add Python to PATH 체크
  - ⚙️ Customize Installation > Install for all users 선택

### 2. 가상환경 생성 및 활성화

```bash
# 작업 폴더 생성 및 이동
mkdir vyper-project
cd vyper-project

# 가상환경 생성
python -m venv vyper-env

# 가상환경 활성화
vyper-env\Scripts\ctivate.bat
```

### 3. 필요 패키지 설치
```bash
npm init -y
npm install web3 dotenv
```

### 4. Vyper 설치 (0.3.10)

```bash
pip install vyper==0.3.10
```

설치 확인:
```bash
vyper --version  # 출력: 0.3.10
```

---

## ✅ 컴파일 에러 방지 체크리스트

- `# @version` 지시문은 파일 첫 줄
- 이벤트(event)는 `@version` 바로 아래
- 상태 변수는 이벤트 아래 위치
- `package.json` 파일 내   `"type": "module",` 구문 추가
```json
{
  "type": "module",
  "name": "ch8",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "keywords": [],
  "author": "",
  "license": "ISC",
  "dependencies": {
    "dotenv": "^16.5.0",
    "web3": "^4.16.0"
  }
}
```


---

## 🚀 다음 단계: 스크립트 배포 방식

### 1. 생성된 ABI/컴파일 파일을 가지고 Holesky 테스트넷에 배포

#### 파일:
- `faucet.abi`
- `faucet.bin`
- `.env` (파일 내 PRIVATE_KEY과 RPC_URL에 본인의 데이터를 입력)

#### 배포 스크립트: `deploy.js`

```bash
node deploy.js
```

### 2. 컨트랙트 계좌로 이더 입금

- 자신의 메타마스크 지갑을 실행
- 생성된 컨트랙트 계좌로 테스트 이더 전송

### 3. 컨트랙트 계좌 잔액 확인

#### 스크립트: `checkBalance.js`

```bash
node checkBalance.js
```

### 4. 출금 요청

#### 스크립트: `withdraw.js`

```bash
node withdraw.js
```

- 출금이 완료되면 Etherscan에서 트랜잭션 확인 가능

### 5. 과거 이벤트 조회

#### 스크립트: `listen.js`

```bash
node listen.js
```

- `node listen.js` 명령어로 실행하여 전체 블록의 Deposit, Withdrawal, LimitChanged 이벤트를 터미널에 출력할 수 있음
- 이벤트 순서대로 출력되며, 마지막에 "이벤트 전체 조회 완료!" 메시지로 종료됨

---

## 📚 참고

- 실습 기반 도서: 『Mastering Ethereum』 by Andreas M. Antonopoulos, Gavin Wood
- 테스트넷 사용을 위한 Faucet 필요 (Google: "Holesky faucet")

---

## 🙌 기타

이 저장소는 이더리움 스마트 컨트랙트 학습을 위한 교육/실습 목적입니다.  
자유롭게 포크하거나 교육 콘텐츠로 활용하셔도 좋습니다.

