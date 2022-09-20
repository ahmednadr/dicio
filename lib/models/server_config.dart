import 'package:test/models/user.dart';

class ServerConfig {
  ServerConfig();

  String? activeUser;
  Map<String?, User>? users;
  //sensors
  String? deviceName;
  //settings

  String? get accessToken {
    return users?[activeUser]?.accessToken;
  }
}
