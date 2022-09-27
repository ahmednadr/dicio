import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test/api/config.dart';
import 'package:test/models/server.dart';
import 'package:test/api/constants/hive_boxes_keys.dart';
import 'package:hive/hive.dart';
import 'package:test/models/active_user_state.dart';

final SettingsProvider = Provider<SettingsViewModel>((ref) {
  return SettingsViewModel(ref.read(configProvider));
});

class SettingsViewModel {
  late Config _config;
  SettingsViewModel(this._config);

  Future<Map<String, ServerConfig>> serversList() async {
    var box = await Hive.openBox<ServerConfig?>(configBox);
    Map<String, ServerConfig> map = Map<String, ServerConfig>.from(box.toMap());
    return map;
  }

  ServerConfig get activeServer => _config.activeServer;

  void logout() {
    _config.activeServer.activeUser = null;
    _config.activeServer.userState = ActiveServerAuth.notAuthorised;
  }
}
