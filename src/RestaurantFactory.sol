// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./Restaurant.sol";

contract RestaurantFactory {
    mapping(address => address) public restaurants;
    address[] public restaurantOwners;
    uint256 public totalRestaurants;

    function createRestaurant(string memory _name) public payable {
        require(bytes(_name).length > 0, "Restaurant NAME required");
        require(
            restaurants[msg.sender] == address(0),
            "Restaurant already exists"
        );

        Restaurant restaurant = new Restaurant(_name, msg.sender);
        restaurants[msg.sender] = address(restaurant);
        ++totalRestaurants;
    }

    function getTotalRestaurants() public view returns (uint256) {
        return totalRestaurants;
    }

    function getOwnerByIndex(uint256 _id) public view returns (address) {
        return restaurantOwners[_id];
    }

    function getRestaurantByIndex(
        uint256 _id
    ) public view returns (address restaurant) {
        require(
            _id >= 0 && _id < getTotalRestaurants(),
            "Invalid restaurant index"
        );
        return restaurants[getOwnerByIndex(_id)];
    }

    function getRestaurantByOwner(
        address _owner
    ) public view returns (address) {
        return restaurants[_owner];
    }
}
