// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title RoleManager
/// @notice Simple Role-Based Access Control contract (RBAC) without using OpenZeppelin
/// @dev Uses enum, custom errors, and basic modifiers for access control

contract RoleManager {
    /// List of available roles
    enum Role { NONE, USER, MODERATOR, ADMIN }

    /// Stores the assigned role for each address
    mapping(address => Role) private _roles;

    /// Error: only ADMIN can call this function
    error OnlyAdmin();

    /// Error: cannot assign an invalid role like NONE
    error InvalidRole();

    /// Event: triggered when a role is assigned
    event RoleAssigned(address indexed user, Role newRole);

    /// Event: triggered when a role is revoked (set to NONE)
    event RoleRevoked(address indexed user);

    /// @notice Contract deployer becomes the first ADMIN
    constructor() {
        _roles[msg.sender] = Role.ADMIN;
        emit RoleAssigned(msg.sender, Role.ADMIN);
    }

    /// @dev Restricts function to ADMIN only
    modifier onlyAdmin() {
        if (_roles[msg.sender] != Role.ADMIN) revert OnlyAdmin();
        _;
    }

    /// @notice Assign a role to a user
    /// @param user The address to assign the role to
    /// @param newRole The role to assign (must not be NONE)
    function assignRole(address user, Role newRole) external onlyAdmin {
        if (newRole == Role.NONE) revert InvalidRole();
        _roles[user] = newRole;
        emit RoleAssigned(user, newRole);
    }

    /// @notice Revoke a user's role (sets it to NONE)
    /// @param user The address whose role will be removed
    function revokeRole(address user) external onlyAdmin {
        _roles[user] = Role.NONE;
        emit RoleRevoked(user);
    }

    /// @notice Get the role of any user
    /// @param user The address to check
    /// @return The current role of the user
    function getRole(address user) external view returns (Role) {
        return _roles[user];
    }

    /// @notice Check if a user is an ADMIN
    /// @param user The address to check
    /// @return True if the user is an ADMIN, false otherwise
    function isAdmin(address user) external view returns (bool) {
        return _roles[user] == Role.ADMIN;
    }

    /// @notice Check if a user is a MODERATOR
    /// @param user The address to check
    /// @return True if the user is a MODERATOR, false otherwise
    function isModerator(address user) external view returns (bool) {
        return _roles[user] == Role.MODERATOR;
    }

    /// @notice Get your own role (useful for front-end)
    /// @return The role of the caller
    function myRole() external view returns (Role) {
        return _roles[msg.sender];
    }
}
