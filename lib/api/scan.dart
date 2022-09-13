import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ping_discover_network_forked/ping_discover_network_forked.dart';
import 'package:network_info_plus/network_info_plus.dart';

final scanProvider =
    ChangeNotifierProvider.autoDispose<Scan>(((ref) => Scan()));

class Scan extends ChangeNotifier {
  final Set<String> _ips = {};
  Set<String> get ips => _ips;

  Future<bool> scanNetwork(int port) async {
    try {
      final ip = await NetworkInfo().getWifiIP();
      if (ip == null) return false;
      final subnet = ip.substring(0, ip.lastIndexOf('.'));
      final stream = NetworkAnalyzer.discover2(subnet, port,
          timeout: const Duration(seconds: 5));
      await stream.listen((NetworkAddress address) {
        if (address.exists) _ips.add(address.ip);
      }).asFuture();
    } catch (e) {
      // TODO : handle os error 24
    }
    notifyListeners();
    return true;
  }
}
