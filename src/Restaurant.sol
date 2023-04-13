// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Restaurant {
    /** ------------------------------------ */
    /** VARIABLES                            */
    /** ------------------------------------ */
    string public name;
    address public owner;
    uint256[] public productIds;

    /** ------------------------------------ */
    /** EVENTS                               */
    /** ------------------------------------ */
    event RestaurantUpdated(
        string name,
        address indexed owner,
        address indexed newOwner,
        uint256[] productIds
    );

    /** ------------------------------------ */
    /** CONSTRUCTOR                          */
    /** ------------------------------------ */
    constructor(string memory _name, address _owner) {
        name = _name;
        owner = _owner;
    }

    function getInitParams() public view returns (bytes memory) {
        return abi.encode(name, owner);
    }

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only the owner of the Restaurant can update this restaurant"
        );
        _;
    }

    /** ------------------------------------ */
    /** FUNCTIONS                            */
    /** ------------------------------------ */
    function addProduct(string memory _name, uint256 _price) public payable {
        // Add implementation for adding product to the restaurant
    }

    function getProductCount() public view returns (uint256) {
        // Add implementation for getting product count for the restaurant
    }

    function setRestaurant(
        string memory _name,
        address _newOwner,
        uint256[] memory _productIds
    ) public onlyOwner {
        name = _name;
        owner = _newOwner;
        productIds = _productIds;

        emit RestaurantUpdated(name, msg.sender, _newOwner, productIds);
    }

    function getRestaurant(
        address addr
    ) public view returns (string memory, address, uint256[] memory) {
        require(addr != address(0), "Invalid address");
        return (name, owner, productIds);
    }
}
