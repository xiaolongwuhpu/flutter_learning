import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'CropImageUtil.dart';

class ImageCropper extends StatefulWidget {
  const ImageCropper({super.key});

  @override
  State<ImageCropper> createState() => _ImageCropperState();
}

class _ImageCropperState extends State<ImageCropper> {
  final GlobalKey<ExtendedImageEditorState> editorKey = GlobalKey<ExtendedImageEditorState>();
  bool _cropping = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ImageCropper测试页面"),
      ),
      body: ExtendedImage.network(
        'https://c-ssl.dtstatic.com/uploads/blog/202310/26/5zSdYLmWhOYYZxZ.thumb.1000_0.jpeg',
        fit: BoxFit.contain,
        mode: ExtendedImageMode.editor,
        enableLoadState: true,
        extendedImageEditorKey: editorKey,
        cacheRawData: true,
        //maxBytes: 1024 * 50,
        initEditorConfigHandler: (ExtendedImageState? state) {
          return EditorConfig(
              maxScale: 4.0,
              cropRectPadding: const EdgeInsets.all(20.0),
              hitTestSize: 20.0,
              initCropRectType: InitCropRectType.imageRect,
              cropAspectRatio: CropAspectRatios.ratio4_3,
              editActionDetailsIsChanged: (EditActionDetails? details) {
                //print(details?.totalScale);
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.crop),
          onPressed: () {
            cropImage();
          }),
    );
  }

  Future<void> cropImage() async {
    print("saveImage _cropping:$_cropping");
    if (_cropping) {
      return;
    }
    _cropping = true;
    try {
      final Uint8List fileData = Uint8List.fromList((await cropImageDataWithNativeLibrary(state: editorKey.currentState!))!);
      // 图片保存到本地
      saveImage(fileData);
      // final String? fileFath =
      // await ImageSaver.save('extended_image_cropped_image.jpg', fileData);
      // print('save image : $fileFath');
    } finally {
      _cropping = false;
    }
  }

  void saveImage(Uint8List imageByte) async {
    var tmpDir = await getTemporaryDirectory();
    var file = await File("${tmpDir.path}/image_${DateTime.now().microsecond}.jpg").create();
    file.writeAsBytesSync(imageByte);
    print("saveImage file:${file.path}");
    int length = await file.length();
    print('saveImage file length:${length}');
    // Uint8List readImageData = await file.readAsBytesSync();
  }
}
