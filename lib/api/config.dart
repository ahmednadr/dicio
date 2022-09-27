import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test/api/constants/hive_boxes_keys.dart';
import 'package:test/models/server.dart';
import 'package:test/models/server_state.dart';

final configProvider = ChangeNotifierProvider<Config>(((ref) {
  ref.onDispose(() {
    if (Hive.isBoxOpen(configBox)) {
      Hive.box(configBox).close();
    }
  });
  final config = Config();
  config.initConfig();
  return config;
}));

enum CurrentIpState { serverExists, serverDoesntExist, noIp }

class Config extends ChangeNotifier {
  late String _activeIp;
  final port = "8123";
  late ServerConfig _activeServer;
  late CurrentIpState _configState;
  bool isInit = false;

  bool get ipSet => _activeIp != '';

  CurrentIpState get configState => _configState;

  String get activeIp => _configState != CurrentIpState.noIp
      ? _activeIp
      : throw Exception("no ip obtained");

  ServerConfig get activeServer => _configState == CurrentIpState.serverExists
      ? _activeServer
      : throw Exception("no server obtained");

  String get activeExternalUrl => _configState == CurrentIpState.serverExists
      ? _activeServer.state == ServerState.external
          ? _activeServer.externalUrl!
          : _activeIp
      : throw Exception("no server obtained");

  String? get accessToken {
    return _configState == CurrentIpState.serverExists
        ? _activeServer.accessToken
        : throw Exception("no server obtained");
  }

  Future<void> initConfig() async {
    final box = await Hive.openBox<ServerConfig?>(configBox);
    if (!box.containsKey(activeServerKey)) {
      _configState = CurrentIpState.noIp;
      isInit = true;
      notifyListeners();
      return;
    }
    _activeIp = box.get(activeServerKey)!.ip;
    await checkServer(_activeIp);
    isInit = true;
    notifyListeners();
  }

  Future<void> changeIp(String ip) async {
    final box = await Hive.openBox<ServerConfig?>(configBox);
    var newserver = box.get(ip);
    await box.put(activeServerKey, newserver);
    _activeIp = ip;
    await checkServer(ip);
    notifyListeners();
  }

  Future<void> newServer(String ip, ServerConfig server) async {
    final box = await Hive.openBox<ServerConfig?>(configBox);
    await box.put(ip, server);
    _configState == CurrentIpState.serverExists;
    notifyListeners();
  }

  Future<void> checkServer(ip) async {
    final box = await Hive.openBox<ServerConfig?>(configBox);

    if (box.containsKey(ip) && box.get(ip) != null) {
      _activeServer = box.get(ip)!;
      _configState = CurrentIpState.serverExists;
    } else {
      _configState = CurrentIpState.serverDoesntExist;
    }
  }
}
