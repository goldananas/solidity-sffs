// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.7;

/// Exemple of Foy Smart Contract implementation
contract Foy {
    struct BeerInventory {
        uint256 nbChouffe;
        uint256 nbLaBete;
        uint256 nbTripleGrim;
    }

    mapping(string => uint256) private beerPrices;
    mapping(address => BeerInventory) private inventories;
    // The contract's owner etherium address
    address private owner;
    // The unix time the happy hour ends
    uint256 private happyHourEnd;

    /// Event emitted when the happy hour starts
    event HappyHourStart(uint256 duration);

    error LessThanPrice(uint256 price);
    error OnlyOwner();

    // Revert if msg.value inferior than given price and throws LessThanPrice error
    modifier moreThanPrice(uint256 price) {
        if (msg.value < price) revert LessThanPrice(price);
        _;
    }

    // Revert if different than owner wallet address and throws OnlyOwner error
    modifier onlyOwner() {
        if (msg.sender != owner) revert OnlyOwner();
        _;
    }

    constructor() {
        owner = msg.sender;
        beerPrices["chouffe"] = 0.0008 ether;
        beerPrices["labete"] = 0.001 ether;
        beerPrices["triplegrim"] = 0.0012 ether;
    }

    function buyChouffe() public payable {
        uint256 price = getPrice("chouffe");

        if (msg.value < price) revert LessThanPrice(price);

        inventories[msg.sender].nbChouffe++;
        payable(owner).transfer(price);
        payable(msg.sender).transfer(msg.value - price);
    }

    function buyLaBete() public payable {
        uint256 price = getPrice("labete");

        if (msg.value < price) revert LessThanPrice(price);

        inventories[msg.sender].nbLaBete++;
        payable(owner).transfer(price);
        payable(msg.sender).transfer(msg.value - price);
    }

    function buyTripleGrim() public payable {
        uint256 price = getPrice("triplegrim");

        if (msg.value < price) revert LessThanPrice(price);

        inventories[msg.sender].nbTripleGrim++;
        payable(owner).transfer(price);
        payable(msg.sender).transfer(msg.value - price);
    }

    function getMyInventory() public view returns (BeerInventory memory) {
        return inventories[msg.sender];
    }

    function getNormalPrices()
        public
        view
        returns (
            uint256,
            uint256,
            uint256
        )
    {
        return (
            beerPrices["chouffe"],
            beerPrices["labete"],
            beerPrices["triplegrim"]
        );
    }

    function getPricesHappyHour()
        public
        view
        returns (
            uint256,
            uint256,
            uint256
        )
    {
        return (
            beerPrices["chouffe"] / 2,
            beerPrices["labete"] / 2,
            beerPrices["triplegrim"] / 2
        );
    }

    function getOwner() public view returns (address) {
        return owner;
    }

    // Start the happy hour with a given duration
    function happyHour(uint256 duration) public onlyOwner {
        happyHourEnd = duration + block.timestamp;
        emit HappyHourStart(happyHourEnd);
    }

    function getPrice(string memory beerName) public view returns (uint256) {
        if (happyHourEnd > block.timestamp) {
            return beerPrices[beerName] / 2;
        } else {
            return beerPrices[beerName];
        }
    }
}
