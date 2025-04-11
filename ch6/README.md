# 📦 Mastering Ethereum – Chapter 6 실습: 이더리움 트랜잭션 완전정복

이 리포지토리는 『마스터링 이더리움』 6장의 트랜잭션 개념을 실제 코드와 함께 학습하기 위한 실습 자료입니다.  
브라우저 콘솔과 Web3.js를 활용해 **계정 연결, 잔액 확인, 트랜잭션 전송, 논스 조회, 가스비 계산** 등을 직접 실험해볼 수 있습니다.

---

## 💻 개발 환경

이 실습은 **Chrome 브라우저의 개발자 도구(DevTools) 콘솔 탭**에서 직접 JavaScript 코드를 입력하여 실행합니다.  
따로 Node.js 환경이나 파일을 구성할 필요 없이, 브라우저만으로 Web3.js와 MetaMask를 활용한 트랜잭션 실습이 가능합니다.

### ✅ 권장 환경

- Google Chrome 최신 버전  
- MetaMask 확장 프로그램 설치 및 로그인  
- Web3.js 로드 (콘솔에서 직접 script 태그 삽입)  
- 연결된 네트워크: Ethereum 테스트넷 (예: Holesky)

> 🔐 **주의**: 메인넷 주소 및 개인 자산으로는 실습하지 마세요.

---

## 🧰 사전 준비

- MetaMask 설치 및 테스트넷(Holesky 권장) 연결  
- 테스트용 ETH 확보: [Holesky Faucet](https://faucet.quicknode.com/ethereum/holesky)  
- Chrome 브라우저에서 개발자 도구(콘솔) 실행  
- 아래 코드 복사 & 붙여넣기

---

## 🧪 실습 코드 구성

### 1. Web3.js 로드 및 계정 연결

```js
const script = document.createElement('script');
script.src = "https://cdn.jsdelivr.net/npm/web3@latest/dist/web3.min.js";
document.head.appendChild(script);

const provider = window.ethereum;
await provider.request({ method: 'eth_requestAccounts' });

const web3 = new Web3(provider);
const accounts = await web3.eth.getAccounts();
console.log('📬 연결된 계정:', accounts[0]);
```

---

### 2. 잔액 확인

```js
const balance = await web3.eth.getBalance(accounts[0]);
console.log('💰 잔액(ETH):', web3.utils.fromWei(balance, 'ether'));
```

---

### 3. 논스(Nonce) 조회

```js
// 확정된 트랜잭션 기준
const nonce = await web3.eth.getTransactionCount("0xYourAddress");
console.log("📌 논스:", nonce);
```

```js
// pending(대기 중인 트랜잭션 포함)
const noncePending = await web3.eth.getTransactionCount("0xYourAddress", "pending");
console.log("📌 Pending 포함 논스:", noncePending);
```

---

### 4. 이더 전송 트랜잭션

```js
await web3.eth.sendTransaction({
  from: accounts[0],
  to: "0xReceiverAddress",
  value: web3.utils.toWei("0.01", "ether")
});
```

---

### 5. 현재 가스 가격 조회

```js
async function getCurrentGasPrice() {
  try {
    const gasPrice = await web3.eth.getGasPrice();
    console.log('⛽️ 가스 가격 (wei):', gasPrice);
    console.log('⛽️ 가스 가격 (Gwei):', web3.utils.fromWei(gasPrice, 'gwei'));
  } catch (err) {
    console.error(err);
  }
}

getCurrentGasPrice();
```

---

### 6. 예상 가스비 계산

```js
async function calculateGasFee() {
  try {
    const gasPrice = await web3.eth.getGasPrice();
    const gasLimit = 21000n;
    const totalGasFeeWei = gasPrice * gasLimit;

    console.log('📊 예상 가스비 (wei):', totalGasFeeWei.toString());
    console.log('📊 예상 가스비 (ETH):', web3.utils.fromWei(totalGasFeeWei.toString(), 'ether'));
  } catch (err) {
    console.error(err);
  }
}

calculateGasFee();
```

---

## 📌 실습 흐름 요약

1. Web3.js 로드 및 MetaMask 계정 연결  
2. 계정 주소 및 잔액 확인  
3. 트랜잭션 전송 전 논스 확인  
4. 실제 트랜잭션 실행  
5. 가스비 확인 및 예상 비용 계산  

---

## 🔒 보안 유의사항

- 브라우저 콘솔에서 실행 시, **개인키 노출 금지**
- 학습용 테스트넷에서만 실습 진행
- 실제 메인넷 자산과 연결된 주소로 테스트 금지

---

## 📚 참고 링크

- [Mastering Ethereum 원서](https://github.com/ethereumbook/ethereumbook)  
- [Web3.js 공식 문서](https://web3js.readthedocs.io/)  
- [Holesky 테스트넷 파우셋](https://faucet.quicknode.com/ethereum/holesky)

---

Happy Hacking! 🚀
