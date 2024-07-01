import 'package:flutter/material.dart';
import 'package:flutter_learning/util/ImageUtil.dart';
import 'package:flutter_learning/widget/LineCustomSliderTick.dart';
import 'package:flutter_learning/widget/RoundSliderThumbShapeImage.dart';
import 'dart:ui' as ui;

class SliderPage extends StatefulWidget {
  const SliderPage({super.key});

  @override
  State<SliderPage> createState() => _SliderPageState();
}

class _SliderPageState extends State<SliderPage> {
  double _sliderValue = 0;
  ui.Image? thumbImage;

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    thumbImage = await ImageUtil().loadImage('assets/images/ic_start.png');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF0F7FF),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 30,
              width: 330,
              alignment: Alignment.center,
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 2,
                  activeTrackColor: Colors.blue,
                  inactiveTrackColor: Colors.grey,
                ),
                child: Slider(
                  value: _sliderValue,
                  divisions: 6,
                  onChanged: (value) {
                    setState(() {
                      _sliderValue = value;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Value: ${_sliderValue.toStringAsFixed(1)}'),
            const SizedBox(height: 20),
            SliderTheme(
              data: SliderThemeData(
                tickMarkShape: LineCustomSliderTick(),
                // trackShape: RectangularSliderTrackShape(),
                // thumbShape: RoundSliderThumbShape(enabledThumbRadius: 20),
                thumbShape: thumbImage == null
                    ? null
                    : RoundSliderThumbShapeImage(
                        elevation: 0,
                        thumbImage: thumbImage,
                      ),
                // trackShape: RoundedRectSliderTrackShape(),
              ),
              child: Slider(
                value: _sliderValue,
                activeColor: const Color(0XFF489CF9),
                inactiveColor: const Color(0XFFc8e6ff),
                min: 0.0,
                max: 1.0,
                divisions: 6,
                onChanged: (double value) {
                  setState(() {
                    _sliderValue = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
