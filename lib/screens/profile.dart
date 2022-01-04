import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:amber/constants.dart';

import 'package:amber/services/authentication.dart';
import 'package:amber/screens/login.dart';
import 'package:google_fonts/google_fonts.dart';

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
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Icon(
                Icons.logout_outlined,
                color: Colors.white,
              ),
            ),
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
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 20),
                child: Container(
                  height: 100.0,
                  width: 100.0,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/logo.png'),
                      fit: BoxFit.fill,
                    ),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(33.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 3.0),
              child: Text(
                'Carlos Fernandez',
                style: GoogleFonts.dmSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Student',
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  color: Colors.black38,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      '140',
                      style: GoogleFonts.dmSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    Text(
                      'Posts',
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        color: Colors.black38,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '524',
                      style: GoogleFonts.dmSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    Text(
                      'Followers',
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        color: Colors.black38,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '343',
                      style: GoogleFonts.dmSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    Text(
                      'Following',
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        color: Colors.black38,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      ),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 20,
              width: 200,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    child: const Text('   Message   '),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white, // background
                      onPrimary: Colors.black, // foreground
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: () {},
                  ),
                  // SizedBox(
                  //   width: 10.0,
                  // ),
                  ElevatedButton(
                    child: const Text('    Follow    '),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.amber, // background
                        onPrimary: Colors.black, // foreground
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                    onPressed: () {},
                  ),
                ]),
            SizedBox(
              height: 20,
              width: 200,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: 35,
                    width: 200,
                    child: TextButton(
                      child: Icon(Icons.camera_alt),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red[100], // background
                        onPrimary: Colors.black, // foreground
                      ),
                      onPressed: () {},
                    ),
                  ),
                  // SizedBox(
                  //   width: 10.0,
                  // ),
                  SizedBox(
                    height: 35,
                    width: 190,
                    child: TextButton(
                      child: Icon(Icons.play_arrow_rounded),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.greenAccent[100], // background
                        onPrimary: Colors.black, // foreground
                      ),
                      onPressed: () {},
                    ),
                  ),
                ]),
          ],
        ),
      ),
    );
  }
}
