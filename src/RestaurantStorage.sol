// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract RestaurantStorage {
    /** ------------------------------------ */
    /** VARIABLES                            */
    /** ------------------------------------ */
    mapping(address => Restaurant) public restaurants;
    mapping(uint256 => Product) public products;
    uint256 public productCount;

    /** ------------------------------------ */
    /** STRUCTS                              */
    /** ------------------------------------ */
    struct Restaurant {
        string name;
        address owner;
        uint256[] productIds;
        // Add other important details about the restaurant here
    }

    struct Product {
        string name;
        uint256 price;
        // Add other details about the product here
    }

    /** ------------------------------------ */
    /** FUNCTIONS                            */
    /** ------------------------------------ */
    function addRestaurant(string memory _name) public payable {
        require(bytes(_name).length > 0, "Restaurant NAME required");
        require(
            restaurants[msg.sender].owner == address(0),
            "Restaurant already exists"
        );

        restaurants[msg.sender] = Restaurant({
            name: _name,
            owner: msg.sender,
            productIds: new uint256[](0)
        });
    }

    function addProduct(string memory _name, uint256 _price) public payable {
        require(bytes(_name).length > 0, "Product NAME required");
        require(_price > 0, "Product PRICE must be greater than zero");

        uint256 productId = productCount + 1; // Generate new unique product ID
        products[productId] = Product({name: _name, price: _price});
        ++productCount;
        restaurants[msg.sender].productIds.push(productId);
    }

    function getProduct(
        address _owner
    ) public view returns (string memory, uint256) {
        return (
            restaurants[_owner].name,
            restaurants[_owner].productIds.length
        );
    }

    function getRestaurant(
        address _owner
    ) public view returns (string memory, address, uint256[] memory) {
        Restaurant memory r = restaurants[_owner];
        return (r.name, r.owner, r.productIds);
    }

    function setRestaurant(
        address _owner,
        string memory _name,
        address _newOwner,
        uint256[] memory _productIds
    ) public {
        require(
            msg.sender == _owner,
            "Only the owner of the Restaurant can update this restaurant"
        );
        restaurants[_owner].name = _name;
        restaurants[_owner].owner = _newOwner;
        restaurants[_owner].productIds = _productIds;
    }
}
