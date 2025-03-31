# 🔐 Chapter 5 – BIP-39 니모닉 & 이더리움 지갑 실습

이 폴더는 『Mastering Ethereum』 5장 내용을 기반으로,  
**BIP-39 표준에 따른 니모닉 생성과 이더리움 지갑 구성 흐름**을 실습한 자료를 담고 있습니다.

---

## 🧭 주요 실습 내용

- BIP-39 기반 니모닉 코드(12~24단어) 생성  
- 생성 과정: 엔트로피 → 체크섬 → 니모닉  
- 니모닉 → 시드 → BIP-32 경로 기반 키 파생  
- BIP-44 경로를 활용한 실전 지갑 생성  
- 비표준 경로(`m/0/0`)와 비교 실습  
- 개인키 → 공개키 → 이더리움 주소 생성  
- Python만으로 경량 지갑 구성 (eth_keys 사용)  
- Streamlit으로 전체 과정 시각화 앱 구현

---

## 🗂️ 폴더 내 파일 설명

| 파일명                             | 설명                                                              |
|----------------------------------|-------------------------------------------------------------------|
| `bip39_mnemonic_generator.py`    | 콘솔용 니모닉 생성기                                              |
| `bip39_step_by_step_app.py`      | Streamlit 앱 - 니모닉 생성 과정(엔트로피 → 체크섬 등) 시각화         |
| `eth_wallet_generator_app.py`    | 니모닉으로 이더리움 지갑 생성 (개인키, 주소까지 출력)                |
| `hd_wallet_bip32_key_derivation.py` | BIP-32 경로를 이용한 키 파생 및 이더리움 주소 생성 실습             |
| `hd_wallet_from_scratch.py`      | 니모닉부터 시드, 개인키, 공개키, 주소까지 전체 과정을 파이썬으로 구현 |
| `hd_wallet_paths.py`             | 비표준 경로 `m/0/0` vs BIP-44 경로 `m/44'/60'/0'/0/0` 비교 실습      |
| `bip39_english.txt`              | BIP-39 영어 단어 목록 (2048개)                                     |

---

## ⚙️ 사전 설치 요구사항

### Python 라이브러리 설치

```bash
pip install streamlit mnemonic eth_keys eth_utils eth-hash[pycryptodome]
```

💡 `eth-hash[pycryptodome]`는 Keccak-256 해시 함수 사용을 위한 필수 백엔드입니다.

---

## ▶️ 실행 방법

### 1. 콘솔에서 니모닉 생성 (기초)

```bash
python bip39_mnemonic_generator.py
```

- 랜덤한 니모닉 코드가 출력됩니다.

---

### 2. 생성 과정 시각화 앱 실행 (Streamlit)

```bash
streamlit run bip39_step_by_step_app.py
```

- 엔트로피 → 체크섬 → 최종 비트 → 단어 인덱스 등  
  전체 과정을 시각적으로 확인할 수 있습니다.

---

### 3. 이더리움 지갑 생성 앱 실행 (Streamlit)

```bash
streamlit run eth_wallet_generator_app.py
```

- 니모닉으로부터 시드 → 개인키 → 공개키 → 이더리움 주소까지 생성됩니다.

---

### 4. BIP-32 경로 기반 지갑 파생 실습

```bash
python hd_wallet_bip32_key_derivation.py
```

- 니모닉에서 시드를 생성하고,  
  BIP-44 경로(`m/44'/60'/0'/0/0`)를 따라 개인키 및 주소를 파생합니다.

---

### 5. 파이썬으로 HD 지갑 전체 구성 실습

```bash
python hd_wallet_from_scratch.py
```

- BIP-39 + BIP-32 + 이더리움 주소 생성 전체 흐름을 코드로 재현합니다.

---

### 6. 비표준 경로 vs 표준 경로 비교 실습

```bash
python hd_wallet_paths.py
```

- 비표준 경로 `m/0/0`로 파생된 키와  
  BIP-44 표준 경로 `m/44'/60'/0'/0/0` 결과를 비교합니다.

---

## 🛡️ 보안 주의사항

- 이 앱은 **학습/연습용**입니다. 실제 자산을 다루지 마세요.  
- 생성된 니모닉은 **절대 실제 지갑에 사용하지 마세요.**  
- 실사용 시에는 반드시 **오프라인 환경** 또는 **하드웨어 지갑**을 사용하세요.

---

## 📚 참고 자료

- [BIP-39 공식 사양](https://github.com/bitcoin/bips/blob/master/bip-0039.mediawiki)  
- [BIP-32 공식 사양](https://github.com/bitcoin/bips/blob/master/bip-0032.mediawiki)  
- [Mastering Ethereum 원서 GitHub](https://github.com/ethereumbook/ethereumbook)
