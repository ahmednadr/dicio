import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test/api/config.dart';
import 'package:test/api/scan.dart';
import 'package:test/ui/widgets/bouncing_ball.dart';
import 'scan_animation.dart';
import 'widgets/list_servers.dart';

class ScanPage extends ConsumerStatefulWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends ConsumerState<ScanPage> {
  bool first = true;

  @override
  Widget build(BuildContext context) {
    final scan = ref.watch(scanProvider);
    final config = ref.watch(configProvider);
    Widget _child = const BouncingBall();

    if (config.isInit) {
      _child = ScanAnimation(scan: scan);
    }

    if (scan.ips.isNotEmpty) {
      setState(() {
        _child = ListServers(ips: scan.ips);
      });
    }

    return Scaffold(
      body: Center(
          child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              switchInCurve: Curves.easeOutBack,
              switchOutCurve: Curves.easeOutBack,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: _child)),
    );
  }
}
