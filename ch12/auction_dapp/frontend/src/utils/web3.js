import Web3 from 'web3';

let web3;

if (window.ethereum) {
  web3 = new Web3(window.ethereum);
  try {
    // 계정 연결 요청
    await window.ethereum.request({ method: 'eth_requestAccounts' });
  } catch (error) {
    console.error("사용자 지갑 연결 거부", error);
  }
} else {
  alert("MetaMask가 설치되어 있지 않습니다.");
}

export default web3;
