// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ReentrancyFixed {
    mapping(address => uint256) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        uint256 amount = balances[msg.sender];
        require(amount > 0, "No funds to withdraw");

        // ✅ 상태 먼저 변경
        balances[msg.sender] = 0;

        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Failed to send Ether");
    }

    receive() external payable {}
}