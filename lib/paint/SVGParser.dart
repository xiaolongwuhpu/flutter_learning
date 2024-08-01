import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xml/xml.dart';
import 'package:path_drawing/path_drawing.dart';

class SVGParser {
  final List<Path> draws = [];
  List<Color> colors = [];
  List<Color> actualColors = [];

  Future<void> load(String assetName) async {
    draws.clear();
    colors.clear();
    actualColors.clear();
    String svg = await rootBundle.loadString(assetName);
    final document = XmlDocument.parse(svg);
    final svgRoot = document.rootElement;
    Iterable<XmlElement> pathNodes = svgRoot.findAllElements('path');
    List<XmlElement> pathNodesList = pathNodes.toList();
    RegExp colorRegex = RegExp(r"#\w{6}");
    for (int i = 0; i < pathNodesList.length; i++) {
      XmlElement element = pathNodesList[i];
      String? d = element.getAttribute('d');
      final Path path = parseSvgPathData(d ?? '');
      draws.add(path);
      String? style = element.getAttribute('style');
      assemblyColor(colorRegex, style);
    }
    _checkColors();
  }

   _checkColors(){
    if (colors.isNotEmpty) return;
    colors =  List.generate(draws.length, (index) => Colors.blueAccent.withOpacity(0.1));
    actualColors =  List.generate(draws.length, (index) => Colors.green);
  }

  void assemblyColor(RegExp colorRegex, String? style) {
    if (style != null) {
      final colorMatch = colorRegex.firstMatch(style);
      if (colorMatch != null) {
        final colorString = colorMatch.group(0);
        final color = colorString != null ? Color(int.parse(colorString!.substring(1), radix: 16) | 0xFF000000) : Colors.black;
        colors.add(color.withOpacity(0.1));
        actualColors.add(color);
      }else {
        final colorString = convertRgbToHex(extractFillColor(style));
        final color = colorString != null ? Color(int.parse(colorString!.substring(1), radix: 16) | 0xFF000000) : Colors.black;
        colors.add(color.withOpacity(0.1));
        actualColors.add(color);
      }
    }
  }

  String? extractFillColor(String input) {
    final fillColorRegex = RegExp(r'fill: rgb\((\d+), (\d+), (\d+)\)');
    final match = fillColorRegex.firstMatch(input);
    if (match != null) {
      final r = int.parse(match.group(1)!);
      final g = int.parse(match.group(2)!);
      final b = int.parse(match.group(3)!);
      return 'rgb($r, $g, $b)';
    }
    return null;
  }

  String? convertRgbToHex(String? rgbColor) {
    if (rgbColor == null) return null;
    final rgbRegex = RegExp(r'rgb\((\d+), (\d+), (\d+)\)');
    final match = rgbRegex.firstMatch(rgbColor);
    if (match != null) {
      final r = int.parse(match.group(1)!);
      final g = int.parse(match.group(2)!);
      final b = int.parse(match.group(3)!);
      return '#${r.toRadixString(16).padLeft(2, '0').toUpperCase()}'
          '${g.toRadixString(16).padLeft(2, '0').toUpperCase()}'
          '${b.toRadixString(16).padLeft(2, '0').toUpperCase()}';
    }
    return null;
  }
}
