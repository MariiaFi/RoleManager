// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "./RoleManager.sol";

/// @title SecureNotes
/// @notice Contract for storing personal notes with access control
/// @dev Reads user roles from external RoleManager contract
contract SecureNotes {
    /// Reference to RoleManager for access control
    RoleManager public roleManager;

    /// Stores notes per user address
    mapping(address => string[]) private _notes;

    /// Error when caller is unauthorized to perform the action
    error Unauthorized();

    /// Error when trying to delete a note that doesn’t exist
    error NoteNotFound();

    /// Emitted when a new note is created
    event NoteCreated(address indexed user, string content);

    /// Emitted when a note is deleted
    event NoteDeleted(address indexed user, uint index);

    /// @param _roleManager Address of deployed RoleManager contract
    constructor(address _roleManager) {
        roleManager = RoleManager(_roleManager);
    }

    /// @notice Allows USER, MODERATOR, or ADMIN to create a personal note
    /// @param content The content of the note
    function createNote(string calldata content) external {
        RoleManager.Role role = roleManager.getRole(msg.sender);
        if (role == RoleManager.Role.NONE) revert Unauthorized();

        _notes[msg.sender].push(content);
        emit NoteCreated(msg.sender, content);
    }

    /// @notice Returns all notes created by the caller
    /// @return Array of notes
    function getMyNotes() external view returns (string[] memory) {
        return _notes[msg.sender];
    }

    /// @notice Allows MODERATOR or ADMIN to delete any user’s note by index
    /// @param user The user whose note should be deleted
    /// @param index Index of the note in user's list
    function deleteNote(address user, uint index) external {
        RoleManager.Role role = roleManager.getRole(msg.sender);
        if (role != RoleManager.Role.ADMIN && role != RoleManager.Role.MODERATOR) {
            revert Unauthorized();
        }

        if (index >= _notes[user].length) revert NoteNotFound();

        // Replace the note at index with the last one and pop
        _notes[user][index] = _notes[user][_notes[user].length - 1];
        _notes[user].pop();

        emit NoteDeleted(user, index);
    }
}
