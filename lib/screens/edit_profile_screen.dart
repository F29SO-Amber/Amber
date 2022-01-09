import 'package:amber/models/user.dart';
import 'package:amber/screens/profile_screen/widgets/custom_outlined_button.dart';
import 'package:amber/screens/profile_screen/widgets/profile_picture.dart';
import 'package:amber/screens/profile_screen/widgets/progress.dart';
import 'package:amber/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  final String currentUserID;

  const EditProfilePage({Key? key, required this.currentUserID})
      : super(key: key);
  static const id = '/edit_profile';
  // const EditProfilePage({required this.currentUserID});
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController displayUsernameController = TextEditingController();
  late AmberUser user;
  bool isLoading = false;
  bool _displayNameValid = true;
  bool _usernameValid = true;

  @override
  void initState() {
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
    displayUsernameController.text = user.username;
    setState(() {
      isLoading = false;
    });
  }

  Column buildDisplayNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextField(
          controller: displayUsernameController,
          //textAlign: TextAlign.left,
          decoration: InputDecoration(
            labelText: 'Username',
            prefixIcon: const Icon(Icons.person, color: Colors.amber),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(90.0)),
              borderSide: BorderSide(width: 2, color: Colors.amber),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(90.0)),
              //borderSide: BorderSide.none,
              borderSide: BorderSide(width: 2, color: Colors.grey),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(90.0)),
              borderSide: BorderSide(width: 2, color: Colors.grey),
            ),
            filled: true,
            fillColor: Colors.amber.shade50,
            hintText: 'Update Username',
            errorText: _usernameValid ? null : "Username invalid or taken",
          ),
          onChanged: (value) {
            setState(() {
              isUsernameValid(value);
            });
          },
        ),
      ],
    );
  }

  Future<void> isUsernameValid(value) async {
    _usernameValid = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: value)
        .get()
        .then((value) => value.size > 0 ? false : true);
  }

  updateProfileData() {
    // setState(() {
    //   displayUsernameController.text.trim().length < 3 ||
    //           displayUsernameController.text.isEmpty
    //       ? _displayNameValid = false
    //       : _displayNameValid = true;
    // });
    if (_usernameValid) {
      DatabaseService.usersRef.doc(widget.currentUserID).update({
        "username": displayUsernameController.text,
      });
      SnackBar snackbar = const SnackBar(content: Text("Profile updated!"));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text(
          "Edit profile",
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
        actions: <Widget>[
          IconButton(
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
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          buildDisplayNameField(),
                        ],
                      ),
                    ),
                    // CustomOutlinedButton(
                    //   buttonText: 'Update Profile',
                    //   widthFactor: 0.90,
                    //   onPress: updateProfileData,
                    // ),
                    ElevatedButton(
                      onPressed: updateProfileData,
                      child: Text(
                        "Update Profile",
                        style: TextStyle(
                          //     color: Colors.black,
                          fontSize: 15.0,
                          //     fontWeight: FontWeight.bold),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(
                              MediaQuery.of(context).size.width * 0.65, 43),
                          primary: Colors.amber.shade300, // background
                          onPrimary: Colors.black, // foreground
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(90.0))),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
