// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.3;

contract Stake {
    mapping(address => uint256) public stakedAmount;

    // stake ETH
    function stake() public payable {
        require(msg.value > 0, "Cannot stake 0 ETH");
        stakedAmount[msg.sender] += msg.value;
    }

    // unstake ETH
    function unstake(uint256 amount) public {
        require(stakedAmount[msg.sender] >= amount, "Not enough staked");

        stakedAmount[msg.sender] -= amount;

        (bool success,) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed");
    }
}
