3.1) Dola Smart Contract

`DolaToken` Smart contract, which is an ERC20 token with additional functionalities related to collateral and minting. Below is a detailed explanation of each section of the code:

### Overview
- **SPDX License Identifier**: Specifies the license for the contract (`MIT`).
- **Pragma Directive**: Specifies the Solidity compiler version (`^0.8.26`), meaning any version from 0.8.26 up to, but not including, 0.9.0 is acceptable.
- **Imports**: The contract imports several modules from OpenZeppelin:
  - `ERC20`: Implements the standard ERC20 token functionality.
  - `Ownable`: Provides basic authorization control functions, simplifying the implementation of user permissions.
  - `ERC20Burnable`: Allows token holders to burn (destroy) their tokens.
  - `SafeERC20`: A library for safely interacting with ERC20 tokens, helping to prevent common pitfalls.
  - `SafeMath`: A library that provides safe arithmetic operations (addition, subtraction, etc.), ensuring overflow/underflow protection.

### Contract Definition
- **Contract Declaration**: `DolaToken` inherits from `ERC20`, `Ownable`, and `ERC20Burnable`.
- **State Variables**:
  - `IERC20 public collateralToken`: The address of the collateral token that the `DolaToken` can mint against.
  - `IERC20 public roiToken`: An optional address for a return on investment (ROI) token, set by the contract owner.
  - `uint256 public exchangeRate`: The rate at which collateral can be exchanged for `DolaToken`. It is initialized to `1e18` (equivalent to 1 in 18 decimal format).

### Events
- The contract emits several events to log important actions:
  - `PegUpdated`: Triggered when the exchange rate is updated.
  - `CollateralDeposited`: Triggered when collateral is deposited to mint `DolaToken`.
  - `CollateralWithdrawn`: Triggered when `DolaToken` is burned and collateral is withdrawn.
  - `ROITokenUpdated`: Triggered when the ROI token address is updated.

### Constructor
- **Constructor**: Initializes the contract with a specified collateral token address. It checks that the address is valid (not zero) and sets the initial exchange rate.

### User Functions
- **mintDola**:
  - Allows users to mint `DolaToken` by depositing a certain amount of collateral.
  - The amount of collateral required is calculated based on the current exchange rate.
  - The function uses `safeTransferFrom` from the `SafeERC20` library to transfer the collateral from the user to the contract and mints the equivalent amount of `DolaToken`.
  - Emits the `CollateralDeposited` event.

- **burnDola**:
  - Allows users to burn `DolaToken` to withdraw the equivalent amount of collateral.
  - It checks that the user has a sufficient balance of `DolaToken` before proceeding.
  - The collateral amount to be transferred back is calculated similarly to `mintDola`.
  - Emits the `CollateralWithdrawn` event.

### Transfer Functions
- **transfer**: Overrides the default `transfer` function from `ERC20`, allowing users to transfer tokens. It uses the inherited implementation from `ERC20`.
- **transferFrom**: Overrides the default `transferFrom` function from `ERC20`, enabling transfers of tokens on behalf of another account. It also uses the inherited implementation.

### Owner Functions
- **setRoiToken**:
  - Allows the contract owner to set the address of the ROI token.
  - Ensures that the new address is valid (not zero) and emits the `ROITokenUpdated` event.

- **updatePeg**:
  - Allows the contract owner to update the exchange rate for minting and burning.
  - Validates that the new rate is greater than zero and emits the `PegUpdated` event.

### Summary
The `DolaToken` contract implements a collateralized token model where users can mint and burn tokens against a specific collateral token. It provides essential functions for minting, burning, and transferring tokens while allowing the owner to manage critical parameters like the exchange rate and ROI token. The use of OpenZeppelin's libraries ensures a secure and reliable implementation of ERC20 token standards.


3.2) `WrappedEMPRESSToken` smart contract, which implements a wrapper for a native token, allowing users to mint and burn wrapped tokens. Here's a detailed breakdown of the code:

### Overview
- **SPDX License Identifier**: The contract is licensed under the MIT License.
- **Pragma Directive**: Specifies that the code is written for Solidity version `^0.8.26`, which means it is compatible with versions from 0.8.26 up to, but not including, 0.9.0.
- **Imports**: The contract imports several components from the OpenZeppelin library:
  - `ERC20`: Implements the ERC20 token standard.
  - `Ownable`: Provides ownership control functions to manage permissions.
  - `SafeERC20`: A utility library for safe interactions with ERC20 tokens.
  - `SafeMath`: A library for safe arithmetic operations to prevent overflow and underflow.

### Contract Definition
- **Contract Declaration**: The contract `WrappedEMPRESSToken` inherits from `ERC20` and `Ownable`, meaning it has token functionalities and ownership control.
  
- **State Variables**:
  - `IERC20 public nativeToken`: Stores the address of the native token that is being wrapped.

### Events
The contract defines two events:
- `Wrapped`: Emitted when a user wraps a certain amount of the native token into wrapped tokens.
- `Unwrapped`: Emitted when a user unwraps a certain amount of wrapped tokens back into the native token.

### Constructor
- **Constructor**: Initializes the contract with the address of the native token. It checks that the provided address is valid (not zero) and sets the `nativeToken` state variable. The contract's name and symbol are also set as "Wrapped EMP" and "WEMP", respectively.

### User Functions
- **wrap**:
  - Allows users to convert a specified amount of the native token into wrapped tokens (WEMP).
  - Checks that the amount is greater than zero and that the user has a sufficient balance of the native token.
  - Transfers the native token from the user to the contract using `safeTransferFrom` to prevent issues such as failed transfers.
  - Mints the equivalent amount of wrapped tokens to the user using the inherited `_mint` function from ERC20.
  - Emits the `Wrapped` event to log the transaction.

- **unwrap**:
  - Allows users to convert a specified amount of wrapped tokens back into the native token.
  - Checks that the amount is greater than zero and that the user has a sufficient balance of wrapped tokens.
  - Burns the wrapped tokens using the inherited `_burn` function from ERC20.
  - Transfers the equivalent amount of native tokens back to the user using `safeTransfer`.
  - Emits the `Unwrapped` event to log the transaction.

### View Functions
- **getNativeTokenAddress**: A simple view function that returns the address of the native token being wrapped. This function can be called externally to get the address without modifying the state.

### Summary
The `WrappedEMPRESSToken` contract provides a straightforward implementation of a wrapped token model. Users can wrap (mint) and unwrap (burn) their native tokens, converting them to and from the wrapped version (WEMP). The contract employs best practices for token transfer using OpenZeppelin's safe libraries, ensuring secure handling of token balances and state changes. The owner of the contract can manage the native token address and ensures that all operations are validated to prevent errors and unexpected behavior.
