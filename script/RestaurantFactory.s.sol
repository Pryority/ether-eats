// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/RestaurantFactory.sol";

contract RestaurantFactoryScript is Script {
    RestaurantFactory public restaurantFactory;

    function setUp() public {
        restaurantFactory = new RestaurantFactory();
    }

    function run() public {
        vm.broadcast();
    }
}
