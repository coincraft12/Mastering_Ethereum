// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IEncryption {
    function rot13Encrypt(string memory text) external;
}

contract EncryptionContract {
    IEncryption public encryptionLibrary;

    constructor(address _lib) {
        encryptionLibrary = IEncryption(_lib);
    }

    function encryptPrivateData(string memory privateInfo) public {
        encryptionLibrary.rot13Encrypt(privateInfo);
    }
}