import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test/ui/screens/ScanPage/scan_view_model.dart';
import 'package:test/ui/screens/ScanPage/widgets/expanding_dot.dart';
import 'package:test/ui/screens/ScanPage/widgets/ring.dart';
import 'package:test/ui/widgets/scale_and_fade.dart';

class ScanAnimation extends ConsumerStatefulWidget {
  const ScanAnimation({Key? key, required this.controller}) : super(key: key);

  final AnimationController controller;

  @override
  ConsumerState<ScanAnimation> createState() => _ScanAnimationState();
}

class _ScanAnimationState extends ConsumerState<ScanAnimation> {
  _ScanAnimationState();

  @override
  Widget build(BuildContext context) {
    final _controller = widget.controller;

    return Stack(alignment: AlignmentDirectional.center, children: [
      SizedBox(
        height: 270,
        width: 270,
        child: ScaleAndFade(
          controller: _controller,
          child: const Ring(diameter: 270),
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
            child: const Ring(diameter: 230),
            fadeBothWays: true,
          ),
        ),
      ),
      ExpandingDot(
        onPressed: () {
          _controller.repeat(reverse: true);
          try {
            ref.read(ScanViewModel.scanViewModelProvider.notifier).scan();
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
