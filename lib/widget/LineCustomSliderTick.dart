import 'package:flutter/material.dart';

class LineCustomSliderTick extends SliderTickMarkShape {
  /// Create a slider tick mark that draws a circle.
  const LineCustomSliderTick({
    this.tickMarkRadius,
  });

  /// The preferred radius of the round tick mark.
  ///
  /// If it is not provided, then 1/4 of the [SliderThemeData.trackHeight] is used.
  final double? tickMarkRadius;

  @override
  Size getPreferredSize({
    required SliderThemeData sliderTheme,
    required bool isEnabled,
  }) {
    assert(sliderTheme.trackHeight != null);
    return Size.fromRadius(tickMarkRadius ?? sliderTheme.trackHeight! / 4);
  }

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required Animation<double> enableAnimation,
        required TextDirection textDirection,
        required Offset thumbCenter,
        required bool isEnabled,
      }) {
    assert(sliderTheme.disabledActiveTickMarkColor != null);
    assert(sliderTheme.disabledInactiveTickMarkColor != null);
    assert(sliderTheme.activeTickMarkColor != null);
    assert(sliderTheme.inactiveTickMarkColor != null);
    // The paint color of the tick mark depends on its position relative
    // to the thumb and the text direction.
    Color? begin;
    Color? end;
    switch (textDirection) {
      case TextDirection.ltr:
        final bool isTickMarkRightOfThumb = center.dx > thumbCenter.dx;
        begin = isTickMarkRightOfThumb ? Colors.red : Colors.blue ;
        // end = isTickMarkRightOfThumb ? Colors.orange : Colors.green;
        end = sliderTheme.inactiveTrackColor;

        // begin = isTickMarkRightOfThumb ? sliderTheme.disabledInactiveTickMarkColor : sliderTheme.disabledActiveTickMarkColor;
        // end = isTickMarkRightOfThumb ? sliderTheme.inactiveTickMarkColor : sliderTheme.activeTickMarkColor;
      case TextDirection.rtl:
        final bool isTickMarkLeftOfThumb = center.dx < thumbCenter.dx;
        begin = isTickMarkLeftOfThumb ? sliderTheme.disabledInactiveTickMarkColor : sliderTheme.disabledActiveTickMarkColor;
        end = isTickMarkLeftOfThumb ? sliderTheme.inactiveTickMarkColor : sliderTheme.activeTickMarkColor;
    }
    final Paint paint = Paint()..color = ColorTween(begin: begin, end: end).evaluate(enableAnimation)!;

    // // The tick marks are tiny circles that are the same height as the track.
    // final double tickMarkRadius = getPreferredSize(
    //       isEnabled: isEnabled,
    //       sliderTheme: sliderTheme,
    //     ).width * 3;
    // if (tickMarkRadius > 0) {
    //   context.canvas.drawCircle(center, tickMarkRadius, paint);
    // }



    final double tickMarkHeight = getPreferredSize(
      isEnabled: isEnabled,
      sliderTheme: sliderTheme,
    ).height;
    if (tickMarkHeight > 0) {
      final double lineWidth = 2.0; // Set the width of the line
      context.canvas.drawLine(
        Offset(center.dx, center.dy - tickMarkHeight*3),
        Offset(center.dx, center.dy + tickMarkHeight*3),
        paint..strokeWidth = lineWidth,
      );
    }
  }
}