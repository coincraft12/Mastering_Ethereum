// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ReentrancyVulnerable {
    mapping(address => uint256) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        uint256 amount = balances[msg.sender];
        require(amount > 0, "No funds to withdraw");

        // 💥 외부 호출 먼저!
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Failed to send Ether");

        // 상태 변경이 나중!
        balances[msg.sender] = 0;
    }

    receive() external payable {}
}