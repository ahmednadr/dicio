# config and config provider

config is the singular source of multiple basic attributes and are necessary to be available at the start of the app. these attributes are the current active server ip , the active server , port and config class state.

## attributes

### active server ip

the ip of the server where all requests and notifications go to and come from.

### active server

for every server ip there is a server model that contains users and there date along with settings concerning this particular server.

### port

8123 is const for home assistant

### state

```dart
enum CurrentIpState { serverExists, serverDoesntExist, noIp }
```

---

## config provider

a river-pod provider is used to ensure the source of truth singularity. the provider initializes config and notifies listeners whenever changes occur to the config instance.

---

## config interface

### initconfig()

private function that gets called by the provider and is responsible foe retrieving any saved attributes. once the init finishes the config isInit changes to true the indicates that the class is up to date with all the previously saved attributes. the provider notifies listeners of this update in the isInit value so the whole app knows that the config is loaded.

### changeIp(String ip)

change the active ip to the provided ip and checks if there is a saved server model assigned to this ip and loads it to active server.

### checkServer(String ip)

internal method that checks if there is a server model assigned to the provided ip and updates the current state accordingly.

### newServer(String ip, ServerConfig server)

assigns the provided server model to the provided ip and persists this data locally on the device.