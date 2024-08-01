import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_learning/paint/FillWidgetPage.dart';
import 'package:flutter_learning/sketch/sketch_image.dart';
import 'package:flutter_learning/slider/SliderPage.dart';

import 'image/ImageCropper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Table Example',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
              child: CustomScrollView(
            slivers: [
              _buildTextButton(context, "Slider Test", onPressed: () {
                _pushPage(const SliderPage());
              }),
              _buildTextButton(context, "图片剪切", onPressed: () {
                _pushPage(const ImageCropper());
              }),
              _buildTextButton(context, "图片填色", onPressed: () {
                _pushPage(const FillWidgetPage());
              }),
              _buildTextButton(context, "图片转线条", onPressed: () {
                _pushPage( SketchImageScreen());
              }),
            ],
          ))),
    );
  }

  _pushPage(Widget page) {
    Navigator.push(context, CupertinoPageRoute(builder: (context) => page));
  }

  SliverToBoxAdapter _buildTextButton(BuildContext context, String text, {Function()? onPressed}) {
    return SliverToBoxAdapter(
      child: TextButton(
          onPressed: () {
            onPressed?.call();
          },
          child: Text(text)),
    );
  }
}
