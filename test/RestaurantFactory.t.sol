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

    // function testGetRestaurantByIndex() public {
    //     // Create a restaurant
    //     string memory name = "My Restaurant";
    //     rf.createRestaurant(name);

    //     // Get the address of the created restaurant
    //     address restaurantAddr = rf.getRestaurantByOwner(owner);
    //     Restaurant restaurant = Restaurant(restaurantAddr);

    //     // Get the restaurant index
    //     uint256 restaurantIndex = rf.getRestaurantIndex(owner);

    //     // Retrieve the restaurant by index
    //     address retrievedRestaurant = rf.getRestaurantByIndex(restaurantIndex);

    //     // Assert that the retrieved restaurant address is the same as the created restaurant address
    //     assertEq(retrievedRestaurant, restaurantAddr);
    // }
}
