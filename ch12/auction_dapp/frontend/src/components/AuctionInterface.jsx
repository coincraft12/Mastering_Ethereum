import React, { useEffect, useState } from 'react';
import web3 from '../utils/web3';
import AuctionRepository from '../contracts/AuctionRepository.json';

const auctionAddress = "0xD699Fa8C38F7E3a82478Dd74919cC99b4cda179B";

const AuctionInterface = () => {
  const [account, setAccount] = useState('');
  const [highestBid, setHighestBid] = useState('0');
  const [bidAmount, setBidAmount] = useState('');
  const contract = new web3.eth.Contract(AuctionRepository.abi, auctionAddress);

  useEffect(() => {
    const load = async () => {
      const accounts = await web3.eth.getAccounts();
      setAccount(accounts[0]);

      const result = await contract.methods.getCurrentBid(0).call();  // 경매 ID 0 기준
      setHighestBid(web3.utils.fromWei(result[0], 'ether'));
    };

    load();
  }, []);

  const handleBid = async () => {
    await contract.methods.bidOnAuction(0).send({
  from: account,
  value: web3.utils.toWei(bidAmount, 'ether'),
});
    alert("입찰 완료!");
  };

  return (
    <div>
      <h2>Auction DApp</h2>
      <p><strong>현재 최고 입찰가:</strong> {highestBid} ETH</p>
      <input
        type="number"
        placeholder="입찰 금액 (ETH)"
        value={bidAmount}
        onChange={(e) => setBidAmount(e.target.value)}
      />
      <button onClick={handleBid}>입찰하기</button>
    </div>
  );
};

export default AuctionInterface;
