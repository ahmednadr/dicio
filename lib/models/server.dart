import 'package:test/models/user.dart';
import 'package:hive/hive.dart';
import 'server_state.dart';
import 'active_user_state.dart';

part 'server.g.dart';

@HiveType(typeId: 0)
class ServerConfig {
  @HiveField(0)
  late Map<String, User> users;
  @HiveField(1)
  late ServerState state;
  @HiveField(2)
  late ActiveServerAuth userState;
  @HiveField(3)
  late String? activeUser;
  //sensors
  @HiveField(4)
  String? deviceName;
  @HiveField(5)
  String? externalUrl;
  @HiveField(6)
  late String ip;
  //settings

  ServerConfig(this.ip, this.activeUser) {
    users = {};
    state = ServerState.local;
  }

  ServerConfig addUser(User u) {
    // due to hive serialization you cant use a non hivefield in the constructor
    // thats why cant add first user throught constructor
    users.putIfAbsent(activeUser!, () => u);
    userState = ActiveServerAuth.authorized;
    return this;
  }

  String? get accessToken {
    return users[activeUser]?.longToken;
  }
}
