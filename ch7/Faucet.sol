// SPDX-License-Identifier: CC-BY-SA-4.0

pragma solidity ^0.8.0;

contract Owned {
    address payable owner;

    // Contract constructor: set owner
    constructor() {
        owner = payable(msg.sender);
    }

    // Access control modifier
    modifier onlyOwner {
        require(msg.sender == owner, "Only the contract owner can call this function");
        _;
    }
}

contract Mortal is Owned {
    bool public isActive = true;

    modifier contractIsActive() {
        require(isActive, "Contract is no longer active");
        _;
    }

    function destroy() public onlyOwner {
        isActive = false;
        // optionally: transfer ETH out
        owner.transfer(address(this).balance);
    }
}

contract Faucet is Mortal {
    event Withdrawal(address indexed to, uint amount);
    event Deposit(address indexed from, uint amount);

    // Accept any incoming amount
    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    // Give out ether to anyone who asks
    function withdraw(uint withdraw_amount) public contractIsActive {
        // Limit withdrawal amount
        require(withdraw_amount <= 0.1 ether, "Withdrawal exceeds limit");

        require(
            address(this).balance >= withdraw_amount,
            "Insufficient balance in faucet for withdrawal request"
        );

        // Send the amount to the address that requested it
        payable(msg.sender).transfer(withdraw_amount);

        emit Withdrawal(msg.sender, withdraw_amount);
    }
}
