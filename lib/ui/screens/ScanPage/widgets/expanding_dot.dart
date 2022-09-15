import 'package:flutter/material.dart';
import 'package:test/api/scan.dart';

class ExpandingDot extends StatefulWidget {
  const ExpandingDot({Key? key, this.onPressed}) : super(key: key);

  final Function()? onPressed;

  @override
  State<ExpandingDot> createState() => _ExpandingDotState();
}

class _ExpandingDotState extends State<ExpandingDot> {
  double end = 1;
  _ExpandingDotState();
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
                  widget.onPressed?.call();
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
