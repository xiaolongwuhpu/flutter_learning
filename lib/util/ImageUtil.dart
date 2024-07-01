
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
class ImageUtil{
  Future<ui.Image> loadImage(String imagePath) async {
    final ByteData data = await rootBundle.load(imagePath);
    final ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }
}