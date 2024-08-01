import 'package:flutter/material.dart';
import 'package:flutter_learning/paint/SVGParser.dart';
import 'dart:math' as math;
import 'MyPainter.dart';

class SVGViewer extends StatefulWidget {
  final SVGParser parser;
  final Size size;

  const SVGViewer({super.key, required this.parser, required this.size});

  @override
  _SVGViewerState createState() => _SVGViewerState();
}

class _SVGViewerState extends State<SVGViewer> with SingleTickerProviderStateMixin {
  double scale = 1.0;
  bool isScaling = false;

  // late AnimationController _animationController;
  // late Animation<double> _radiusAnimation;

  @override
  void initState() {
    // _animationController = AnimationController(
    //     duration: const Duration(milliseconds: 1000), vsync: this)
    //   ..repeat(reverse: true)
    //   ..addStatusListener((status) {
    //     if (status == AnimationStatus.completed) {
    //       print("Animation completed");
    //       setState(() {});
    //     } else if (status == AnimationStatus.dismissed) {
    //       print("Animation dismissed");
    //     }
    //   });
    // _radiusAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    super.initState();
  }

  @override
  void dispose() {
    // _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.parser == null || widget.parser.draws.isEmpty || widget.parser.colors.isEmpty /*|| _animationController == null*/) {
      return const Center(
        child: SizedBox(height: 60, width: 60, child: CircularProgressIndicator()),
      );
    }

    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    scale = math.min((screenWidth / widget.size.width), (screenHeight / widget.size.height));
    var svgWidth = widget.size.width * scale;
    var svgHeight = widget.size.height * scale;

    return InteractiveViewer(
      onInteractionStart: (details) {
        if (details.pointerCount > 1) {
          isScaling = true;
        }
      },
      onInteractionEnd: (details) {
        isScaling = false;
      },
      maxScale: 6,
      minScale: 0.2,
      child: OverflowBox(
        child: GestureDetector(
          onTapDown: (TapDownDetails details) {
            if (isScaling) return;
            Offset offset = Offset(details.localPosition.dx / scale, details.localPosition.dy / scale);
            onTap(offset);
          },
          child: Container(
            width: screenWidth,
            height: screenHeight,
            child: RepaintBoundary(
              child: CustomPaint(
                key: UniqueKey(),
                isComplex: true,
                size: Size(svgWidth, svgHeight),
                painter: MyPainter(draws: widget.parser.draws, colors: widget.parser.colors, scale: scale),
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
        if (widget.parser.colors[i].opacity == 1.0) {
          return;
        }
        setState(() {
          widget.parser.colors[i] = widget.parser.actualColors[i];
        });
        return;
      }
    }
  }
}
