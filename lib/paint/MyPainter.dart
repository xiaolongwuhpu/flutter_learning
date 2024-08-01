import 'package:flutter/material.dart';

class MyPainter extends CustomPainter {
  final List<Path> draws;
  final List<Color> colors;

  MyPainter({required this.draws, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    if (draws.isEmpty || colors.isEmpty) {
      print("svg_fill Draws or colors are empty!");
      return;
    }
    for (int i = 0; i < draws.length; i++) {
      Path path = draws[i];
      canvas.drawPath(path, Paint()..color = colors[i]);
      // 然后绘制描边
      canvas.drawPath(
        path,
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
