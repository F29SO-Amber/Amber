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
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: createRandomColor(),
  //     body: Center(
  //       child: ElevatedButton(
  //         child: const Text('Sign Out'),
  //         onPressed: () {
  //           AuthenticationHelper.signOutUser();
  //           Navigator.of(context, rootNavigator: true).pushReplacement(
  //               MaterialPageRoute(builder: (context) => new LoginScreen()));
  //         },
  //         style: ElevatedButton.styleFrom(
  //           primary: Colors.amber, // background
  //           onPrimary: Colors.black, // foreground
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '@username',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        actions: [
          GestureDetector(
            child: const Icon(Icons.logout_outlined),
            onTap: () {
              AuthenticationHelper.signOutUser();
              Navigator.of(context, rootNavigator: true).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
        backgroundColor: kAppColor,
      ),
    );
  }
}
