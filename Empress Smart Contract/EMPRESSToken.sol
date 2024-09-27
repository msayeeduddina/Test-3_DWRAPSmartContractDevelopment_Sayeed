// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// EMPRESS Token Contract
contract EMPRESSToken is ERC20 {

    constructor(uint256 initialSupply) ERC20("EMPRESS Token", "EMP") {
        _mint(msg.sender, initialSupply);
    }

}