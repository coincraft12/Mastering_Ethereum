# 🧾 Auction DApp (React + Web3.js)

이 프로젝트는 이더리움 기반 경매 시스템인 Auction DApp의 프론트엔드 구현입니다.  
`React + Vite + Web3.js` 조합으로 구성되어 있으며, 스마트 컨트랙트와 상호작용하여 입찰 기능을 제공합니다.

---

## 📦 환경 설정

```bash
# 1. frontend 폴더로 이동
cd auction-dapp/frontend

# 2. React + Vite 프로젝트 생성
npm create vite@latest . --template react

# 3. 의존성 설치
npm install
npm install web3
```

---

## 📁 디렉토리 구조

```
frontend/
├── public/
│   └── index.html
├── src/
│   ├── App.jsx
│   ├── main.jsx
│   ├── components/
│   │   └── AuctionInterface.jsx
│   ├── contracts/
│   │   └── AuctionRepository.json <-- backend\build\AuctionRepository.json에서 복사
│   └── utils/
│       └── web3.js
├── package.json
└── vite.config.js
```

---

## ⚙️ Web3 설정 (`src/utils/web3.js`)

```js
import Web3 from "web3";

let web3;

if (window.ethereum) {
  web3 = new Web3(window.ethereum);
  window.ethereum.request({ method: 'eth_requestAccounts' });
} else {
  alert("Metamask가 설치되어 있지 않습니다.");
}

export default web3;
```

---

## 🧩 Auction 컴포넌트 (`src/components/AuctionInterface.jsx`)

```jsx
import React, { useEffect, useState } from 'react';
import web3 from '../utils/web3';
import AuctionRepository from '../contracts/AuctionRepository.json';

const auctionAddress = "당신의_컨트랙트_주소";

const AuctionInterface = () => {
  const [account, setAccount] = useState('');
  const [highestBid, setHighestBid] = useState('0');
  const [bidAmount, setBidAmount] = useState('');
  const [auction, setAuction] = useState(null);
  const contract = new web3.eth.Contract(AuctionRepository.abi, auctionAddress);

  useEffect(() => {
    const load = async () => {
      const accounts = await web3.eth.getAccounts();
      setAccount(accounts[0]);

      const result = await contract.methods.getCurrentBid(0).call();
      setHighestBid(web3.utils.fromWei(result[0], 'ether'));

      const auctionData = await contract.methods.getAuctionById(0).call();
      setAuction({
        blockDeadline: auctionData[1],
        active: auctionData[7],
        owner: auctionData[6]
      });
    };

    load();
  }, []);

  const handleBid = async () => {
    try {
      await contract.methods.bidOnAuction(0).send({
        from: account,
        value: web3.utils.toWei(bidAmount, 'ether'),
      });
      alert("입찰 성공!");
    } catch (err) {
      console.error("입찰 오류:", err);
      alert("입찰 실패: " + err.message);
    }
  };

  if (!auction) return <div>로딩 중...</div>;

  return (
    <div>
      <h2>Auction DApp</h2>
      <p><strong>현재 최고 입찰가:</strong> {highestBid} ETH</p>
      {auction.active ? (
        account.toLowerCase() !== auction.owner.toLowerCase() && (
          <>
            <input
              type="number"
              placeholder="입찰 금액 (ETH)"
              value={bidAmount}
              onChange={(e) => setBidAmount(e.target.value)}
            />
            <button onClick={handleBid}>입찰하기</button>
          </>
        )
      ) : (
        <p>⚠️ 경매가 종료되었습니다.</p>
      )}
    </div>
  );
};

export default AuctionInterface;
```

---

## 🚀 실행

```bash
npm run dev
```

→ 브라우저에서 [http://localhost:5173](http://localhost:5173) 접속

---

## ✅ 확인 사항

- 컨트랙트 주소는 반드시 배포된 주소(`AuctionRepository`)로 변경할 것
- `AuctionRepository.json`은 Truffle 빌드 후 `build/contracts/`에서 복사
- 입찰은 경매 오너가 아닌 계정으로만 가능
- 입찰가는 이전 입찰가보다 높아야 함

---

## 🧪 테스트팁

- `getCurrentBid(auctionId)`로 최고 입찰가 확인
- `getAuctionById(auctionId)`로 경매 상태 확인
- Metamask에서 계정을 전환하며 입찰자 역할 테스트 가능