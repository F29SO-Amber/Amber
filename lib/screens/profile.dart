import 'package:flutter/material.dart';
import 'package:amber/constants.dart';

import 'package:amber/services/authentication.dart';
import 'package:amber/screens/login.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  static const id = '/profile';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: createRandomColor(),
      body: Center(
        child: ElevatedButton(
          child: const Text('Sign Out'),
          onPressed: () {
            AuthenticationHelper.signOutUser();
            Navigator.pushReplacementNamed(context, LoginScreen.id);
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.amber, // background
            onPrimary: Colors.black, // foreground
          ),
        ),
      ),
    );
  }
}
