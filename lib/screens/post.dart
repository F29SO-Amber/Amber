import 'dart:io';

import 'package:amber/models/user.dart';
import 'package:amber/services/database_service.dart';
import 'package:amber/widgets/progress.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:amber/constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;
import 'package:uuid/uuid.dart';
import 'package:amber/services/storage_service.dart';

class PostPage extends StatefulWidget {
  static const id = '/post';
  final String currentUserId;
  const PostPage({Key? key, required this.currentUserId}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  TextEditingController locationController = TextEditingController();
  TextEditingController captionController = TextEditingController();
  File? file;
  bool isUploading = false;
  String postId = Uuid().v4();

  handleTakePhoto() async {
    Navigator.pop(dialogContext);
    //Navigator.of(context, rootNavigator: true).pop();
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.camera);
    file = File('${xFile?.path}');
    if (mounted) {
      setState(() {});
    }
  }

  handleChooseFromGallery() async {
    Navigator.pop(dialogContext);
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    file = File('${xFile?.path}');
    //if (!mounted) return;
    if (mounted) {
      setState(() {});
    }
  }

  late BuildContext dialogContext;
  //late BuildContext ctx;
  selectImage(parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          dialogContext = context;
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
                  //fixedSize: Size(MediaQuery.of(context).size.width * 0.65, 43),
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

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image? imageFile = Im.decodeImage(file!.readAsBytesSync());
    final compressedImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile!, quality: 85));
    setState(() {
      file = compressedImageFile;
    });
  }

  Future<String> uploadImage(imageFile) async {
    UploadTask uploadTask =
        StorageService.storageRef.child("post_$postId.jpg").putFile(imageFile);
    TaskSnapshot storageSnap = await uploadTask;
    String downloadURL = await storageSnap.ref.getDownloadURL();
    return downloadURL;
  }

  createPostInFirestore(
      {required String mediaURL,
      required String location,
      required String description}) {
    DatabaseService.postsRef
        .doc(widget.currentUserId)
        .collection("userPosts")
        .doc(postId)
        .set({
      "postId": postId,
      "ownerId": widget.currentUserId,
      //"username": DatabaseService
      "mediaURL": mediaURL,
      "description": description,
      "location": location,
      "likes": {},
    });
  }

  handleSubmit() async {
    setState(() {
      isUploading = true;
    });
    await compressImage();
    String mediaURL = await uploadImage(file);
    createPostInFirestore(
      mediaURL: mediaURL,
      location: locationController.text,
      description: captionController.text,
    );
    captionController.clear();
    locationController.clear();
    setState(() {
      file = null;
      isUploading = false;
      postId = Uuid().v4();
    });
  }

  Scaffold buildUploadForm() {
    return Scaffold(
      body: StreamBuilder(
        stream: DatabaseService.getUser(widget.currentUserId).asStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var userData = snapshot.data as UserModel;
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.amber[50],
                leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    color: Colors.black,
                    onPressed: clearImage),
                title: Text(
                  "Caption Post",
                  style: TextStyle(color: Colors.black),
                ),
                actions: [
                  TextButton(
                    onPressed: isUploading ? null : () => handleSubmit(),
                    child: Text(
                      "Post",
                      style: TextStyle(
                          color: Colors.amber[600],
                          fontWeight: FontWeight.bold,
                          fontSize: 17.0),
                    ),
                  ),
                ],
              ),
              body: ListView(
                children: <Widget>[
                  isUploading ? linearProgress() : Text(""),
                  Container(
                    height: 220.0,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(file!),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: userData.profilePhoto,
                    ),
                    title: Container(
                      width: 250.0,
                      child: TextField(
                        controller: captionController,
                        decoration: InputDecoration(
                          hintText: "Write a caption...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(
                      Icons.pin_drop,
                      color: Colors.amber[600],
                      size: 35.0,
                    ),
                    title: Container(
                      width: 250.0,
                      child: TextField(
                        controller: locationController,
                        decoration: InputDecoration(
                          hintText: "Where was this photo taken?",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 200.0,
                    height: 100.0,
                    alignment: Alignment.center,
                    child: ElevatedButton.icon(
                      onPressed: () => print("get user location"),
                      icon: Icon(
                        Icons.my_location,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Use Current Location",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        primary: Colors.amber[600],
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return file == null ? buildSplashScreen() : buildUploadForm();
  }
}
