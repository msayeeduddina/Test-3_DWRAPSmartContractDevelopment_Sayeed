// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract DolaToken is ERC20, Ownable, ERC20Burnable {

    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    IERC20 public collateralToken;
    IERC20 public roiToken;

    //Uint
    uint256 public exchangeRate;

    //Event
    event PegUpdated(uint256 newRate);
    event CollateralDeposited(address indexed user, uint256 amount);
    event CollateralWithdrawn(address indexed user, uint256 amount);
    event ROITokenUpdated(address indexed newROI);

    //Constructor
    constructor(address _collateralToken) ERC20("DOLA Token", "DOLA") {
        require(_collateralToken != address(0), "Dola Token: Invalid collateral token address");
        collateralToken = IERC20(_collateralToken);
        exchangeRate = 1e18;
    }

    //User
    function mintDola(uint256 amount) external {
        require(amount > 0, "DolaToken: Amount must be greater than zero");
        uint256 collateralAmount = amount.mul(exchangeRate).div(1e18);
        collateralToken.safeTransferFrom(msg.sender, address(this), collateralAmount);
        _mint(msg.sender, amount);
        emit CollateralDeposited(msg.sender, collateralAmount);
    }

    function burnDola(uint256 amount) external {
        require(balanceOf(msg.sender) >= amount, "DolaToken: Insufficient balance");
        uint256 collateralAmount = amount.mul(exchangeRate).div(1e18);
        _burn(msg.sender, amount);
        collateralToken.safeTransfer(msg.sender, collateralAmount);
        emit CollateralWithdrawn(msg.sender, collateralAmount);
    }

    function transfer(address to, uint256 amount) public override returns(bool) {
        return super.transfer(to, amount);
    }

    function transferFrom(address from, address to, uint256 amount) public override returns(bool) {
        return super.transferFrom(from, to, amount);
    }

    function setRoiToken(address _roiToken) external onlyOwner {
        require(_roiToken != address(0), "DolaToken: Invalid ROI token address");
        roiToken = IERC20(_roiToken);
        emit ROITokenUpdated(_roiToken);
    }

    function updatePeg(uint256 newRate) external onlyOwner {
        require(newRate > 0, "DolaToken: Invalid new rate");
        exchangeRate = newRate;
        emit PegUpdated(newRate);
    }

}