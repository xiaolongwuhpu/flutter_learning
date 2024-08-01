
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart' show rootBundle;
class SketchImageScreen extends StatefulWidget {
  @override
  _SketchImageScreenState createState() => _SketchImageScreenState();
}

class _SketchImageScreenState extends State<SketchImageScreen> {
  Uint8List? _imageData;
  Uint8List? _sketchedImageData;

  @override
  void initState() {
    super.initState();
    _loadAndSketchImage();
  }

  Future<void> _loadAndSketchImage() async {
    // 加载图片
    final ByteData data = await rootBundle.load('assets/images/o/code.jpeg');
    final Uint8List bytes = data.buffer.asUint8List();

    // 使用 image 包处理图片
    img.Image originalImage = img.decodeImage(bytes)!;
    img.Image sketchedImage = _convertToSketch(originalImage);

    // 转换处理后的图片为 Uint8List
    Uint8List sketchedBytes = Uint8List.fromList(img.encodeJpg(sketchedImage));

    setState(() {
      _imageData = bytes;
      _sketchedImageData = sketchedBytes;
    });
  }

  img.Image _convertToSketch(img.Image src) {
    // 转换为灰度图像
    img.Image grayscale = img.grayscale(src);

    // 反转灰度图像
    img.Image inverted = img.invert(grayscale);

    // 对反转后的图像应用高斯模糊
    img.Image blurred = img.gaussianBlur(inverted, 10);

    // 将模糊后的图像再次反转
    img.Image invertedBlurred = img.invert(blurred);

    // 将结果与原始灰度图像进行融合，得到类似于素描的效果
    img.Image sketch = img.Image(src.width, src.height);
    for (int y = 0; y < src.height; y++) {
      for (int x = 0; x < src.width; x++) {
        int originalPixel = grayscale.getPixel(x, y);
        int sketchPixel = invertedBlurred.getPixel(x, y);

        // 使用简单的混合公式进行融合
        int outputPixel = img.getLuminance(originalPixel) * img.getLuminance(sketchPixel) ~/ 255;
        sketch.setPixel(x, y, img.getColor(outputPixel, outputPixel, outputPixel));
      }
    }

    return sketch;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Sketch'),
      ),
      body: Center(
        child: _sketchedImageData == null
            ? CircularProgressIndicator()
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Original Image:'),
            _imageData != null
                ? Image.memory(_imageData!, width: 200)
                : Container(),
            SizedBox(height: 20),
            Text('Sketched Image:'),
            _sketchedImageData != null
                ? Image.memory(_sketchedImageData!, width: 200)
                : Container(),
          ],
        ),
      ),
    );
  }
}