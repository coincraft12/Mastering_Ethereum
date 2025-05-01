// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Phishable {
    address public owner;

    constructor(address _owner) {
        owner = _owner;
    }

    receive() external payable {}

    function withdrawAll(address _recipient) public {
        require(tx.origin == owner, "Not authorized");
        (bool success, ) = _recipient.call{value: address(this).balance}("");
        require(success, "Failed to send Ether");
    }
}