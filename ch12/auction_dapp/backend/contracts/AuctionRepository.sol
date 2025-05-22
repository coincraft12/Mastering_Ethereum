// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./DeedRepository.sol";

contract AuctionRepository {
    struct Bid {
        address payable from;
        uint256 amount;
    }

    struct Auction {
        string name;
        uint256 blockDeadline;
        uint256 startPrice;
        string metadata;
        uint256 deedId;
        address deedRepositoryAddress;
        address payable owner;
        bool active;
        bool finalized;
    }

    Auction[] public auctions;
    mapping(uint256 => Bid[]) public auctionBids;
    mapping(address => uint256[]) public auctionOwner;

    modifier isOwner(uint256 _auctionId) {
        require(auctions[_auctionId].owner == msg.sender, "Not auction owner");
        _;
    }

    modifier contractIsDeedOwner(address _deedRepositoryAddress, uint256 _deedId) {
        address deedOwner = DeedRepository(_deedRepositoryAddress).ownerOf(_deedId);
        require(deedOwner == address(this), "Contract not deed owner");
        _;
    }

    receive() external payable {
        revert("Direct payments not allowed");
    }

    function getCount() external view returns (uint256) {
        return auctions.length;
    }

    function getBidsCount(uint256 _auctionId) external view returns (uint256) {
        return auctionBids[_auctionId].length;
    }

    function getAuctionsOf(address _owner) external view returns (uint256[] memory) {
        return auctionOwner[_owner];
    }

    function getCurrentBid(uint256 _auctionId) external view returns (uint256, address) {
        uint256 bidsLength = auctionBids[_auctionId].length;
        if (bidsLength > 0) {
            Bid memory lastBid = auctionBids[_auctionId][bidsLength - 1];
            return (lastBid.amount, lastBid.from);
        }
        return (0, address(0));
    }

    function getAuctionsCountOfOwner(address _owner) external view returns (uint256) {
        return auctionOwner[_owner].length;
    }

    function getAuctionById(uint256 _auctionId)
        external
        view
        returns (
            string memory,
            uint256,
            uint256,
            string memory,
            uint256,
            address,
            address,
            bool,
            bool
        )
    {
        Auction memory auc = auctions[_auctionId];
        return (
            auc.name,
            auc.blockDeadline,
            auc.startPrice,
            auc.metadata,
            auc.deedId,
            auc.deedRepositoryAddress,
            auc.owner,
            auc.active,
            auc.finalized
        );
    }

    function createAuction(
        address _deedRepositoryAddress,
        uint256 _deedId,
        string memory _auctionTitle,
        string memory _metadata,
        uint256 _startPrice,
        uint256 _blockDeadline
    )
        external
        contractIsDeedOwner(_deedRepositoryAddress, _deedId)
        returns (bool)
    {
        uint256 auctionId = auctions.length;
        Auction memory newAuction = Auction({
            name: _auctionTitle,
            blockDeadline: _blockDeadline,
            startPrice: _startPrice,
            metadata: _metadata,
            deedId: _deedId,
            deedRepositoryAddress: _deedRepositoryAddress,
            owner: payable(msg.sender),
            active: true,
            finalized: false
        });

        auctions.push(newAuction);
        auctionOwner[msg.sender].push(auctionId);

        emit AuctionCreated(msg.sender, auctionId);
        return true;
    }

    function approveAndTransfer(
        address _from,
        address _to,
        address _deedRepositoryAddress,
        uint256 _deedId
    ) internal returns (bool) {
        DeedRepository remoteContract = DeedRepository(_deedRepositoryAddress);
        remoteContract.approve(_to, _deedId);
        remoteContract.transferFrom(_from, _to, _deedId);
        return true;
    }

    function cancelAuction(uint256 _auctionId) internal isOwner(_auctionId) {
        Auction storage myAuction = auctions[_auctionId];
        uint256 bidsLength = auctionBids[_auctionId].length;

        if (bidsLength > 0) {
            Bid memory lastBid = auctionBids[_auctionId][bidsLength - 1];
            (bool success, ) = lastBid.from.call{value: lastBid.amount}("");
            require(success, "Refund to last bidder failed");
        }

        bool transferred = approveAndTransfer(address(this), myAuction.owner, myAuction.deedRepositoryAddress, myAuction.deedId);
        require(transferred, "Transfer back to owner failed");

        myAuction.active = false;
        emit AuctionCanceled(msg.sender, _auctionId);
    }

    function finalizeAuction(uint256 _auctionId) external {
        Auction storage myAuction = auctions[_auctionId];
        uint256 bidsLength = auctionBids[_auctionId].length;

        require(block.timestamp >= myAuction.blockDeadline, "Auction not yet ended");
        require(myAuction.active && !myAuction.finalized, "Already finalized");

        if (bidsLength == 0) {
            cancelAuction(_auctionId);
            return;
        }

        Bid memory lastBid = auctionBids[_auctionId][bidsLength - 1];
        (bool success, ) = myAuction.owner.call{value: lastBid.amount}("");
        require(success, "Transfer to auction owner failed");

        bool transferred = approveAndTransfer(address(this), lastBid.from, myAuction.deedRepositoryAddress, myAuction.deedId);
        require(transferred, "NFT transfer to winner failed");

        myAuction.active = false;
        myAuction.finalized = true;
        emit AuctionFinalized(msg.sender, _auctionId);
    }

    function bidOnAuction(uint256 _auctionId) external payable {
        Auction storage myAuction = auctions[_auctionId];

        require(myAuction.active, "Auction is not active");
        require(block.timestamp <= myAuction.blockDeadline, "Auction expired");
        require(msg.sender != myAuction.owner, "Owner cannot bid");

        uint256 ethAmountSent = msg.value;
        uint256 bidsLength = auctionBids[_auctionId].length;
        uint256 currentPrice = myAuction.startPrice;

        if (bidsLength > 0) {
            Bid memory lastBid = auctionBids[_auctionId][bidsLength - 1];
            currentPrice = lastBid.amount;

            require(ethAmountSent > currentPrice, "Bid too low");

            (bool refundSuccess, ) = lastBid.from.call{value: lastBid.amount}("");
            require(refundSuccess, "Refund to previous bidder failed");
        } else {
            require(ethAmountSent >= currentPrice, "Bid below starting price");
        }

        auctionBids[_auctionId].push(Bid({
            from: payable(msg.sender),
            amount: ethAmountSent
        }));

        emit BidSuccess(msg.sender, _auctionId);
    }

    event BidSuccess(address indexed from, uint256 indexed auctionId);
    event AuctionCreated(address indexed owner, uint256 indexed auctionId);
    event AuctionCanceled(address indexed owner, uint256 indexed auctionId);
    event AuctionFinalized(address indexed sender, uint256 indexed auctionId);
}
