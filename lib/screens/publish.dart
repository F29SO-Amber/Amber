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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (file == null)
                ? const Icon(Icons.image, size: 48)
                : Container(
                    height: 180,
                    width: 320,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(file!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
            const SizedBox(height: 40),
            CustomOutlinedButton(
              buttonText: 'Pick Image',
              widthFactor: 0.85,
              onPress: chooseImage,
            )
          ],
        ),
      ),
    );
  }
}
