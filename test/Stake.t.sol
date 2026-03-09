// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.3;

import "forge-std/Test.sol";
import "../src/Stake.sol";

contract StakeTest is Test {
    Stake stake;


    function setUp() public{
        stake = new Stake();
    }

    function test_staking_success() public{
        vm.startPrank(msg.sender);
        vm.deal(msg.sender, 1 ether); // top up with 1 ether
        stake.stake{value: 1 ether}();
        assertEq(stake.stakedAmount(msg.sender), 1 ether);
        vm.stopPrank();
    }

    function test_staking_fail() public{
        vm.expectRevert();
        stake.stake();
    }

    function test_multiple_staking() public{
        address user1 = 0xd71831677771513BB19B640A96C6692A89159A1e;
        vm.startPrank(user1);
        vm.deal(user1, 1 ether); // top up with 1 ether
        stake.stake{value: 1 ether}();
        assertEq(stake.stakedAmount(user1), 1 ether);
        vm.stopPrank();

        address user2 = 0x79B7d6027432ecD809921C41270876A0A9b68435;
        vm.startPrank(user2);
        vm.deal(user2, 1 ether); // top up with 1 ether
        stake.stake{value: 1 ether}();
        assertEq(stake.stakedAmount(user2), 1 ether);
        vm.stopPrank();

        address user3 = 0x340c403AbEDd84971EF90a77004337582c073e6a;
        vm.startPrank(user3);
        vm.deal(user3, 1 ether); // top up with 1 ether
        stake.stake{value: 1 ether}();
        assertEq(stake.stakedAmount(user3), 1 ether);
        vm.stopPrank();

        assertEq(address(stake).balance,3 ether);
    }

    function test_unstaking() public {
        address user1 = 0x79B7d6027432ecD809921C41270876A0A9b68435;
        vm.startPrank(user1);
        vm.deal(user1, 1 ether); // top up with 1 ether
        stake.stake{value: 1 ether}();
        assertEq(stake.stakedAmount(user1), 1 ether);
        //now unstake
        stake.unstake(0.5 ether);
        assertEq(stake.stakedAmount(user1), 0.5 ether);
        stake.unstake(0.5 ether);
        assertEq(stake.stakedAmount(user1), 0 ether);

        vm.stopPrank();
    }


    function test_unstaking_extra() public {
        address user1 = 0x79B7d6027432ecD809921C41270876A0A9b68435;
        vm.startPrank(user1);
        vm.deal(user1, 1 ether); // top up with 1 ether
        stake.stake{value: 1 ether}();
        assertEq(stake.stakedAmount(user1), 1 ether);
        //now unstake
        stake.unstake(0.5 ether);
        assertEq(stake.stakedAmount(user1), 0.5 ether);
        vm.expectRevert();
        stake.unstake(2 ether);

        vm.stopPrank();
    }

    function testFuzz_staking(uint256 amount) public {
        // bound the amount to reasonable ETH values so we don't overflow total supply
        vm.assume(amount > 0 && amount < 100_000 ether); 
        vm.startPrank(msg.sender);
        vm.deal(msg.sender, amount);
        stake.stake{value: amount}();
        assertEq(stake.stakedAmount(msg.sender), amount);
        vm.stopPrank();
    }

    function test_user_balance_changes() public {
    address user1 = 0x79B7d6027432ecD809921C41270876A0A9b68435;
    vm.deal(user1, 10 ether);
    
    vm.startPrank(user1);
    
    uint256 preStakeBalance = user1.balance;
    stake.stake{value: 2 ether}();
    
    // Check that user actually paid the 2 eth
    assertEq(user1.balance, preStakeBalance - 2 ether);
    
    stake.unstake(1 ether);
    // Check that user got 1 eth back
    assertEq(user1.balance, preStakeBalance - 1 ether);
    
    vm.stopPrank();
}




}
