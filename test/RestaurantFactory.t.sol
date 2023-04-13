// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/RestaurantFactory.sol";
import "../src/Restaurant.sol";

contract RestaurantFactoryTest is Test {
    RestaurantFactory public rf;
    address public owner;

    function setUp() public {
        rf = new RestaurantFactory();
        owner = msg.sender;
    }

    function testCreateRestaurant() public {
        vm.prank(owner);
        string memory name = "My Restaurant";
        rf.createRestaurant(name);
        address restaurantAddr = rf.getRestaurantByOwner(owner);
        Restaurant restaurant = Restaurant(restaurantAddr);
        (
            string memory restaurantName,
            address restaurantOwner,
            uint256[] memory productIds
        ) = restaurant.getRestaurant(owner);
        assertEq(restaurantName, name);
        assertEq(restaurantOwner, owner);
        assertEq(productIds.length, 0); // Assuming productIds should be empty initially
    }

    function testGetTotalRestaurants() public {
        string memory name = "My Restaurant";
        rf.createRestaurant(name);
        assertEq(rf.getTotalRestaurants(), 1);
    }

    function testGetRestaurantByIndex() public {
        vm.prank(owner);
        // Create a restaurant
        string memory name = "My Restaurant";
        rf.createRestaurant(name);

        // Get the address of the created restaurant
        address restaurantAddr = rf.getRestaurantByOwner(owner);

        // Get the restaurant index
        uint256 restaurantIndex = rf.getRestaurantIndex(owner);

        // Retrieve the restaurant by index
        address retrievedRestaurant = rf.getRestaurantByIndex(restaurantIndex);

        // Assert that the retrieved restaurant address is the same as the created restaurant address
        assertEq(retrievedRestaurant, restaurantAddr);
    }

    // Test for getRestaurantIndex function
    function testGetRestaurantIndex() public {
        vm.prank(owner);
        // Create a restaurant
        string memory name = "My Restaurant";
        rf.createRestaurant(name);

        // Get the restaurant index
        uint256 restaurantIndex = rf.getRestaurantIndex(owner);

        // Assert that the retrieved restaurant index is greater than or equal to 0
        assertGe(restaurantIndex, 0);
    }

    // Test for getRestaurantBytes function
    function testGetRestaurantBytes() public {
        vm.prank(owner);
        // Create a restaurant
        string memory name = "My Restaurant";
        rf.createRestaurant(name);

        // Get the encoded bytes of the restaurant contract
        bytes memory restaurantBytes = rf.getRestaurantBytes(owner);

        // Assert that the length of the restaurantBytes is greater than 0
        assertGt(restaurantBytes.length, 0);
    }

    // Test for getOwnerByIndex function
    function testGetOwnerByIndex() public {
        vm.prank(owner);
        // Create a restaurant
        string memory name = "My Restaurant";
        rf.createRestaurant(name);

        // Get the restaurant index
        uint256 restaurantIndex = rf.getRestaurantIndex(owner);

        // Get the owner address by index
        address retrievedOwner = rf.getOwnerByIndex(restaurantIndex);

        // Assert that the retrieved owner address is the same as the owner address used to create the restaurant
        assertEq(retrievedOwner, owner);
    }
}
