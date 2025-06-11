# Solidity Access Control Suite

A three-contract project written in Solidity 0.8.30 that demonstrates how to implement a custom role-based access control system and use it to secure a decentralized notes application.

---

## Contracts Overview

### RoleManager.sol

A lightweight role management system with the following features:

- Roles: `NONE`, `USER`, `MODERATOR`, `ADMIN`
- `assignRole(address, Role)` – Assign role (admin-only)
- `revokeRole(address)` – Remove role (admin-only)
- `myRole()` – Get caller's current role
- Custom errors and event logs

### SecureNotes.sol

A secure note-taking contract with role-based permissions:

- Requires role `USER` or higher to create a note
- Users can read their own notes
- Only `MODERATOR` or `ADMIN` can delete notes of any user
- Reads roles from the external `RoleManager` contract

### TimeLockedMessages.sol

A smart contract that allows users to submit messages with an unlock timestamp.

- `USER` and higher roles can submit messages
- Messages are hidden until `unlockTime`
- `ADMIN` can read any message immediately
- Demonstrates use of `block.timestamp` and role-based access in combination

---

##  How to Use in Remix

1. **Deploy `RoleManager.sol`**
   - You become `ADMIN` automatically

2. **Deploy `SecureNotes.sol`**
   - Paste the address of the deployed `RoleManager` into the constructor

3. **Assign roles**
   - Call `assignRole(address, 1)` to make someone a `USER`

4. **Create & manage notes**
   - Use `createNote("Your text here")` to store notes
   - Use `getMyNotes()` to view
   - `deleteNote(address, index)` (for mods/admins only)

5. **Deploy `TimeLockedMessages.sol`**
   - Provide the same `RoleManager` address in the constructor

6. **Submit a time-locked message**
   - Use `submitMessage("Secret", futureTimestamp)` with a future `unlockTime`

7. **Read messages**
   - `readMyMessage(index)` – works only after unlock time
   - `readAsAdmin(user, index)` – bypasses time (admin-only)


---

## Roles

| Role       | Numeric | Permissions             |
|------------|---------|-------------------------|
| NONE       | 0       | No access               |
|------------|---------|-------------------------|
| USER       | 1       | Can create/read notes,  |
|            |         |  submit time-locked     |
|            |         |  messages               |
|------------|---------|-------------------------|
| MODERATOR  | 2       | Can delete any notes    |
|------------|---------|-------------------------|
| ADMIN      | 3       | Full access + read      |
|            |         |  locked messages +      |
|            |         | manage roles            |  

---

## Author

**Mariia Fialkovska**  
Solidity Developer — [LinkedIn](https://www.linkedin.com/in/mariia-fialkovska-78857b234/)  

---

## License

MIT
