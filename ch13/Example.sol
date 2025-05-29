// Example.sol
pragma solidity ^0.8.0;

contract Example {
    address public contractOwner;

    constructor() {
        contractOwner = msg.sender;
    }
}
