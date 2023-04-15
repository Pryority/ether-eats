// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "@openzeppelin/utils/math/SafeMath.sol";
using SafeMath for uint256;

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
    uint256 public MAX_MENU_ITEMS = 128;
    mapping(bytes32 => MenuItem) public menuItems;
    mapping(bytes32 => Option) public options;

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

    /** MENU FUNCTIONS ---------------------- */

    function addMenuItem(
        string memory _name,
        uint256 _price,
        bool _isAvailable,
        bytes32 _category,
        bytes32[] memory _options
    ) public payable onlyOwner {
        require(menuItemsTotal < MAX_MENU_ITEMS, "Menu storage is full");
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

        menuItemsTotal++;
    }

    function setMenuItemName(bytes32 _itemId, bytes32 _name) public onlyOwner {
        require(menuItems[_itemId].name != bytes32(0), "Item not found");
        menuItems[_itemId].name = _name;
    }

    function setMenuItemPrice(
        bytes32 _itemId,
        uint256 _price
    ) public onlyOwner {
        require(menuItems[_itemId].name != bytes32(0), "Item not found");
        menuItems[_itemId].price = _price;
    }

    function setMenuItemAvailability(
        bytes32 _itemId,
        bool _isAvailable
    ) public onlyOwner {
        require(menuItems[_itemId].name != bytes32(0), "Item not found");
        menuItems[_itemId].isAvailable = _isAvailable;
    }

    function setMenuItemCategory(
        bytes32 _itemId,
        bytes32 _category
    ) public onlyOwner {
        require(menuItems[_itemId].name != bytes32(0), "Item not found");
        menuItems[_itemId].category = _category;
    }

    function setMenuItemOptions(
        bytes32 _itemId,
        bytes32[] memory _options
    ) public onlyOwner {
        require(menuItems[_itemId].name != bytes32(0), "Item not found");
        menuItems[_itemId].options = _options;
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

    // function updateMenuItemOptions(
    //     bytes32 itemId,
    //     bytes32[] memory newOptions
    // ) external onlyOwner {
    //     require(
    //         menuItems[itemId].name != bytes32(0),
    //         "Menu item does not exist"
    //     );

    //     // Update the options for the given menu item
    //     menuItems[itemId].options = newOptions;
    // }

    function addOption(
        bytes32 optionId,
        string memory optionName,
        uint256 optionPrice
    ) public {
        Option memory newOption = Option(
            bytes32(keccak256(bytes(optionName))),
            optionPrice
        );
        options[optionId] = newOption;
    }

    function getOption(
        bytes32 optionId
    ) public view returns (bytes32, uint256) {
        Option storage option = options[optionId];
        return (option.name, option.price);
    }

    // function setMenuItemOptionPrice(
    //     bytes32 _itemId,
    //     bytes32 _optionId,
    //     uint256 _price
    // ) public onlyOwner {
    //     require(menuItems[_itemId].name != bytes32(0), "Item not found");
    //     require(options[_optionId].name != bytes32(0), "Option not found");

    //     // Get the index of the option in the item's options array
    //     bytes32[] storage itemOptions = menuItems[_itemId].options;
    //     uint256 optionIndex = 999999999; // initialize with a large value as invalid index
    //     for (uint256 i = 0; i < itemOptions.length; i++) {
    //         if (itemOptions[i] == _optionId) {
    //             optionIndex = i;
    //             break;
    //         }
    //     }

    //     require(optionIndex < itemOptions.length, "Option not found in item");

    //     // Update the price of the option
    //     menuItems[_itemId].price = menuItems[_itemId]
    //         .price
    //         .sub(options[_optionId].price)
    //         .add(_price);
    //     options[_optionId].price = _price;
    // }

    function deleteMenuItem(bytes32 itemId) external onlyOwner {
        require(
            menuItems[itemId].name != bytes32(0),
            "Menu item does not exist"
        );

        // Find the index of the item in the itemIds array
        uint256 indexToRemove;
        for (uint256 i = 0; i < menuItemsTotal; i++) {
            if (itemIds[i] == itemId) {
                indexToRemove = i;
                break;
            }
        }

        require(
            indexToRemove < menuItemsTotal,
            "Item not found in itemIds array"
        );

        // Remove the item from the itemIds array
        for (uint256 i = indexToRemove; i < menuItemsTotal - 1; i++) {
            itemIds[i] = itemIds[i + 1];
        }
        itemIds.pop();

        // Delete the item from the menuItems mapping
        delete menuItems[itemId];

        menuItemsTotal = menuItemsTotal.sub(1);
    }

    function setRestaurantName(string memory _name) public payable onlyOwner {
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
