
# 📘 Ethereum 강의 13: EVM (Ethereum Virtual Machine)

이 강의에서는 이더리움 가상 머신(EVM)의 구조와 동작 원리를 상세히 다룹니다. 스마트 컨트랙트가 어떻게 실행되는지, 바이트코드와 가스의 의미, 그리고 디스패처가 어떤 역할을 하는지까지 학습합니다.

---

## 🧠 핵심 개념 요약

### 🔹 EVM이란?
- Ethereum Virtual Machine
- 이더리움에서 스마트 컨트랙트를 실행하는 가상 CPU
- 독립적인 환경으로, 모든 노드가 동일한 실행 결과를 보장

### 🔹 Solidity → Bytecode → EVM
- Solidity로 작성된 코드는 컴파일되어 바이트코드가 됨
- 이 바이트코드는 EVM에서 실행됨

### 🔹 디스패처(Dispatcher)
- 여러 함수 중 어떤 함수가 호출되었는지 구분하는 로직
- `function selector` (첫 4바이트)를 비교해 해당 함수 코드로 JUMP
- Solidity 컴파일러가 자동 생성함

### 🔹 EVM Execution Flow
1. 트랜잭션 수신
2. 입력 데이터(함수 선택자 등) 확인
3. 디스패처 실행 → 함수 바이트코드로 이동
4. 바이트코드 실행 루프 (STACK, MEMORY, STORAGE 사용)
5. 상태 변경 및 로그 기록

### 🔹 Turing Completeness & Gas
- EVM은 튜링 완전(Turing-complete)하지만,
- 무한루프를 방지하기 위해 `Gas`라는 제한을 둠
- 실행 중 가스 초과 시 중단됨 → DOS 방어 역할도 수행

---

## 🧭 EVM 아키텍처 도식 설명

![Mastering_Ethereum/ch13/evm-architecture.png](evm-architecture.png)

이 도식은 EVM이 트랜잭션을 어떻게 처리하고 상태(state)를 어떻게 변경하는지를 전체적으로 보여주는 흐름도입니다.

### 🔹 주요 구성 요소

#### 📦 1. Account State (계정 상태)
- `Nonce`: 계정에서 발생한 트랜잭션 수
- `Balance`: 계정이 보유한 이더(wei 단위)
- `Storage Root Hash`: 스마트 컨트랙트의 저장소 상태 트라이의 루트 해시
- `CodeHash`: 계정이 가진 코드(스마트 컨트랙트)의 keccak256 해시

#### 🧾 2. Block Header (블록 헤더)
- `Block No.`: 블록 번호
- `TX Root Hash`: 트랜잭션 머클 트리의 루트 해시
- `Receipts Root`: 트랜잭션 결과 로그 영수증 루트 해시
- `State Root Tree`: 현재 전체 상태(state)의 머클 트리 루트 해시
- 기타 정보: Gas Limit, Difficulty 등

#### 🌍 3. EVM World State
- `<address> → Account State`로 이루어진 매핑 구조
- 이더리움의 모든 상태는 이 트라이로 요약되며, 블록 헤더의 `stateRoot`로 저장됨

#### ⚙️ 4. EVM Execution Model (실행 모델)
- 트랜잭션 입력을 받아 바이트코드를 실행
- 입력 요소: 현재 상태, 가스, 트랜잭션 데이터, 블록 헤더, 송신자
- 컨트랙트 바이트코드를 로드한 후, Stack, Memory, Storage, Program Counter를 기반으로 실행

#### 💡 5. Opcode 실행 루프
- Opcode를 Stack에서 하나씩 가져와 실행
- `Remaining Gas` 체크 → 부족하면 Revert
- `Remaining Opcode`가 없으면 종료
- 각 Opcode는 Gas를 소모하며 상태를 변경하거나 로그를 생성

#### 💸 6. Gas Fee 흐름
- Opcode 실행 전후에 gas 계산
- 일부 Opcode는 `Refund` 발생 (ex: SSTORE 0으로 초기화)
- 실패 시에도 실행된 만큼의 Gas는 차감됨


이 그림은 EVM의 상태 기반 실행 모델을 구조적으로 보여주며, 스마트 컨트랙트가 트랜잭션에 따라 어떻게 실행되고 어떤 식으로 상태가 바뀌는지를 전체적으로 파악하는 데 매우 중요합니다.

---

## 📌 참고

- 『Mastering Ethereum』 Chapter 13
- Solidity Documentation
- https://ethereum.org/en/developers/docs/evm/

---

## 🧾 결론

- EVM은 이더리움의 핵심 엔진
- 스마트 컨트랙트를 안전하게 실행하고 상태를 갱신
- Gas 시스템을 통해 네트워크를 보호하고 리소스를 관리

---

✔️ 다음 강의에서는 **이더리움의 합의 알고리즘 (Consensus)** 을 다룹니다.

---
