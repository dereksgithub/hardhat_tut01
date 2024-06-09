// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract Staking {
    using SafeERC20 for IERC20;

    IERC20 public token;
    uint public rewardRate = 100; // Example reward rate

    struct Stake {
        uint256 amount;
        uint256 startTime;
    }

    mapping(address => Stake) public stakes;

    constructor(IERC20 _token) {
        token = _token;
    }

    function stake(uint256 _amount) public {
        token.safeTransferFrom(msg.sender, address(this), _amount);
        stakes[msg.sender] = Stake(_amount, block.timestamp);
    }

    function unstake() public {
        Stake memory userStake = stakes[msg.sender];
        uint256 duration = block.timestamp - userStake.startTime;
        uint256 reward = (duration * userStake.amount * rewardRate) / (1 days);
        token.safeTransfer(msg.sender, userStake.amount + reward);
        delete stakes[msg.sender];
    }
}
