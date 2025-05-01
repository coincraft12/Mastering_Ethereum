// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FibonacciBalance {
    address public fibonacciLibrary;
    uint public calculatedFibNumber;
    uint public start = 3;
    uint public withdrawalCounter;
    bytes4 constant fibSig = bytes4(keccak256("setFibonacci(uint256)"));

    constructor(address _lib) payable {
        fibonacciLibrary = _lib;
    }

    function withdraw() public {
        withdrawalCounter += 1;
        (bool success, ) = fibonacciLibrary.delegatecall(
            abi.encodeWithSelector(fibSig, withdrawalCounter)
        );
        require(success, "Delegatecall failed");

        payable(msg.sender).transfer(calculatedFibNumber * 1 ether);
    }

    fallback() external payable {
        (bool success, ) = fibonacciLibrary.delegatecall(msg.data);
        require(success, "Fallback delegatecall failed");
    }

    receive() external payable {}
}