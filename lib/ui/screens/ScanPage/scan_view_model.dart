import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test/api/config.dart';
import 'package:test/api/scan.dart';
import 'package:test/ui/screens/ScanPage/scan_states.dart';

class ScanViewModel extends StateNotifier<ScanStates> {
  ScanViewModel(
      {required this.scanController, required this.config, required startState})
      : super(startState);

  final Scan scanController;
  final Config config;

  static final scanViewModelProvider =
      StateNotifierProvider<ScanViewModel, ScanStates>((ref) {
    final scanFunctions = ref.read(scanProvider);
    final config = ref.watch(configProvider);
    late final ScanStates startState;

    !config.isInit
        ? startState = ScanStates.init
        : startState = ScanStates.idle;

    return ScanViewModel(
        scanController: scanFunctions, config: config, startState: startState);
  });

  Future<void> scan() async {
    state = ScanStates.scanning;

    final result = await scanController.scanNetwork(8123);

    if (!result) {
      state = ScanStates.error;
      return;
    }

    if (scanController.ips.isEmpty) {
      state = ScanStates.timeout;
      return;
    }

    state = ScanStates.finished;
  }

  void handleError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Make sure you are connected to your home wifi")));
    state = ScanStates.idle;
  }
}
