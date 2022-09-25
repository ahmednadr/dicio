# Registration function

## register( String ipAddress , String Name , String token)

a function that registers the current device under the provided in the mobile app module of home-assistant.

the home-assistant is identified using the provided server ip and authenticated using provided the long-lived token.

## _getModel(String deviceName)

fetches device data like os type and version, device model and manufacturer then composes the registration post request’s body with the deviceName embedded in.

```json
data = {
      "device_id": deviceName,
      "app_id": appName,
      "app_name": appName,
      "app_version": appVersion,
      "device_name": deviceName,
      "manufacturer": device.brand,
      "model": device.model,
      "os_name": "android",
      "supports_encryption": false,
      "app_data": 
					{"push_notification_key": "abcdef"}
    }
```