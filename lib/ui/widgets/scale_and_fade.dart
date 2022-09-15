import 'package:flutter/material.dart';

class ScaleAndFade extends StatefulWidget {
  Widget child;
  AnimationController controller;
  bool fadeBothWays;
  ScaleAndFade(
      {Key? key,
      required this.child,
      required this.controller,
      this.fadeBothWays = false})
      : super(key: key);

  @override
  State<ScaleAndFade> createState() => _ScaleAndFadeState(
      controller: controller, child: child, fadeBothWays: fadeBothWays);
}

class _ScaleAndFadeState extends State<ScaleAndFade>
    with TickerProviderStateMixin {
  late Widget child;
  late AnimationController controller;
  bool fadeBothWays;
  _ScaleAndFadeState(
      {required this.child,
      required this.controller,
      this.fadeBothWays = false});

  bool opacity = true;

  late final AnimationController _controller = controller
    ..addListener(() {
      if (opacity && _controller.status == AnimationStatus.forward) {
        setState(() {
          opacity = false;
        });
      }
      if (!opacity && _controller.status == AnimationStatus.reverse) {
        setState(() {
          opacity = true;
        });
      }
    });

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
            opacity: opacity
                ? 1
                : fadeBothWays
                    ? 0.4
                    : 0,
            curve: Curves.easeInExpo,
            duration: const Duration(seconds: 1),
            child: ScaleTransition(scale: _animation, child: child)),
      ),
    );
  }
}
