import 'dart:io';

import 'package:amber/models/user.dart';
import 'package:amber/services/database_service.dart';
import 'package:amber/widgets/profile_picture.dart';
import 'package:amber/widgets/progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:amber/utilities/constants.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
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
  File? file;
  bool isUploading = false;
  String postId = const Uuid().v4();
  TextEditingController locationController = TextEditingController();
  TextEditingController captionController = TextEditingController();

  handleTakePhoto() async {
    Navigator.pop(context);
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.camera);
    file = File('${xFile?.path}');
    if (mounted) {
      setState(() {});
    }
  }

  handleChooseFromGallery() async {
    Navigator.pop(context);
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    file = File('${xFile?.path}');
    if (mounted) {
      setState(() {});
    }
  }

  clearImage() {
    setState(() {
      file = null;
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
    UploadTask uploadTask = StorageService.storageRef
        .child("posts")
        .child('${widget.currentUserId}_${Timestamp.now()}')
        .putFile(imageFile);
    TaskSnapshot storageSnap = await uploadTask;
    String downloadURL = await storageSnap.ref.getDownloadURL();
    return downloadURL;
  }

  createPostInFirestore(
      {required String mediaURL,
      required String location,
      required String description}) async {
    Map<String, Object?> map = {};
    if (file != null) {
      map['id'] = '${widget.currentUserId}_${Timestamp.now()}';
      map['location'] = location;
      map['imageUrl'] = mediaURL;
      map['caption'] = description;
      map['score'] = 0;
      map['authorId'] = widget.currentUserId;
      map['timestamp'] = Timestamp.now();
      await DatabaseService.postsRef
          .doc('${widget.currentUserId}_${Timestamp.now()}')
          .set(map);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Image Posted!")),
      );
    }
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
                        child: GestureDetector(
                          onTap: () => showMaterialModalBottomSheet(
                            expand: false,
                            // shape: RoundedRectangleBorder(
                            //   borderRadius: BorderRadius.circular(33),
                            // ),
                            context: context,
                            backgroundColor: Colors.transparent,

                            builder: (context) => Material(
                              child: SafeArea(
                                top: false,
                                child: SizedBox(
                                  height: 250,
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 25.0),
                                        child: Text('Choose media from:',
                                            style: kDarkLabelTextStyle),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Column(
                                            children: [
                                              GestureDetector(
                                                onTap: handleTakePhoto,
                                                child: const ProfilePicture(
                                                    side: 100,
                                                    path: 'assets/camera.png'),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10.0),
                                                child: Text('Camera',
                                                    style:
                                                        kLightLabelTextStyle),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              GestureDetector(
                                                onTap: handleChooseFromGallery,
                                                child: const ProfilePicture(
                                                    side: 100,
                                                    path: 'assets/gallery.png'),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10.0),
                                                child: Text('Gallery',
                                                    style:
                                                        kLightLabelTextStyle),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: (file == null)
                                    ? const AssetImage('assets/taptoselect.png')
                                    : FileImage(file!) as ImageProvider,

                                fit: BoxFit.cover,
                                //image: FileImage(file!),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                  ),
                  // ListTile(
                  //   leading: CircleAvatar(
                  //     backgroundImage: userData.profilePhoto,
                  //   ),
                  //title: Container(
                  Container(
                    width: 250.0,
                    padding: EdgeInsets.only(left: 5, bottom: 0),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLength: null,
                      maxLines: null,
                      controller: captionController,
                      decoration: InputDecoration(
                        prefixIcon: CircleAvatar(
                          radius: 1,
                          backgroundImage: userData.profilePhoto,
                        ),
                        hintText: "  Write a caption...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  //),
                  Divider(),
                  Container(
                    width: 250.0,
                    padding: EdgeInsets.only(left: 5),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLength: null,
                      maxLines: null,
                      controller: locationController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.pin_drop,
                          color: Colors.amber[600],
                          size: 38.0,
                        ),
                        hintText: "  Where was this photo taken?",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  //),
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
    //return file == null ? buildSplashScreen() : buildUploadForm();
    return buildUploadForm();
  }
}
