import 'package:amber/authentication.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);
  static const id = '/profile';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: GestureDetector(
            child: const Text('Sign out!!'),
            onTap: () {
              AuthenticationHelper.signOutUser();
              Navigator.pushReplacementNamed(context, LoginScreen.id);
            },
          ),
        ),
      ),
    );
  }
}
