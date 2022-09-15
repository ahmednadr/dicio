import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io' show Platform;
import 'constants/app_version.dart';
import 'package:dio/dio.dart';

//TODO: varibale appname and version in the register data in _get_model function

Future<Map<String, dynamic>> _getModel(String deviceName) async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  var data;

  if (Platform.isAndroid) {
    var device = await deviceInfo.androidInfo;
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
      "app_data": {"push_notification_key": "abcdef"}
    };
  } else if (Platform.isIOS) {
    var device = await deviceInfo.iosInfo;
    data = {
      "device_id": deviceName,
      "app_id": appName,
      "app_name": appVersion,
      "app_version": appVersion,
      "device_name": deviceName,
      "manufacturer": "apple.inc",
      "model": device.model,
      "os_name": "ios",
      "os_version": device.systemVersion,
      "supports_encryption": false,
      "app_data": {"push_notification_key": "abcdef"}
    };
  }

  return data;
}

Future<String> register(
    String ipAddress, String deviceName, String token) async {
  var data = await _getModel(deviceName);
  var address = "http://$ipAddress/api/mobile_app/registrations";
  var headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };
  BaseOptions options = BaseOptions(
    headers: headers,
    connectTimeout: 6000,
    receiveTimeout: 3000,
  );
  Dio dio = Dio(options);
  Response r = await dio.post(address, data: jsonEncode(data));
  return r.data.toString();
}
