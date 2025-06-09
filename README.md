# RoleManager.sol

Custom Role-Based Access Control (RBAC) smart contract written in Solidity 0.8.30 without relying on OpenZeppelin.

This contract defines a basic role management system with three access levels: `ADMIN`, `MODERATOR`, and `USER`. It uses `enum`, `custom errors`, and `events` for clear access logic and gas-efficient execution.

---

## Features

- Custom roles: `NONE`, `USER`, `MODERATOR`, `ADMIN`
- Role assignment and revocation by admins
- Uses `enum` and `custom error` for better readability and gas optimization
- Emits events on role changes
- Includes `onlyAdmin` modifier for access-restricted functions

---

## Solidity Version

```solidity
pragma solidity ^0.8.30;
```
## Contract Interface
```
function assignRole(address user, Role newRole) external onlyAdmin;
function revokeRole(address user) external onlyAdmin;
function getRole(address user) external view returns (Role);
function isAdmin(address user) external view returns (bool);
function isModerator(address user) external view returns (bool);
function myRole() external view returns (Role);
```
## Future Improvements
- Add per-function permissions
- Add dynamic permission groups
- Integration with frontend (React/Next.js dApp)
- Deploy to Sepolia or Base testnet

Author
Mariia Fialkovska - Junior Solidity Developer 
[LinkedIn Profile](https://www.linkedin.com/in/mariia-fialkovska-78857b234/)
Part of the #100DaysOfSolidity challenge.
