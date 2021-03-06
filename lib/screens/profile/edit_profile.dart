import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:amber/models/user.dart';
import 'package:amber/services/image_service.dart';
import 'package:amber/widgets/profile_picture.dart';
import 'package:amber/services/storage_service.dart';
import 'package:amber/services/database_service.dart';
import 'package:amber/widgets/custom_form_field.dart';
import 'package:amber/widgets/custom_outlined_button.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;

  const EditProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

/*
  Edit Profile page will allow the user to change/edit their current details
*/
class _EditProfileScreenState extends State<EditProfileScreen> {
  File? file;
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    usernameController.text = widget.user.username;
    nameController.text = widget.user.firstName;
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    usernameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text("Edit profile", style: TextStyle(fontSize: 18, color: Colors.white)),
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
              //Edit Profile Picture
              child: GestureDetector(
                onTap: () async {
                  file = await ImageService.chooseFromGallery();
                  if (file != null) {
                    setState(() {});
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: (file == null)
                      ? CustomImage(side: 100, image: NetworkImage(widget.user.imageUrl))
                      : CustomImage(side: 100, image: FileImage(file!)),
                ),
              ),
            ),
            Padding(
              //Edit Username
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: CustomFormField(
                controller: usernameController,
                icon: FontAwesomeIcons.at,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  } else if (!RegExp(r'^(?=.{4,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$')
                      .hasMatch(value)) {
                    return 'Enter Valid Username';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              //Edit Name
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: CustomFormField(
                icon: Icons.person,
                controller: nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  } else if (!RegExp(r'^[A-Z][a-zA-Z]{3,}(?: [A-Z][a-zA-Z]*){0,2}$')
                      .hasMatch(value)) {
                    return 'Enter Valid Username';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              //Save the new details
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: CustomOutlinedButton(
                buttonText: 'Save Profile',
                widthFactor: 0.9,
                onPress: () async {
                  if (_formKey.currentState!.validate()) {
                    Map<String, Object?> map = {};
                    if (file != null) {
                      map['imageUrl'] =
                          await StorageService.uploadImage(widget.user.id, file!, 'profile');
                    }
                    map['name'] = nameController.text;
                    map['username'] = usernameController.text;
                    await DatabaseService.usersRef.doc(widget.user.id).update(map);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Profile updated!")),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
