import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test/api/scan.dart';
import 'scan_animation.dart';
import 'list_servers.dart';

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
    Widget _child = ScanAnimation(scan: scan);

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