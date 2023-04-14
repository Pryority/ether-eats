// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Restaurant.sol";

contract RestaurantTest is Test {
    Restaurant public restaurant;
    string public restaurantName;
    address public owner;
    uint256[] public itemIds;

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
        // assertEq(expectedItemOptions, bytes32["Option1"](2));
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

    // function testAddMenuItem() public {
    //     // Define the options for the new MenuItem
    //     bytes32[] memory itemOptions = new bytes32[](2);
    //     itemOptions[0] = "Option1";
    //     itemOptions[1] = "Option2";

    //     // Call the addMenuItem function with the options
    //     bytes32 itemName = "Burger";
    //     uint256 itemPrice = 10;
    //     bytes32 itemCategory = "Main";
    //     restaurant.addMenuItem(itemName, itemPrice, itemCategory, itemOptions);

    //     // Retrieve the newly added MenuItem from the Restaurant contract
    //     Restaurant.MenuItem memory newItem = restaurant.menuItems(itemName);

    //     // Assert that the retrieved MenuItem has the correct values
    //     assertEq(newItem.name, itemName);
    //     assertEq(newItem.price, itemPrice);
    //     assertEq(newItem.category, itemCategory);

    //     // Assert that the retrieved MenuItem has the correct options
    //     assertEq(newItem.options.length, 2);
    //     assertEq(newItem.options[0], "Option1");
    //     assertEq(newItem.options[1], "Option2");
    // }

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

// function testCreateMenuItem() public {
//     // Create an Option array to pass as an argument to createMenuItem function
//     Restaurant.Option[] memory options = new Restaurant.Option[](2);
//     options[0] = Restaurant.Option("Option 1", 50);
//     options[1] = Restaurant.Option("Option 2", 100);

//     // Call createMenuItem function
//     restaurant.addMenuItem("Product 1", 100, true, options);

//     // Assert that the menu item count has increased by 1
//     uint256 itemCount = restaurant.getItemCount();
//     assertEq(itemCount, 1);

//     // Retrieve the created MenuItem
//     Restaurant.MenuItem memory newItem = restaurant.menuItems(
//         itemCount - 1
//     ); // MenuItem index is 0-based

//     // Assert the properties of the created menu item
//     assertEq(newItem.name, "Product 1");
//     assertEq(newItem.price, 100);
//     assertTrue(newItem.isAvailable);

//     // Assert that the created menu item has the correct options
//     assertEq(newItem.options.length, 2);
//     assertEq(newItem.options[0].name, "Option 1");
//     assertEq(newItem.options[0].price, 50);
//     assertEq(newItem.options[1].name, "Option 2");
//     assertEq(newItem.options[1].price, 100);
// }

// function testOnlyOwnerModifier() public {
//     string memory newName = "New Restaurant";
//     address newOwner = address(0x1234567890123456789012345678901234567890);
//     uint256[] memory newItemIds = new uint256[](2);
//     newItemIds[0] = 1;
//     newItemIds[1] = 2;
//     // Try to call setRestaurant from an address other than the owner
//     restaurant.setRestaurant(newName, newOwner, newItemIds, from(owner));
//     // Assert that the transaction reverts
//     assertEq(vm.exception(), uint32(Exception.Revert));
// }
