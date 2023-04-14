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
    uint256[] public itemIds;
    uint256 public menuItemsTotal;
    mapping(bytes32 => MenuItem) public menuItems; // Change to mapping

    /** ------------------------------------ */
    /** EVENTS                               */
    /** ------------------------------------ */
    event RestaurantUpdated(
        string name,
        address indexed owner,
        address indexed newOwner,
        uint256[] itemIds
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

    function addMenuItem(
        bytes32 _name,
        uint256 _price,
        bool _isAvailable,
        bytes32 _category,
        bytes32[] memory _options
    ) public payable {
        // Create a new MenuItem and add it to the menuItems mapping
        MenuItem memory newItem = MenuItem(
            _name,
            _price,
            _isAvailable,
            _category,
            _options
        );
        bytes32 newItemId = _name; // Convert string to bytes32 for use as key
        menuItems[newItemId] = newItem;

        // Emit an event to indicate that a new item has been added
        emit MenuItemAdded(_name, _price, _category, _options);

        ++menuItemsTotal;
    }

    function getMenuItemsTotal() public view returns (uint256) {
        return menuItemsTotal;
    }

    function setRestaurant(
        string memory _name,
        address _newOwner,
        uint256[] memory _ItemIds
    ) public payable onlyOwner {
        name = _name;
        owner = _newOwner;
        itemIds = _ItemIds;

        emit RestaurantUpdated(name, msg.sender, _newOwner, itemIds);
    }

    function getRestaurant(
        address addr
    ) public view returns (string memory, address, uint256[] memory) {
        require(addr != address(0), "Invalid address");
        return (name, owner, itemIds);
    }
}
