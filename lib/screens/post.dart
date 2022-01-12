import 'dart:io';

import 'package:amber/models/user.dart';
import 'package:flutter/material.dart';
import 'package:amber/constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class PostPage extends StatefulWidget {
  static const id = '/post';
  final String currentUserId;
  const PostPage({Key? key, required this.currentUserId}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  File? file;
  bool isUploading = false;
  // Future handleTakePhoto() async {
  //   try {
  //     Navigator.pop(context);
  //     //XFile? image;
  //     final picker = ImagePicker();
  //     final file = await picker.pickImage(
  //       //File image = (await picker.pickImage(
  //       source: ImageSource.camera,
  //       maxHeight: 675,
  //       maxWidth: 960,
  //     );
  //     final image = File(file!.path);
  //     // if (!mounted) return;
  //     setState(() {
  //       this.file = image;
  //       //file = image;
  //     });
  //   } on PlatformException catch (e) {
  //     // TODO
  //     print("failed");
  //   }
  // }
  handleTakePhoto() async {
    Navigator.pop(context);
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.camera);
    file = File('${xFile?.path}');
    if (mounted) {
      setState(() {});
    }
  }

  // Future handleChooseFromGallery() async {
  //   try {
  //     Navigator.pop(context);
  //     //XFile? image;
  //     final picker = ImagePicker();
  //     final file = await picker.pickImage(
  //       //File image = picker.pickImage(
  //       source: ImageSource.gallery,
  //     );
  //     final image = File(file!.path);
  //     //if (!mounted) return;
  //     setState(() {
  //       this.file = image;
  //       //file = image;
  //     });
  //   } on PlatformException catch (e) {
  //     // TODO
  //     print("failed");
  //   }
  // }
  handleChooseFromGallery() async {
    Navigator.pop(context);
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    file = File('${xFile?.path}');
    //if (!mounted) return;
    if (mounted) {
      setState(() {});
    }
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
                  onPressed: handleTakePhoto
                  // Navigator.of(context).pop();
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

  clearImage() {
    setState(() {
      file == null;
    });
  }

  buildUploadForm() {
    // return Scaffold(
    //   appBar: AppBar(
    //     backgroundColor: Colors.white,
    //     leading: IconButton(
    //         icon: Icon(Icons.arrow_back),
    //         color: Colors.black,
    //         onPressed: clearImage),
    //     title: Text(
    //       "Caption Post",
    //       style: TextStyle(color: Colors.black),
    //     ),
    //     actions: [
    //       TextButton(
    //         onPressed: () => print("pressed"),
    //         child: Text(
    //           "Post",
    //           style: TextStyle(
    //               color: Colors.black,
    //               fontWeight: FontWeight.bold,
    //               fontSize: 20.0),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
    return Text(" lol ");
  }

  @override
  Widget build(BuildContext context) {
    return file == null ? buildSplashScreen() : buildUploadForm();
  }
}
