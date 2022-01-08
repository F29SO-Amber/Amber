import 'package:amber/models/user.dart';
import 'package:amber/screens/profile_screen/widgets/custom_outlined_button.dart';
import 'package:amber/screens/profile_screen/widgets/profile_picture.dart';
import 'package:amber/screens/profile_screen/widgets/progress.dart';
import 'package:amber/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  final String currentUserID;

  const EditProfilePage({Key? key, required this.currentUserID})
      : super(key: key);
  static const id = '/edit_profile';
  // EditProfilePage({required this.currentUserID});
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController displayNameController = TextEditingController();
  late AmberUser user;
  bool isLoading = false;
  bool _displayNameValid = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  getUser() async {
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot doc =
        await DatabaseService.usersRef.doc(widget.currentUserID).get();
    user = AmberUser.fromDocument(doc);
    displayNameController.text = user.username;
    setState(() {
      isLoading = false;
    });
  }

  Column buildDisplayNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text(
            "Username",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextField(
          controller: displayNameController,
          decoration: InputDecoration(
            hintText: "Update Display Name ",
            errorText: _displayNameValid ? null : "Username too short!",
          ),
        ),
      ],
    );
  }

  updateProfileData() {
    setState(() {
      displayNameController.text.trim().length < 3 ||
              displayNameController.text.isEmpty
          ? _displayNameValid = false
          : _displayNameValid = true;
    });
    if (_displayNameValid) {
      DatabaseService.usersRef.doc(widget.currentUserID).update({
        "name": displayNameController.text,
      });
      SnackBar snackbar = const SnackBar(content: Text("Profile updated!"));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text(
          "Edit profile",
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
        actions: <Widget>[
          IconButton(
            //onPressed: onPressed,
            icon: const Icon(Icons.done, color: Colors.green, size: 30.0),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: isLoading
          ? circularProgress()
          : ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(top: 25.0),
                      child: ProfilePicture(
                        pathToImage: 'assets/img.png',
                        side: 90,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          buildDisplayNameField(),
                        ],
                      ),
                    ),
                    CustomOutlinedButton(
                      buttonText: 'Update Profile',
                      widthFactor: 0.90,
                      onPress: updateProfileData,
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
