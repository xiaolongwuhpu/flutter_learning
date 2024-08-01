import 'package:flutter/material.dart';
import 'package:flutter_learning/paint/SVGParser.dart';

import 'MyPainter.dart';
class SVGViewer extends StatefulWidget {
  final SVGParser parser;
  final Size size;

  SVGViewer({required this.parser, required this.size});

  @override
  _SVGViewerState createState() => _SVGViewerState();
}

class _SVGViewerState extends State<SVGViewer> {
  late MyPainter _painter;

  @override
  void initState() {
    super.initState();
    _painter = MyPainter(draws: widget.parser.draws, colors: widget.parser.colors);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return InteractiveViewer(
      boundaryMargin: const EdgeInsets.all(50),
      maxScale: 6,
      child: OverflowBox(
        child: GestureDetector(
          onTapDown: (TapDownDetails details) {
            Offset offset = Offset(
                details.localPosition.dx / (width / widget.size.width),
                details.localPosition.dy / (width / widget.size.width));
            onTap(offset);
            setState(() {});
          },
          child: Container(
            color: Colors.white,
            width: width,
            height: width,
            child: Center(
              child: Transform.translate(
                offset: Offset(
                    -(widget.size.width - width) / 2.0 * (width / widget.size.width),
                    -(widget.size.width - width) / 2.0 * (width / widget.size.width)),
                child: Transform.scale(
                  scale: width / widget.size.width,
                  child: RepaintBoundary(
                    child: CustomPaint(
                      isComplex: true,
                      size: Size(widget.size.width, widget.size.width),
                      painter: _painter,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onTap(Offset offset) {
    for (int i = 0; i < widget.parser.draws.length; i++) {
      Path path = widget.parser.draws[i];
      if (path.contains(offset)) {
        widget.parser.colors[i] = widget.parser.actualColors[i];
        return;
      }
    }
  }
}
