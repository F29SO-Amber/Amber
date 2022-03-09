import 'package:flutter/material.dart';
import 'package:amber/pages/animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:amber/utilities/constants.dart';
import 'package:amber/pages/settings.dart';
import 'package:lottie/lottie.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '404 Error',
      home: ErrorScreen(),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(kAppName),
        titleTextStyle: const TextStyle(color: Colors.white, letterSpacing: 3, fontSize: 25.0),
        backgroundColor: kAppColor,
      ),
      body: Container(
        width: currentWidth,
        height: currentHeight,
        color: Color(0xfff0c722),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TopAnime(
              1,
              10,
              curve: Curves.fastOutSlowIn,
              child: Lottie.asset('assets/404-error-robot.json', animate: false),
            ),
            TopAnime(
              2,
              5,
              curve: Curves.fastOutSlowIn,
              child: Container(
                child: Column(
                  children: [
                    Text(
                      "PAGE NOT FOUND",
                      style: TextStyle(
                        fontSize: 45,
                        fontFamily: 'FiraSans',
                        color: Color(0xfffdfdfd),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Text(
                        "The page you are looking for was moved, removed renamed or might never existed.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.normal,
                          fontSize: 18,
                          color: Color(0xfffdfdfd),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
