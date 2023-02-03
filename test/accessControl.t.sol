// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/QuillTask.sol";

contract AccessTest is Test {
    QuillTest public quillTest;
    uint256 mainnetFork;
    string MAINNET_RPC_URL = vm.envString("URL");

    function setUp() public {
        mainnetFork = vm.createSelectFork(MAINNET_RPC_URL);
        quillTest = new QuillTest();
        // Enabling the blacklisting
        quillTest.setBlackListEnabled(true);
    }

    function testAccessFailForTransfer() public {
        vm.expectRevert("Account is in blacklist");
        // Owner of the contract tries to send token to the contract:
        // Reverts despite Owner/contract not being in the blacklisted array
        quillTest.transfer(address(quillTest), 5000);
    }
}
