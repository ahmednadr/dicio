import 'package:test/models/user.dart';

class ServerConfig {
  late Map<String, User> users;

  ServerConfig(this.activeUser, User active) {
    users.putIfAbsent(activeUser, () => active);
  }

  late String activeUser;

  //sensors
  String? deviceName;
  //settings

  String? get accessToken {
    return users[activeUser]?.accessToken;
  }
}
