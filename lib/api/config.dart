import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test/api/constants/hive_configs.dart';

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

enum CurrentIpState { notAuthorized, authorized, noIp }

class Config extends ChangeNotifier {
  String _activeIp = "";
  final port = "8123";
  String _token = "";
  late CurrentIpState _configState;
  bool isInit = false;
  CurrentIpState get configState => _configState;
  String get activeIp => _activeIp;
  String get token => _token;

  Future<void> initConfig() async {
    final box = await Hive.openBox(configBox);
    if (!box.containsKey(activeIpKey) || await box.get(activeIpKey) == '') {
      _configState = CurrentIpState.noIp;
      isInit = true;
      notifyListeners();
      return;
    }
    _activeIp = await box.get(activeIpKey);
    isInit = true;

    await checkToken(_activeIp);
    notifyListeners();
  }

  Future<void> setToken(String ip, String token) async {
    final box = await Hive.openBox(configBox);
    await box.put(ip, token);
    notifyListeners();
  }

  Future<void> changeIp(String ip) async {
    final box = await Hive.openBox(configBox);
    await box.put(activeIpKey, ip);
    _activeIp = ip;
    await checkToken(ip);
    notifyListeners();
  }

  Future<void> checkToken(ip) async {
    final box = await Hive.openBox(configBox);

    if (box.containsKey(ip)) {
      _token = box.get(ip);
      _configState = CurrentIpState.authorized;
    } else {
      _configState = CurrentIpState.notAuthorized;
    }
  }
}
