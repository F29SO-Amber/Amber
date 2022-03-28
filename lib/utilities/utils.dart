import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

import 'package:path_provider/path_provider.dart';

class Utils {
  static Future<Uint8List?> capture(GlobalKey? key) async {
    if (key == null) return null;

    RenderRepaintBoundary boundary =
        key.currentContext?.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData?.buffer.asUint8List();

    return pngBytes;
  }

  static Future<Uint8List> capturePng(GlobalKey _screenshotKey) async {
    try {
      Directory dir;
      RenderRepaintBoundary? boundary =
          _screenshotKey.currentContext!.findRenderObject() as RenderRepaintBoundary?;
      await Future.delayed(const Duration(milliseconds: 2000));
      if (Platform.isIOS) {
        ///For iOS
        dir = await getApplicationDocumentsDirectory();
      } else {
        ///For Android
        dir = (await getExternalStorageDirectory())!;
      }
      var image = await boundary?.toImage();
      var byteData = await image?.toByteData(format: ui.ImageByteFormat.png);
      File screenshotImageFile = File('${dir.path}/${DateTime.now().microsecondsSinceEpoch}.png');
      await screenshotImageFile.writeAsBytes(byteData!.buffer.asUint8List());
      return byteData.buffer.asUint8List();
    } catch (e) {
      debugPrint("Capture Image Exception Main : " + e.toString());
      throw Exception();
    }
  }
}
