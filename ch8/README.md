
# 📘 Chapter 8 – Vyper 환경 구성 및 CLI 스마트 컨트랙트 실습 (Mastering Ethereum)

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

# PowerShell 기준 활성화 (실행 정책 설정 필요 시 아래 참고)
Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned
.yper-env\Scripts\Activate.ps1
```

> CMD 사용하는 경우:
> ```cmd
> vyper-env\Scriptsctivate.bat
> ```

### 3. Vyper 설치 (0.3.10)

```bash
pip install vyper==0.3.10
```

설치 확인:
```bash
vyper --version  # 출력: 0.3.10
```

---

## 📄 Vyper 컨트랙트 예시 (faucet.vy)

```python
# @version ^0.3.10

event Deposit:
    sender: indexed(address)
    amount: uint256

event Withdrawal:
    receiver: indexed(address)
    amount: uint256

event LimitChanged:
    new_limit: uint256

owner: public(address)
withdraw_limit: public(uint256)
balances: public(HashMap[address, uint256])

@internal
def _log_withdraw(_to: address, _amount: uint256):
    log Withdrawal(_to, _amount)

@external
def __init__():
    self.owner = msg.sender
    self.withdraw_limit = as_wei_value(0.1, "ether")

@payable
@external
def deposit():
    assert msg.value > 0, "Must send ETH"
    self.balances[msg.sender] += msg.value
    log Deposit(msg.sender, msg.value)

@external
def withdraw(_amount: uint256):
    assert _amount <= self.withdraw_limit, "Exceeds withdraw limit"
    assert self.balances[msg.sender] >= _amount, "Insufficient balance"
    self.balances[msg.sender] -= _amount
    send(msg.sender, _amount)
    self._log_withdraw(msg.sender, _amount)

@external
def set_withdraw_limit(_new_limit: uint256):
    assert msg.sender == self.owner, "Only owner"
    self.withdraw_limit = _new_limit
    log LimitChanged(_new_limit)

@view
@external
def get_my_balance() -> uint256:
    return self.balances[msg.sender]
```

---

## 🛠 컴파일 명령어

```bash
vyper -f abi faucet.vy > faucet.abi
vyper -f bytecode faucet.vy > faucet.bin
```

---

## 🔧 인코딩 오류 대처 (PowerShell)

```powershell
$env:PYTHONIOENCODING="utf-8"
```

---

## ✅ 컴파일 에러 방지 체크리스트

- `# @version` 지시문은 파일 첫 줄
- 이벤트(event)는 `@version` 바로 아래
- 상태 변수는 이벤트 아래 위치

---

## 🚀 다음 단계: 스크립트 배포 방식

### 1. 생성된 ABI/컴파일 파일을 가지고 Holesky 테스트넷에 배포

#### 파일:
- `faucet.abi`
- `faucet.bin`
- `.env` (PRIVATE_KEY, RPC_URL)

#### 배포 스크립트: `deploy.js`

```bash
node deploy.js
```

### 2. 입금 및 지급 자료 확인

- `deposit()` 함수: ETH 전송 + balances[msg.sender] 증가
- `get_my_balance()`로 개인 잔액 확인
- MetaMask 또는 Web3.js를 이용한 입금 테스트

### 3. 출금 기능 테스트 (`withdraw.js`)

- `withdraw.js` 파일을 작성하여 출금 트랜잭션을 실행
- 사전 조건: 해당 계정의 `balances[msg.sender]` 값이 충분해야 함
- 실행:

```bash
node withdraw.js
```

- 출금이 완료되면 Etherscan에서 트랜잭션 확인 가능

### 4. 과거 이벤트 조회 (`listen.js`)

- `node listen.js` 명령어로 실행하여 전체 블록의 Deposit, Withdrawal, LimitChanged 이벤트를 터미널에 출력할 수 있음
- 이벤트 순서대로 출력되며, 마지막에 "✅ 이벤트 전체 조회 완료!" 메시지로 종료됨

---

## 📬 그 이상은?

- 특정 주소만 필터링하는 방식 (`filter: { sender: "0x..." }`)
- 결과를 `.csv` 파일로 저장
- 블록 범위 지정 및 날짜 기반 분석을 가지고 진행할 수 있습니다.

계속적인 확사를 위해 필요한 것이나 건의사항이 있으면 업데이트해 드립니다.
