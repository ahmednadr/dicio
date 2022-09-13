import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io' show Platform;

import 'package:dio/dio.dart';

//TODO: varibale appname and version in the register data in _get_model function

Future<Map<String, dynamic>> _get_model(String DeviceName) async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  var data;

  if (Platform.isAndroid) {
    var device = await deviceInfo.androidInfo;
    data = {
      "device_id": DeviceName,
      "app_id": "awesome_home",
      "app_name": "Awesome Home",
      "app_version": "1.2.0",
      "device_name": DeviceName,
      "manufacturer": device.brand,
      "model": device.model,
      "os_name": "android",
      "supports_encryption": false,
      "app_data": {"push_notification_key": "abcdef"}
    };
  } else if (Platform.isIOS) {
    var device = await deviceInfo.iosInfo;
    data = {
      "device_id": DeviceName,
      "app_id": "awesome_home",
      "app_name": "Awesome Home",
      "app_version": "1.2.0",
      "device_name": DeviceName,
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

Future<String> Register(
    String IPaddress, String DeviceName, String token) async {
  var data = await _get_model(DeviceName);
  var address = "http://$IPaddress/api/mobile_app/registrations";
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
