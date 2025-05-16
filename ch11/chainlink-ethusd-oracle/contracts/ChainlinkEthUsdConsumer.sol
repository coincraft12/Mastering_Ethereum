// contracts/ChainlinkEthUsdConsumer.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./interfaces/AggregatorV3Interface.sol";

contract ChainlinkEthUsdConsumer {
    AggregatorV3Interface internal priceFeed;

    constructor(address aggregator) {
        priceFeed = AggregatorV3Interface(aggregator);
    }

    function getLatestPrice() public view returns (int256) {
        (, int256 price,,,) = priceFeed.latestRoundData();
        return price;
    }

    function getDecimals() public view returns (uint8) {
        return priceFeed.decimals();
    }
}