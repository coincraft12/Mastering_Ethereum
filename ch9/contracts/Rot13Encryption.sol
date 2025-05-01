// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Rot13Encryption {
    event Result(string convertedString);

    function rot13Encrypt(string memory text) public {
        emit Result(text); // 실제 로직은 생략
    }
}