// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Reward is Ownable(address(0)) {
    IERC20 public token;

    mapping(address => uint256) public rewards;

    constructor(IERC20 _token) {
        token = _token;
    }

    function recordAction(address _user, uint256 _reward) public onlyOwner {
        rewards[_user] += _reward;
    }

    function claimReward() public {
        uint256 reward = rewards[msg.sender];
        require(reward > 0, "No rewards available");
        rewards[msg.sender] = 0;
        token.transfer(msg.sender, reward);
    }
}
