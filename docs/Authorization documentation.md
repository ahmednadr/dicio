# Authorization

the process to authenticate over home assistant involves multiple tokens that must be acquired before a long-lived token can be fetched.

All the token fetching methods are implemented in lib/api/auth.dart. To authenticate and get a long-lived token initialise an auth instance using the ip and port of the home assistant server then call the authenticate method that takes username and password as parameters.

```dart
var a = auth("192.168.1.24","8123");
var token = a.authenticate("username","password");
```

## The behind the scenes

Diving deeper to the login process and the tokens needed to get a long-lived token.

### login session token known as flow_id

This token is passed along with the username and password to login in into the home assistant server. To acquire this token a post request is sent to address/auth/login_flow with data 

```json
{"client_id":"http://acs",
"handler":["homeassistant",null], 
"redirect_uri":"http://acs/?auth_callback=1"}
```

Note: Client_id and redirect_uri can be anything. 

The response to this request contains in its body.

### Auth_token

auth token is the user’s token obtained once the user is verified and authenticated. To fetch such token, a post request to the address address/auth/login_flow/flow_id with the username and password in the data is sent 

```json
{"username": "acs",
"password": "Dcs5020-",
"client_id": "http://acs"}
```

Note: client_id must be identical to the one use to obtain the flow_id

If the authentication was successful the response body would contain an auth token.

To obtain a long-lived token we have to connect to the websocket api. To do this we will need an access token which can be easily fetched using the auth token obtained earlier.

### Access_token

send a post request to address/auth/token with data body 

```
grant_type=authorization_code&code=${auth_token}&client_id=http://acs
```

and content-type header set to 'application/x-www-form-urlencoded’

the response body would contain an access token to be used to connect over the websocket api.

### Long-lived token

the long-lived token is available via a call over the websockt api. 

Steps to get the token:

1. connect to the websocket over 

```
ws://$ip:$port/api/websocket
```

1. authenticate the connection via the access_token obtained earlier 

```json
{"type": "auth", "access_token": "${access_token}"}
```

1. provide this api call to get the long-lived token 

```json
{
        "id": "11",
        "type": "auth/long_lived_access_token",
        "client_name": "ACS",
        "client_icon": "null",
        "lifespan": 365
}
```

Note : one element of Client_name may only be linked to one long-lived token , and vice versa.