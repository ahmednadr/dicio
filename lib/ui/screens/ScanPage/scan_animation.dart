import 'package:flutter/material.dart';
import 'package:test/api/scan.dart';
import 'widgets/ring.dart';
import 'widgets/expanding_dot.dart';
import '../../widgets/scale_and_fade.dart';

class ScanAnimation extends StatefulWidget {
  Scan scan;
  ScanAnimation({Key? key, required this.scan}) : super(key: key);

  @override
  State<ScanAnimation> createState() => _ScanAnimationState(scan);
}

class _ScanAnimationState extends State<ScanAnimation>
    with TickerProviderStateMixin {
  Scan scan;
  _ScanAnimationState(this.scan);
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
          child: Ring(diameter: 270),
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
            child: Ring(diameter: 230),
            fadeBothWays: true,
          ),
        ),
      ),
      ExpandingDot(
        onPressed: () {
          _controller.repeat(reverse: true);
          try {
            scan.scanNetwork(8123);
          } on Exception {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content:
                    Text("Make sure you are connected to your home wifi")));
          }
        },
      )
    ]);
  }
}
