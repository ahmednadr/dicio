# Server

a server can be accessed by multiple user hence a server model needs to keep a local list of this server’s users, the current active user and settings configured when it comes to sending updates to the server.

## Attributes

### users

list of users on this server.

### activeUser

current active user for this server.

### accessToken

the long-lived token of the current active user.