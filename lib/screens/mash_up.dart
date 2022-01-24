import 'dart:io';

import 'package:amber/screens/publish.dart';
import 'package:amber/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_painter/image_painter.dart';
import 'package:path_provider/path_provider.dart';

class MashUpPost extends StatefulWidget {
  final String imageURL;

  const MashUpPost({Key? key, required this.imageURL}) : super(key: key);

  @override
  State<MashUpPost> createState() => _MashUpPostState();
}

class _MashUpPostState extends State<MashUpPost> {
  final _imageKey = GlobalKey<ImagePainterState>();
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    void saveAndProceed() async {
      final directory = (await getApplicationDocumentsDirectory()).path;
      await Directory('$directory/sample').create(recursive: true);
      final fullPath = '$directory/sample/${DateTime.now().millisecondsSinceEpoch}.png';
      File(fullPath).writeAsBytesSync((await _imageKey.currentState?.exportImage())!);
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => PublishScreen(mashUpLink: fullPath)),
      );
    }

    return Scaffold(
      key: _key,
      appBar: AppBar(
        backgroundColor: kAppColor,
        title: const Text(kAppName, style: TextStyle(fontSize: 18, color: Colors.white)),
        actions: [IconButton(icon: const Icon(Icons.done), onPressed: saveAndProceed)],
      ),
      body: ImagePainter.network(
        widget.imageURL,
        key: _imageKey,
        scalable: true,
        initialStrokeWidth: 2,
        initialColor: Colors.green,
        initialPaintMode: PaintMode.line,
      ),
    );
  }
}
