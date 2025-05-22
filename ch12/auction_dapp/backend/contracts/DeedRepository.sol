// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DeedRepository is ERC721, Ownable {
    uint256 private _nextTokenId;

    constructor(address initialOwner) ERC721("Deed Token", "DEED") Ownable(initialOwner) {}

    function mint(address to) external onlyOwner returns (uint256) {
        uint256 newTokenId = _nextTokenId;
        _nextTokenId++;

        _mint(to, newTokenId);
        return newTokenId;
    }

    function totalSupply() external view returns (uint256) {
        return _nextTokenId;
    }
}
