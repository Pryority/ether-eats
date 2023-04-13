// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./Restaurant.sol";

contract RestaurantFactory {
    struct RestaurantInfo {
        address owner;
        address restaurant;
        string name;
    }

    RestaurantInfo[] public restaurants;
    uint256 public totalRestaurants;

    function createRestaurant(string memory _name) public payable {
        require(bytes(_name).length > 0, "Restaurant NAME required");
        require(
            getRestaurantByOwner(msg.sender) == address(0),
            "Restaurant already exists"
        );

        Restaurant restaurant = new Restaurant(_name, msg.sender);
        restaurants.push(
            RestaurantInfo({
                owner: msg.sender,
                restaurant: address(restaurant),
                name: _name
            })
        );
        ++totalRestaurants;
    }

    function getTotalRestaurants() public view returns (uint256) {
        return totalRestaurants;
    }

    function getRestaurantIndex(address _addr) public view returns (uint256) {
        require(
            getRestaurantByOwner(_addr) != address(0),
            "Restaurant not found"
        );
        return _getIndexOfElement(_addr);
    }

    function _getIndexOfElement(address _addr) private view returns (uint256) {
        for (uint256 i = 0; i < restaurants.length; i++) {
            if (restaurants[i].owner == _addr) {
                return i;
            }
        }
        revert("Element not found");
    }

    function getRestaurantBytes(
        address _addr
    ) public view returns (bytes memory) {
        address restaurantAddr = getRestaurantByOwner(_addr);
        require(restaurantAddr != address(0), "Restaurant not found");

        Restaurant restaurant = Restaurant(restaurantAddr);
        bytes memory restaurantBytes = abi.encodePacked(
            type(Restaurant).creationCode,
            restaurant.getInitParams() // Assuming Restaurant contract has a function to get its constructor arguments
        );

        return restaurantBytes;
    }

    function getOwnerByIndex(uint256 _id) public view returns (address) {
        require(
            _id >= 0 && _id < getTotalRestaurants(),
            "Invalid restaurant index"
        );
        return restaurants[_id].owner;
    }

    function getRestaurantByIndex(
        uint256 _id
    ) public view returns (address restaurant) {
        require(
            _id >= 0 && _id < getTotalRestaurants(),
            "Invalid restaurant index"
        );
        return restaurants[_id].restaurant;
    }

    function getRestaurantByOwner(
        address _owner
    ) public view returns (address) {
        for (uint256 i = 0; i < restaurants.length; i++) {
            if (restaurants[i].owner == _owner) {
                return restaurants[i].restaurant;
            }
        }
        return address(0);
    }
}
