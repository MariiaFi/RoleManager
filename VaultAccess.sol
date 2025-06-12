// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "./RoleManager.sol";

/// @title VaultAccess
/// @notice Контракт ограниченного доступа к "сундуку" раз в сутки для USER и управления пополнением MODERATOR
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

    /// @notice MODERATOR может пополнить контракт
    function fundVault() external payable {
        if (roleManager.getRole(msg.sender) != RoleManager.Role.MODERATOR) revert Unauthorized();

        vaultBalance += msg.value;
        emit VaultFunded(msg.sender, msg.value);
    }

    /// @notice USER может получить доступ к фиксированной сумме раз в сутки
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

    /// @notice Только для просмотра — сколько осталось до следующего доступа
    function timeUntilNextAccess(address user) external view returns (uint) {
        uint next = lastAccess[user] + COOLDOWN;
        return block.timestamp >= next ? 0 : next - block.timestamp;
    }

    receive() external payable {
        vaultBalance += msg.value;
    }
}
