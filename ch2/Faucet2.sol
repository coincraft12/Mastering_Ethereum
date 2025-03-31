// SPDX-License-Identifier: MIT
// Author: Janusz Chudzynski
pragma solidity >=0.4.22 <0.9.0;
	

contract Faucet {
	 
 mapping(address=>uint) lastTransfers;
 uint amountToWithdraw = 0.0001 ether;
 event Received(address sender, uint amount);
 event FallbackTriggered(address sender, uint amount);
	

 function requestTokens(address payable requestor) external {
	    
  require(address(this).balance >= amountToWithdraw, "Not enough funds in the faucet. Please donate");
	

  requestor.transfer(amountToWithdraw);
  lastTransfers[requestor] = block.timestamp;
  }
	

 function getBalance() public view returns (uint) {
   return address(this).balance;
  }
	

  receive() external payable {
    emit Received(msg.sender, msg.value);
  }
  fallback() external payable {
    emit FallbackTriggered(msg.sender, msg.value);
  }
	
}        