import 'package:flutter/material.dart';
import 'SVGParser.dart';
import 'SVGViewer.dart';

class FillWidgetPage extends StatefulWidget {
  const FillWidgetPage({super.key});

  @override
  State<FillWidgetPage> createState() => _FillWidgetPageState();
}

class _FillWidgetPageState extends State<FillWidgetPage> {
  SVGParser? _parser;
  final String assetName = 'assets/images/frog.svg';

  @override
  void initState() {
    super.initState();
    _parser = SVGParser();
    _parser?.load(assetName).then((_) {
      Future.delayed(Duration.zero, () {
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_parser == null) {
      return const Center(
        child: SizedBox(height: 60, width: 60, child: CircularProgressIndicator()),
      );
    }
    // final Widget svg = SizedBox(
    //   height: 300,
    //   width: 300,
    //   child: SvgPicture.asset(
    //       assetName,
    //       semanticsLabel: 'Acme Logo'
    //   ),
    // );

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: const Text('Path Fill Animation')),
        body: Container(
          alignment: Alignment.center,
          child: SVGViewer(
            parser: _parser!, // Your SVG file path
            size: Size(_parser!.svgWidth, _parser!.svgHeight), // Size of your SVG
          ),
        ),
      ),
    );
  }
}
