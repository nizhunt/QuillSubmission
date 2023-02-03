// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../QuillTask.sol";

contract ExpensiveToken is ERC20 {
    constructor() ERC20("ExpensiveToken", "Exp") {}

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}

contract CheapToken is ERC20 {
    constructor() ERC20("CheapToken", "p") {}

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}
