import 'package:flutter/material.dart';

class Ring extends StatelessWidget {
  final double diameter;
  const Ring({Key? key, required this.diameter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: AlignmentDirectional.center, children: [
      Container(
        height: diameter,
        width: diameter,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xfff58228), Color(0xffd82258)],
                begin: AlignmentDirectional.topCenter,
                end: AlignmentDirectional.bottomCenter),
            shape: BoxShape.circle),
      ),
      Container(
        height: diameter - 8,
        width: diameter - 8,
        decoration:
            const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      )
    ]);
  }
}
