// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

/** ---------------------------------------- */
/**  Create, read, update, and delete your   */
/**          restaurant menu items           */
/** ---------------------------------------- */

contract Restaurant {
    /** ------------------------------------ */
    /** CONSTRUCTOR                          */
    /** ------------------------------------ */
    constructor(string memory _name, address _owner) {
        name = _name;
        owner = _owner;
    }

    /** ------------------------------------ */
    /** STRUCTS                              */
    /** ------------------------------------ */
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

    /** ------------------------------------ */
    /** VARIABLES                            */
    /** ------------------------------------ */
    string public name;
    address public owner;
    bytes32[] public itemIds;
    uint256 public menuItemsTotal;
    mapping(bytes32 => MenuItem) public menuItems; // Change to mapping

    /** ------------------------------------ */
    /** EVENTS                               */
    /** ------------------------------------ */
    event RestaurantUpdated(
        string name,
        address indexed owner,
        bytes32[] itemIds
    );
    event MenuItemAdded(
        bytes32 name,
        uint256 price,
        bytes32 category,
        bytes32[] options
    );

    /** ------------------------------------ */
    /** MODIFIERS                            */
    /** ------------------------------------ */
    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only the owner of the Restaurant can update this restaurant"
        );
        _;
    }

    /** ------------------------------------ */
    /** FUNCTIONS                            */
    /** ------------------------------------ */
    function getInitParams() public view returns (bytes memory) {
        return abi.encode(name, owner);
    }

    function getAllMenuItems() public view returns (MenuItem[] memory) {
        MenuItem[] memory items = new MenuItem[](menuItemsTotal);

        for (uint256 i = 0; i < menuItemsTotal; ++i) {
            bytes32 itemId = itemIds[i];
            items[i] = menuItems[itemId];
        }

        return items;
    }

    function addMenuItem(
        string memory _name,
        uint256 _price,
        bool _isAvailable,
        bytes32 _category,
        bytes32[] memory _options
    ) public payable onlyOwner {
        bytes32 itemName = bytes32(keccak256(bytes(_name)));
        // Create a new MenuItem and add it to the menuItems mapping
        MenuItem memory newItem = MenuItem(
            itemName,
            _price,
            _isAvailable,
            _category,
            _options
        );
        menuItems[itemName] = newItem;

        emit MenuItemAdded(itemName, _price, _category, _options);

        ++menuItemsTotal;
    }

    function getMenuItemByBytes32(
        bytes32 _name
    ) public view returns (MenuItem memory) {
        return menuItems[_name];
    }

    function getMenuItemByName(
        string memory _name
    ) public view returns (MenuItem memory) {
        return menuItems[bytes32(keccak256(bytes(_name)))];
    }

    function getMenuItemsTotal() public view returns (uint256) {
        return menuItemsTotal;
    }

    function setName(string memory _name) public payable onlyOwner {
        name = _name;

        emit RestaurantUpdated(name, owner, itemIds);
    }

    function setRestaurant(
        string memory _name,
        address _newOwner,
        bytes32[] memory _ItemIds
    ) public payable onlyOwner {
        name = _name;
        owner = _newOwner;
        itemIds = _ItemIds;

        emit RestaurantUpdated(name, owner, itemIds);
    }

    function getRestaurant(
        address addr
    ) public view returns (string memory, address, MenuItem[] memory) {
        require(addr != address(0), "Invalid address");
        MenuItem[] memory items = getAllMenuItems();
        return (name, owner, items);
    }
}
