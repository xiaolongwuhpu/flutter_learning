import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'FillWidget.dart';

class FillWidgetPage extends StatefulWidget {
  const FillWidgetPage({super.key});

  @override
  State<FillWidgetPage> createState() => _FillWidgetPageState();
}

class _FillWidgetPageState extends State<FillWidgetPage> {



  @override
  Widget build(BuildContext context) {
    const String assetName = 'assets/images/girl.svg';
    final Widget svg = SizedBox(
      height: 300,
      width: 300,
      child: SvgPicture.asset(
          assetName,
          semanticsLabel: 'Acme Logo'
      ),
    );

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: const Text('Path Fill Animation')),
        body: Container(
          child: SizedBox(
            width: 573,
            height: 789,
            child: const FillWidget(
              assetName: assetName, // Your SVG file path
              size: Size(573, 789), // Size of your SVG
            ),
          ),
        ),
      ),
    );
  }
}
