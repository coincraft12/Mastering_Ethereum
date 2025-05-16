# 📘 Mastering Ethereum 실습 정리

이 리포지토리는 『**Mastering Ethereum**』 책의 내용을 바탕으로  
직접 실습하고 정리한 자료들을 챕터별로 모은 것입니다.  
각 챕터는 사용하는 언어와 도구가 다르며, **폴더별로 독립적인 README**를 참고해 주세요.

---

## 📁 폴더 구성

|  폴더   | 내용 요약                                                    | 사용 언어/플랫폼                |
|---------|------------------------------------------------------------|-------------------------------|
| `ch2`   | 스마트 계약 맛보기 (Solidity 기본 구조)                        | Solidity / Remix              |
| `ch4`   | 공개키 기반 주소 생성, keccak256 해시 흐름 실습                 | Python / eth-utils, eth-keys  |
| `ch5`   | BIP-39 니모닉 생성 및 지갑 구성 실습                           | Python / Streamlit            |
| `ch6`   | 트랜잭션 구조 분석, 디지털 서명 및 EIP-155 실습                 | JavaScript / Node.js          |
| `ch7`   | 스마트 컨트랙트 작성, 컴파일, Holesky 배포 (Truffle & solc-js) | Solidity / Truffle / Node.js  |
| `ch8`   | Vyper 기반 스마트 컨트랙트 작성 및 CLI 배포 흐름                | Vyper / CLI                   |
| `ch9`   | 스마트 컨트랙트 보안 취약점 및 대응 패턴 요약                    | Solidity / 참고 코드 중심 문서 |
| `ch10`  | ERC20 토큰 제작 및 배포, transfer/approve 실습                 | Solidity / Truffle / MetaMask |
| `ch11`  | Chainlink 오라클 실습: ETH/USD 가격 피드 조회                   | Solidity / Truffle / Chainlink|

---

## 🛠️ 전체 프로젝트 실행을 위한 기본 요구사항

- Python 3.9+
- Node.js 20+
- Git
- MetaMask (ch6~ch10 실습에서 필요)
- Infura 또는 Public RPC (예: Holesky)
- Ganache (로컬 테스트 시 필요)
- Vyper (ch8 실습에서 필요)

---

## 🗂️ 향후 계획 (To-do)

- [ ] ch3: Ethereum 계정과 트랜잭션 실습  
- [ ] ch4: 디지털 서명과 ECDSA 흐름 시각화  
- [x] ch5: 니모닉 생성 및 이더리움 지갑 파생 실습 완료  
- [x] ch6: 트랜잭션 구조, 서명 및 EIP-155 적용 실습 완료  
- [x] ch7: 스마트 컨트랙트 작성 및 Holesky 배포 실습 완료  
- [x] ch8: Vyper 스마트 컨트랙트 및 CLI 기반 배포 실습 완료  
- [x] ch9: 보안 패턴 및 취약점 정리 완료  
- [x] ch10: ERC20 토큰 발행, transferFrom 및 approve 구조 실습 완료
- [x] ch11: Chainlink 오라클 연동, ETH/USD 가격 피드 조회 실습 완료

---

## 💬 참고

- 이 리포는 학습/테스트 목적이며, 개인 키 및 니모닉은 공개 저장소에 업로드하지 마세요.
- 보안이 필요한 환경에서는 반드시 하드웨어 지갑 또는 안전한 키 관리 방식을 사용할 것.

---

> 📚 Inspired by *Mastering Ethereum* by Andreas M. Antonopoulos & Gavin Wood