// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "./RoleManager.sol";

/// @title VaultAccess
/// @notice A role-based vault access system with daily claim limits
contract VaultAccess {
    RoleManager public roleManager;

    mapping(address => uint) public lastAccess;
    uint public constant COOLDOWN = 1 days;

    uint public vaultBalance;

    error Unauthorized();
    error CooldownActive();
    error InsufficientBalance();

    event VaultFunded(address indexed moderator, uint amount);
    event VaultAccessed(address indexed user, uint amount);

    constructor(address _roleManager) {
        roleManager = RoleManager(_roleManager);
    }

    /// @notice Allows MODERATORs to fund the vault
    function fundVault() external payable {
        if (roleManager.getRole(msg.sender) != RoleManager.Role.MODERATOR) revert Unauthorized();

        vaultBalance += msg.value;
        emit VaultFunded(msg.sender, msg.value);
    }

    /// @notice Allows USERs to claim a fixed amount once per day
    function accessVault() external {
        if (roleManager.getRole(msg.sender) != RoleManager.Role.USER) revert Unauthorized();

        if (block.timestamp < lastAccess[msg.sender] + COOLDOWN) revert CooldownActive();

        uint reward = 0.01 ether;
        if (vaultBalance < reward) revert InsufficientBalance();

        lastAccess[msg.sender] = block.timestamp;
        vaultBalance -= reward;

        payable(msg.sender).transfer(reward);
        emit VaultAccessed(msg.sender, reward);
    }

    /// @notice Returns remaining cooldown time before the next access is allowed
    function timeUntilNextAccess(address user) external view returns (uint) {
        uint next = lastAccess[user] + COOLDOWN;
        return block.timestamp >= next ? 0 : next - block.timestamp;
    }

    /// @notice Allows receiving ETH directly to the vault
    receive() external payable {
        vaultBalance += msg.value;
    }
}
