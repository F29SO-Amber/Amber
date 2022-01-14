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

class PublishScreen extends StatefulWidget {
  final String currentUserID;
  const PublishScreen({Key? key, required this.currentUserID})
      : super(key: key);

  @override
  _PublishScreenState createState() => _PublishScreenState();
}

class _PublishScreenState extends State<PublishScreen> {
  File? file;

  Future<void> chooseImage() async {
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    file = File('${xFile?.path}');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Upload an Image',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              child: const Icon(
                Icons.publish,
                color: Colors.white,
              ),
              onTap: () async {
                if (file != null) {
                  DatabaseService.addUserPost(
                      await StorageService.uploadPost(file!));
                  // Navigator.pop(context);
                }
              },
            ),
          ),
        ],
        backgroundColor: kAppColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
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
                // color: createRandomColor(),
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(left: 15, top: 20),
                child: const TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: "Write a caption...",
                    border: InputBorder.none,
                    prefixIcon:
                        Icon(Icons.description, color: kAppColor, size: 30),
                  ),
                ),
              ),
              const Divider(),
              Container(
                // color: createRandomColor(),
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(left: 15),
                child: const TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: "Locate your post...",
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.pin_drop_outlined,
                      color: kAppColor,
                      size: 30,
                    ),
                    suffixIcon: Icon(Icons.home),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: CustomOutlinedButton(
              widthFactor: 0.8,
              onPress: () {},
              buttonText: "Post",
            ),
          ),
        ],
      ),
    );
  }
}
