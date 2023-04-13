// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/RestaurantStorage.sol";

contract RestaurantStorageTest is Test {
    RestaurantStorage public rs;

    function setUp() public {
        rs = new RestaurantStorage();
    }

    // struct Restaurant { string name; address owner; uint256[] productIds; }
    // struct Product { string name; uint256 price; }

    function testAddRestaurant() public {
        (string memory name, address owner) = rs.restaurants(address(0));
        rs.addRestaurant("My Restaurant");
        (string memory newName, address newOwner) = rs.restaurants(address(0));
        assertEq(name, newName);
        assertEq(owner, newOwner);
        assertEq(rs.productCount(), 0);
    }

    function testAddProduct() public {
        RestaurantStorage restaurantStorage = new RestaurantStorage();
        restaurantStorage.addRestaurant("My Restaurant");
        restaurantStorage.addProduct("Pizza", 10000000000000000);

        string memory expectedName = "My Restaurant"; // Get value for updated restaurant name
        uint256 expectedProductCount = 1; // Get value for updated restaurant product count

        // Get the actual values from the contract
        (
            string memory actualName,
            uint256 actualProductCount
        ) = restaurantStorage.getProduct(address(this));

        assertEq(actualName, expectedName); // Assert the expected and actual values
        assertEq(actualProductCount, expectedProductCount); // Assert the expected and actual values
    }

    function testSetRestaurant() public {
        // Add code to create a new restaurant and get the owner's address
        rs.addRestaurant("My Restaurant");
        address owner = msg.sender;
        vm.prank(owner);

        // Call the setRestaurant() function with the owner's address and update the restaurant details
        string memory newName = "Updated Restaurant";
        address newOwner = address(0);
        uint256[] memory newProductIds = new uint256[](0);
        rs.setRestaurant(owner, newName, newOwner, newProductIds);

        // Assert that the restaurant details are updated correctly
        (
            string memory actualName,
            address actualOwner,
            uint256[] memory actualProductIds
        ) = rs.getRestaurant(owner);
        assertEq(actualName, newName);
        assertEq(actualOwner, newOwner);
        assertEq(actualProductIds.length, newProductIds.length);
        // Add other assertions for the updated restaurant details
    }
}

// function testUpdateRestaurant() public {
//     // Add a restaurant
//     rs.addRestaurant("My Restaurant");
//     address owner = msg.sender;
//     (
//         string memory updatedName,
//         address updatedOwner,
//         uint256[] memory productIds
//     ) = rs.getRestaurant(owner);
//     updatedName = "Updated Restaurant";
//     rs.setRestaurant(owner, updatedName, updatedOwner, productIds);

//     // Check if the restaurant name is updated
//     (string memory retrievedName, , ) = rs.getRestaurant(owner);
//     assertEq(retrievedName, "Updated Restaurant");
// }
