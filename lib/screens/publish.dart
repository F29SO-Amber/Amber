import 'dart:io';

import 'package:amber/constants.dart';
import 'package:amber/services/auth_service.dart';
import 'package:amber/services/database_service.dart';
import 'package:amber/services/storage_service.dart';
import 'package:amber/widgets/custom_outlined_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PublishScreen extends StatefulWidget {
  final String currentUserID;
  const PublishScreen({Key? key, required this.currentUserID})
      : super(key: key);

  @override
  _PublishScreenState createState() => _PublishScreenState();
}

class _PublishScreenState extends State<PublishScreen> {
  File? file;
  final _formKey = GlobalKey<FormState>();
  final captionController = TextEditingController();
  final locationController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    captionController.dispose();
    locationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppColor,
        title: const Text(
          'Upload an Image',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.all(10.0),
        //     child: GestureDetector(
        //       child: const Icon(
        //         Icons.publish,
        //         color: Colors.white,
        //       ),
        //       onTap: () async {
        //         if (file != null) {
        //           DatabaseService.addUserPost(
        //               await StorageService.uploadPost(file!));
        //           // Navigator.pop(context);
        //         }
        //       },
        //     ),
        //   ),
        // ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                (file == null)
                    ? GestureDetector(
                        child: Container(
                          height: (MediaQuery.of(context).size.width / 16) * 9,
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/upload.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        onTap: chooseImage,
                      )
                    : GestureDetector(
                        child: Container(
                          height: (MediaQuery.of(context).size.width / 16) * 9,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: FileImage(file!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        onTap: chooseImage,
                      ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(left: 15, top: 20),
                  child: TextFormField(
                    controller: captionController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      hintText: "Write a caption...",
                      border: InputBorder.none,
                      prefixIcon:
                          Icon(Icons.description, color: kAppColor, size: 30),
                    ),
                  ),
                ),
                const Divider(),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(left: 15),
                  child: TextFormField(
                    controller: locationController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      hintText: "Locate your post...",
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.pin_drop_outlined,
                        color: kAppColor,
                        size: 30,
                      ),
                      suffixIcon: Icon(
                        Icons.my_location,
                        color: kAppColor,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: CustomOutlinedButton(
              widthFactor: 0.8,
              onPress: () async {
                if (_formKey.currentState!.validate()) {
                  Map<String, Object?> map = {};
                  if (file != null) {
                    map['id'] = '${widget.currentUserID}_${Timestamp.now()}';
                    map['location'] = locationController.text;
                    map['imageUrl'] = await uploadImage();
                    map['caption'] = captionController.text;
                    map['score'] = 0;
                    map['authorId'] = widget.currentUserID;
                    map['timestamp'] = Timestamp.now();
                    await DatabaseService.postsRef
                        .doc(widget.currentUserID)
                        .set(map);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Image Posted!")),
                    );
                  }
                }
              },
              buttonText: "Post",
            ),
          ),
        ],
      ),
    );
  }

  Future<void> chooseImage() async {
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    file = File('${xFile?.path}');
    setState(() {});
  }

  Future<String> uploadImage() async {
    TaskSnapshot taskSnapshot = await FirebaseStorage.instance
        .ref()
        .child('posts')
        .child('${widget.currentUserID}_${Timestamp.now()}')
        .putFile(file!);

    return taskSnapshot.ref.getDownloadURL();
  }
}
