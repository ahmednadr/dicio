import 'dart:async';
import 'package:flutter/material.dart';

class BouncingBall extends StatefulWidget {
  @override
  State<BouncingBall> createState() => _BouncingBallState();
}

class _BouncingBallState extends State<BouncingBall>
    with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      lowerBound: 0,
      upperBound: 100,
    );

    controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: controller.value),
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
              colors: [Color(0xfff58228), Color(0xffd82258)],
              begin: AlignmentDirectional.topCenter,
              end: AlignmentDirectional.bottomCenter),
        ),
        width: 150.0,
        height: 150.0,
      ),
    );
  }
}
