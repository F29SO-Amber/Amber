import 'dart:io';

import 'package:flutter/material.dart';
import 'package:amber/constants.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);
  static const id = '/post';

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  File? file;
  handleTakePhoto() async {
    Navigator.pop(context);
    //XFile? image;
    final picker = ImagePicker();
    File file = (await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 675,
      maxWidth: 960,
    )) as File;

    setState(() {
      this.file = file;
    });
  }

  handleChooseFromGallery() async {
    Navigator.pop(context);
    //XFile? image;
    final picker = ImagePicker();
    File file = (await picker.pickImage(source: ImageSource.gallery)) as File;
    setState(() {
      this.file = file;
    });
  }

  selectImage(parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Create post"),
            children: <Widget>[
              SimpleDialogOption(
                child: const Text("Photo with camera "),
                onPressed: handleTakePhoto,
              ),
              SimpleDialogOption(
                child: const Text("Image from gallery"),
                onPressed: handleChooseFromGallery,
              ),
              SimpleDialogOption(
                child: const Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  Container buildSplashScreen() {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //SvgPicture.asset('assets/images/upload.svg', height: 260),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: ElevatedButton(
              onPressed: () => selectImage(context),
              child: const Text(
                "Upload image",
                style: TextStyle(color: Colors.black, fontSize: 18.0),
              ),
              style: ElevatedButton.styleFrom(
                  fixedSize: Size(MediaQuery.of(context).size.width * 0.65, 43),
                  primary: Colors.amber, // background
                  onPrimary: Colors.black, // foreground
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(90.0))),
            ),
          ),
        ],
      ),
    );
  }

  buildUploadForm() {
    return const Text("File loaded! ");
  }

  @override
  Widget build(BuildContext context) {
    return buildSplashScreen();
  }
}
