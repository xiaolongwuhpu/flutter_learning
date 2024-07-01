import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_learning/slider/SliderPage.dart';

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
          body: SafeArea(
              child: CustomScrollView(
        slivers: [
          _buildTextButton(context, "Slider Test", onPressed: () {
            _openSliderPage();
          }),
        ],
      ))),
    );
  }

  void _openSliderPage() {
    Navigator.push<void>(
      context,
      CupertinoPageRoute<void>(
        builder: (BuildContext context) => const SliderPage(),
      ),
    );
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
