// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Example_DataType {
    bool public isActive = true;
    uint public age = 25;
    address public owner;
    string public name = "Alice";

    enum Status { Created, Shipped, Delivered }
    Status public orderStatus;

    struct User {
        string name;
        uint balance;
    }

    mapping(address => User) public users;

    constructor() {
        owner = msg.sender;
        users[owner] = User("Alice", 1 ether); // 수정됨: uint 타입에 적합한 값
    }
}
