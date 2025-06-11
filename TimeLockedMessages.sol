// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "./RoleManager.sol";

/// @title TimeLockedMessages
/// @notice Users can submit messages that become readable after a future timestamp
contract TimeLockedMessages {
    RoleManager public roleManager;

    struct Message {
        string content;
        uint unlockTime;
    }

    mapping(address => Message[]) private _messages;

    error Unauthorized();
    error TooEarly();

    event MessageSubmitted(address indexed user, string content, uint unlockTime);

    constructor(address _roleManager) {
        roleManager = RoleManager(_roleManager);
    }

    function submitMessage(string calldata content, uint unlockTime) external {
        if (roleManager.getRole(msg.sender) == RoleManager.Role.NONE) {
            revert Unauthorized();
        }

        _messages[msg.sender].push(Message(content, unlockTime));
        emit MessageSubmitted(msg.sender, content, unlockTime);
    }

    function readMyMessage(uint index) external view returns (string memory) {
        if (index >= _messages[msg.sender].length) revert Unauthorized();

        Message memory msgData = _messages[msg.sender][index];
        if (block.timestamp < msgData.unlockTime) revert TooEarly();

        return msgData.content;
    }

    function readAsAdmin(address user, uint index) external view returns (string memory) {
        if (roleManager.getRole(msg.sender) != RoleManager.Role.ADMIN) {
            revert Unauthorized();
        }

        if (index >= _messages[user].length) revert Unauthorized();
        return _messages[user][index].content;
    }

    function getMyMessageCount() external view returns (uint) {
        return _messages[msg.sender].length;
    }
}
