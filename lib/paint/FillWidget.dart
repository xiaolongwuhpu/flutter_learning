import 'package:flutter/material.dart';
import 'package:flutter_learning/paint/MyPainter.dart';
import 'package:flutter_learning/paint/SVGParser.dart';

class FillWidget extends StatefulWidget {
  final String assetName;
  final Size size;

  const FillWidget({super.key, required this.assetName, required this.size});

  @override
  _FillWidgetState createState() => _FillWidgetState();
}

class _FillWidgetState extends State<FillWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _radiusAnimation;
  late SVGParser _parser;
  MyPainter? _painter;

  @override
  void initState() {
    super.initState();
    _parser = SVGParser();
    // _painter = MyPainter(draws: _parser.draws, colors: _parser.colors);
    _animationController = AnimationController(duration: const Duration(milliseconds: 500), vsync: this)
      ..repeat(reverse: true)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          print("svg_fill  Animation completed");
          setState(() {});
        } else if (status == AnimationStatus.dismissed) {
          print("svg_fill  Animation dismissed");
        }
      });
    _radiusAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _parser.load(widget.assetName).then((_) {
      setState(() {
        _painter = MyPainter(draws: _parser.draws, colors: _parser.colors);
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_painter == null) {
      return const Center(
        child: SizedBox(height: 60, width: 60, child: CircularProgressIndicator()),
      );
    }

    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        RenderBox renderBox = context.findRenderObject() as RenderBox;
        Offset localPosition = renderBox.globalToLocal(details.globalPosition);
        double scale = width / widget.size.width;
        Offset scaledOffset = Offset(localPosition.dx, localPosition.dy);
        onTap(scaledOffset);
        setState(() {
          _painter = MyPainter(draws: _parser.draws, colors: _parser.colors);
        });
      },
      child: Container(
        color: Colors.white,
        width: width,
        height: width,
        child: Center(
          child:RepaintBoundary(
            child: CustomPaint(
              isComplex: true,
              size: widget.size,
              painter: _painter,
            ),
          ),


          // Transform.translate(
          //   offset: Offset(
          //       -(widget.size.width - width) / 2.0 * (width / widget.size.width), -(widget.size.width - width) / 2.0 * (width / widget.size.width)),
          //   child: Transform.scale(
          //     scale: width / widget.size.width,
          //     child: RepaintBoundary(
          //       child: CustomPaint(
          //         isComplex: true,
          //         size: widget.size,
          //         painter: _painter,
          //       ),
          //     ),
          //   ),
          // ),
        ),
      ),
    );
  }

  void onTap(Offset offset) {
    for (int i = 0; i < _parser.draws.length; i++) {
      Path path = _parser.draws[i];
      if (path.contains(offset)) {
        _parser.colors[i] = _parser.actualColors[i];
        return;
      }
    }
  }
}
