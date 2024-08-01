import 'package:flutter/material.dart';

class MyPainter extends CustomPainter {
  final List<Path> draws;
  final List<Color> colors;
  double scale;

  MyPainter({required this.draws, required this.colors, this.scale = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    if (draws.isEmpty || colors.isEmpty) {
      print("svg_fill Draws or colors are empty!");
      return;
    }

    canvas.scale(scale);
    var style = textStyle();
    for (int i = 0; i < draws.length; i++) {
      Path path = draws[i];
      canvas.drawPath(path, Paint()..color = colors[i]);
      canvas.drawPath(
        path,
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0,
      );

      // _drawText(i, style, path, canvas);
    }
  }

  void _drawText(int i, TextStyle style, Path path, Canvas canvas) {
    final textSpan = _num("$i", style);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final pathBounds = path.getBounds();
    final pathCenter = Offset(
      pathBounds.left + pathBounds.width / 2,
      pathBounds.top + pathBounds.height / 2,
    );

    // textPainter.paint(canvas, pathCenter);

    final textBounds = Offset(
          pathCenter.dx - textPainter.width / 2,
          pathCenter.dy - textPainter.height / 2,
        ) &
        Size(textPainter.width, textPainter.height);

    if (path.contains(textBounds.topLeft) &&
        path.contains(textBounds.topRight) &&
        path.contains(textBounds.bottomLeft) &&
        path.contains(textBounds.bottomRight)) {
      textPainter.paint(canvas, pathCenter);
    }
  }

  _num(text, TextStyle textStyle) {
    return TextSpan(
      text: text,
      style: textStyle,
    );
  }

  TextStyle textStyle() {
    return const TextStyle(
      color: Colors.black,
      fontSize: 12,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate){
    if(oldDelegate is MyPainter){
      return oldDelegate.draws != draws || oldDelegate.colors != colors;
    }
    return false;
  }
}
