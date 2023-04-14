// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Restaurant.sol";

contract RestaurantTest is Test {
    Restaurant public restaurant;
    string public restaurantName;
    address public owner;
    uint256[] public itemIds;

    struct Option {
        bytes32 name;
        uint256 price;
    }
    struct MenuItem {
        bytes32 name;
        uint256 price;
        bool isAvailable;
        bytes32 category;
        bytes32[] options;
    }

    function setUp() public {
        restaurantName = "My Restaurant";
        owner = msg.sender;
        restaurant = new Restaurant(restaurantName, owner);
    }

    function testConstructor() public {
        assertEq(restaurant.name(), restaurantName);
        assertEq(restaurant.owner(), owner);
    }

    function testAddMenuItem() public {
        bytes32 expectedItemName = "Product 1";
        uint256 expectedItemPrice = 100;
        bool expectedIsAvailable = true;
        bytes32 expectedItemCategory = "Main";
        bytes32[] memory expectedItemOptions = new bytes32[](2);
        expectedItemOptions[0] = "Option1";
        expectedItemOptions[1] = "Option2";

        restaurant.addMenuItem(
            expectedItemName,
            expectedItemPrice,
            expectedIsAvailable,
            expectedItemCategory,
            expectedItemOptions
        );

        assertEq(restaurant.getMenuItemsTotal(), 1);
        assertEq(expectedItemName, "Product 1");
        assertEq(expectedItemPrice, 100);
        assertEq(expectedIsAvailable, true);
        assertEq(expectedItemCategory, "Main");
    }

    function testGetMenuItem() public {
        bytes32 expectedItemName = "Product 1";
        uint256 expectedItemPrice = 100;
        bool expectedIsAvailable = true;
        bytes32 expectedItemCategory = "Main";
        bytes32[] memory expectedItemOptions = new bytes32[](2);
        expectedItemOptions[0] = "Option1";
        expectedItemOptions[1] = "Option2";

        restaurant.addMenuItem(
            expectedItemName,
            expectedItemPrice,
            expectedIsAvailable,
            expectedItemCategory,
            expectedItemOptions
        );

        Restaurant.MenuItem memory retrievedMenuItem = restaurant.getMenuItem(
            expectedItemName
        );

        assertEq(retrievedMenuItem.name, expectedItemName);
        assertEq(retrievedMenuItem.price, expectedItemPrice);
        assertEq(retrievedMenuItem.isAvailable, expectedIsAvailable);
        assertEq(retrievedMenuItem.category, expectedItemCategory);
        assertEq(retrievedMenuItem.options.length, expectedItemOptions.length);
        for (uint256 i = 0; i < expectedItemOptions.length; i++) {
            assertEq(retrievedMenuItem.options[i], expectedItemOptions[i]);
        }
    }

    function testSetRestaurant() public {
        vm.prank(owner);
        string memory newName = "New Restaurant";
        address newOwner = address(0x1234567890123456789012345678901234567890);
        uint256[] memory newItemIds = new uint256[](2);
        newItemIds[0] = 1;
        newItemIds[1] = 2;
        restaurant.setRestaurant(newName, newOwner, newItemIds);
        assertEq(restaurant.name(), newName);
        assertEq(restaurant.owner(), newOwner);
        assertEq(restaurant.itemIds(0), newItemIds[0]);
        assertEq(restaurant.itemIds(1), newItemIds[1]);
    }

    function testGetRestaurant() public {
        (
            string memory retrievedName,
            address retrievedOwner,
            uint256[] memory retrieveditemIds
        ) = restaurant.getRestaurant(address(this));
        assertEq(retrievedName, restaurantName);
        assertEq(retrievedOwner, owner);
        assertEq(retrieveditemIds.length, 0); // Assuming itemIds should be empty initially
    }
}
