import 'dart:io';

import 'package:amber/models/user.dart';
import 'package:amber/services/database_service.dart';
import 'package:amber/widgets/custom_form_field.dart';
import 'package:amber/widgets/custom_outlined_button.dart';
import 'package:amber/widgets/profile_picture.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;
  const EditProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? file;
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    usernameController.text = widget.user.username;
    nameController.text = widget.user.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text(
          "Edit profile",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        leading: GestureDetector(
          child: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onTap: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            const SizedBox(height: 5),
            Center(
              child: GestureDetector(
                onTap: chooseImage,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: (file == null)
                      ? ProfilePicture(
                          side: 100,
                          image: widget.user.profilePhoto,
                        )
                      : ProfilePicture(
                          side: 100,
                          image: FileImage(file!),
                        ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: CustomFormField(
                controller: usernameController,
                icon: FontAwesomeIcons.at,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  } else if (!RegExp(
                          r'^(?=.{8,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$')
                      .hasMatch(value)) {
                    return 'Enter Valid Username';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: CustomFormField(
                icon: Icons.person,
                controller: nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  } else if (!RegExp(
                          r'^[A-Z][a-zA-Z]{3,}(?: [A-Z][a-zA-Z]*){0,2}$')
                      .hasMatch(value)) {
                    return 'Enter Valid Username';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: CustomOutlinedButton(
                buttonText: 'Save Profile',
                widthFactor: 0.9,
                onPress: () async {
                  if (_formKey.currentState!.validate()) {
                    Map<String, Object?> map = {};
                    if (file != null) {
                      map['profilePhotoURL'] = await uploadImage();
                      map['username'] = usernameController.text;
                      await DatabaseService.usersRef
                          .doc(widget.user.id)
                          .update(map);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Profile updated!")),
                      );
                    }
                  }
                },
              ),
              // child: ElevatedButton(
              //   onPressed: () async {
              //     if (_formKey.currentState!.validate()) {
              //       Map<String, Object?> map = {};
              //       if (file != null) {
              //         map['profilePhotoURL'] = await uploadImage();
              //         map['username'] = usernameController.text;
              //         await DatabaseService.usersRef
              //             .doc(widget.user.id)
              //             .update(map);
              //         ScaffoldMessenger.of(context).showSnackBar(
              //           const SnackBar(content: Text("Profile updated!")),
              //         );
              //       }
              //     }
              //   },
              //   child: const Text('Submit'),
              // ),
            ),
          ],
        ),
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
        .child('profile')
        .child(widget.user.id)
        .putFile(file!);

    return taskSnapshot.ref.getDownloadURL();
  }
}
