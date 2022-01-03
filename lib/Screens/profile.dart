import 'package:amber/authentication.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'dart:math' as math;

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);
  static const id = '/profile';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
            .withOpacity(1.0),
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
      ),
    );
  }
}
