// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract WrappedEMPRESSToken is ERC20, Ownable {

    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    IERC20 public nativeToken;

    //Events
    event Wrapped(address indexed user, uint256 amount);
    event Unwrapped(address indexed user, uint256 amount);

    //Constructor
    constructor(address _nativeToken) ERC20("Wrapped EMP", "WEMP") {
        require(_nativeToken != address(0), "WrappedEMP: Invalid native token address");
        nativeToken = IERC20(_nativeToken);
    }

    //User
    function wrap(uint256 amount) external {
        require(amount > 0, "WrappedEMP: Amount must be greater than zero");
        require(nativeToken.balanceOf(msg.sender) >= amount, "WrappedEMP: Insufficient balance");
        nativeToken.safeTransferFrom(msg.sender, address(this), amount);
        _mint(msg.sender, amount);
        emit Wrapped(msg.sender, amount);
    }

    function unwrap(uint256 amount) external {
        require(amount > 0, "WrappedEMP: Amount must be greater than zero");
        require(balanceOf(msg.sender) >= amount, "WrappedEMP: Insufficient wrapped token balance");
        _burn(msg.sender, amount);
        nativeToken.safeTransfer(msg.sender, amount);
        emit Unwrapped(msg.sender, amount);
    }

    //View 
    function getNativeTokenAddress() external view returns(address) {
        return address(nativeToken);
    }

}