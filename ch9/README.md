# 📚 Chapter 9. 스마트 컨트랙트 보안 요약

이 문서는 『Mastering Ethereum』의 9장을 요약한 내용으로,  
실제 공격 사례와 대응 패턴을 간단한 코드와 함께 정리해둔 레퍼런스용 문서입니다.  
진짜 실전에서 터질 수 있는 취약점만 콕 집어서 담았으니, 두고두고 써먹을 수 있어요 😎

---

## 🔒 주요 보안 취약점 요약

| 항목 | 설명 | 대응 방법 |
|------|------|-----------|
| Reentrancy | 외부 호출 후 상태 변경 → 반복 호출 가능 | 상태 먼저 변경, transfer 사용 |
| Delegatecall | 외부 코드가 현재 컨트랙트의 상태를 덮어씀 | `library` 사용, storage slot 주의 |
| tx.origin | 최초 호출자 확인으로 피싱 가능 | 항상 `msg.sender`로 인증 |
| Unchecked CALL | send() 실패해도 상태는 바뀜 | `withdraw pattern` 사용 |
| DoS | 루프 과부하, 특정 주소 실패 유도 | withdraw 방식, timelock 등 |
| Timestamp 조작 | 블록 타임 조작으로 조건 우회 | block.number 사용, 시간 민감 조건 최소화 |
| Entropy Illusion | 랜덤성 조작 가능 (미래 블록 변수 사용) | commit-reveal, 외부 randomness 사용 |
| External Contract Referencing | 악성 컨트랙트 연결로 속이기 | new로 생성하거나 address 공개, 고정 |
| Floating Point Precision | 고정소수점 미지원으로 계산 오류 | 순서 주의, 정수 스케일링, DS-Math 활용 |
| Constructors | 이름 오타로 누구나 호출 가능 | `constructor` 키워드 사용 (0.4.22 이후) |

---

## 💻 실습 예제

- `ReentrancyVulnerable.sol`: 재진입 가능한 버전
- `ReentrancyFixed.sol`: Checks-Effects-Interactions 방식 적용
- `Phishable.sol`: tx.origin 피싱 구조 예제

👉 실제 Solidity 코드 및 실습 예제는 `./contracts` 폴더에 정리할 예정입니다.  
Remix에 붙여넣으면 바로 실험 가능하게 작성할게요!

---

## 🛡️ 보안 스마트컨트랙트를 위한 실전 팁

- 상태 변경 → 외부 호출 순서 꼭 지키기 (CEI 패턴)
- `tx.origin` 절대 쓰지 말기
- 외부 컨트랙트 주소는 가능하면 new로 생성
- 돈은 직접 보내지 말고, **찾아가게(Pull)** 하라 (withdraw pattern)
- 반복문에서 외부 조작된 배열/매핑 쓰지 말기

---

## 🧠 참고자료

- [Solidity 공식 문서 보안 섹션](https://docs.soliditylang.org/en/latest/security-considerations.html)
- [Ethernaut by OpenZeppelin](https://ethernaut.openzeppelin.com/)
- [DASP Top 10](https://consensys.github.io/smart-contract-best-practices/known_attacks/)

---

🔥 이거 하나만 제대로 이해하고 있어도, 왠만한 해킹은 다 막을 수 있습니다.  
믿고 가자구요, 형님들 💪