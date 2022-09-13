import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test/api/scan.dart';
import 'Ring.dart';
import 'Expanding dot.dart';
import 'ScaleAndFade.dart';

class scanAnimation extends StatefulWidget {
  Scan scan;
  scanAnimation({Key? key, required this.scan}) : super(key: key);

  @override
  State<scanAnimation> createState() => _scanAnimationState(scan);
}

class _scanAnimationState extends State<scanAnimation>
    with TickerProviderStateMixin {
  Scan scan;
  _scanAnimationState(this.scan);
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..stop();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: AlignmentDirectional.center, children: [
      SizedBox(
        height: 270,
        width: 270,
        child: ScaleAndFade(
          controller: _controller,
          child: ring(diameter: 270),
          fadeBothWays: false,
        ),
      ),
      ClipRRect(
        borderRadius: BorderRadius.circular(150),
        child: SizedBox(
          height: 230,
          width: 230,
          child: ScaleAndFade(
            controller: _controller,
            child: ring(diameter: 230),
            fadeBothWays: true,
          ),
        ),
      ),
      Expanding_dot(controller: _controller, scan: scan)
    ]);
  }
}
