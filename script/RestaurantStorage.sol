// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/RestaurantStorage.sol";

contract RestaurantStorageScript is Script {
    RestaurantStorage public restaurantStorage;

    function setUp() public {
        restaurantStorage = new RestaurantStorage();
    }

    function run() public {
        vm.broadcast();
    }
}
