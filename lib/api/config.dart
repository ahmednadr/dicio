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
  CurrentIpState _configState = CurrentIpState.noIp;

  final _isInitedController = StreamController<bool>.broadcast();

  Stream<bool> get isInitedStream =>
      _isInitedController.stream.asBroadcastStream();
  bool isInit = false;
  CurrentIpState get configState => _configState;
  String get activeIp => _activeIp;
  String get token => _token;

  Future<CurrentIpState> initConfig() async {
    _isInitedController.add(false);
    final box = await Hive.openBox(configBox);
    if (!box.containsKey(activeIpKey) || await box.get(activeIpKey) == '') {
      _configState = CurrentIpState.noIp;
      return configState;
    }
    _activeIp = await box.get(activeIpKey);
    _isInitedController.add(true);
    isInit = true;
    return await checkToken(_activeIp);
  }

  Future<void> setToken(String ip, String token) async {
    final box = await Hive.openBox(configBox);
    await box.put(ip, token);
    notifyListeners();
  }

  Future<CurrentIpState> changeIp(String ip) async {
    final box = await Hive.openBox(configBox);
    await box.put(activeIpKey, ip);
    _activeIp = ip;
    notifyListeners();
    return checkToken(ip);
  }

  Future<CurrentIpState> checkToken(ip) async {
    final box = await Hive.openBox(configBox);

    if (box.containsKey(ip)) {
      _token = box.get(ip);
      _configState = CurrentIpState.authorized;
    } else {
      _configState = CurrentIpState.notAuthorized;
    }
    return configState;
  }
}
