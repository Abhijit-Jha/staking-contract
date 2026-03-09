// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.3;

import "forge-std/Test.sol";
import "../src/Stake.sol";

contract StakeTest is Test {
    Stake stake;


    function setup() public{
        stake = new Stake();
    }

    function test_staking() public{
        
    }
}
