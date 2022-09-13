import 'package:flutter/material.dart';
import 'package:test/api/scan.dart';

class Expanding_dot extends StatefulWidget {
  AnimationController controller;
  Scan scan;
  Expanding_dot({Key? key, required this.controller, required this.scan})
      : super(key: key);

  @override
  State<Expanding_dot> createState() =>
      _Expanding_dotState(controller: controller, scan: scan);
}

class _Expanding_dotState extends State<Expanding_dot> {
  double end = 1;
  AnimationController controller;
  Scan scan;
  _Expanding_dotState({required this.controller, required this.scan});
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutBack,
        tween: Tween<double>(begin: 0, end: end),
        builder: (context, double factor, _) {
          return InkWell(
              onTap: () {
                setState(() {
                  end = 0.9;
                  controller.repeat(reverse: true);
                  scan.scanNetwork(8123);
                });
              },
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Container(
                    width: 150 + 50 * factor,
                    height: 150 + 50 * factor,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Color(0xfff58228), Color(0xffd82258)],
                            begin: AlignmentDirectional.topCenter,
                            end: AlignmentDirectional.bottomCenter),
                        shape: BoxShape.circle),
                  ),
                  Container(
                    width: 190 * factor,
                    height: (190) * factor,
                    decoration: const BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                  ),
                  Opacity(
                    opacity: factor > 1
                        ? 1
                        : factor < 0
                            ? 0
                            : factor,
                    child: const Text(
                      'Scan',
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Gilroy"),
                    ),
                  ),
                ],
              ));
        });
  }
}
