
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract DegenToken is ERC20, Ownable, ERC20Burnable {
    struct PlayerItems {
        uint tshirt;
        uint sword;
        uint hat;
        uint bomb;
    }

    mapping(address => PlayerItems) public playerItems;

    // Numerical identifiers for items
    uint constant TSHIRT = 1;
    uint constant SWORD = 2;
    uint constant HAT = 3;
    uint constant BOMB = 4;

    constructor() ERC20("Degen", "DGN") Ownable(msg.sender) {}

    function mint(address _to, uint amt) external onlyOwner {
        _mint(_to, amt);
    }

    function transferTokens(address _to, uint amt) public {
        require(amt <= balanceOf(msg.sender), "Low degen");
        _transfer(msg.sender, _to, amt);
    }

    function redeemItem(uint _itemId, uint _price) public {
        require(_itemId >= TSHIRT && _itemId <= BOMB, "Invalid item ID");
        require(balanceOf(msg.sender) >= _price, "Insufficient balance");

        if (_itemId == TSHIRT) {
            playerItems[msg.sender].tshirt += 1;
        } else if (_itemId == SWORD) {
            playerItems[msg.sender].sword += 1;
        } else if (_itemId == HAT) {
            playerItems[msg.sender].hat += 1;
        } else if (_itemId == BOMB) {
            playerItems[msg.sender].bomb += 1;
        } else {
            revert("Invalid item ID");
        }

        _burn(msg.sender, _price);
    }

    function burn(address _of, uint amt) public {
        _burn(_of, amt);
    }

    function checkBalance() public view returns (uint) {
        return balanceOf(msg.sender);
    }
}
