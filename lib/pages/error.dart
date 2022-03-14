import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:amber/utilities/constants.dart';

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
        color: const Color(0xfff0c722),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TopAnime(
              1,
              10,
              curve: Curves.fastOutSlowIn,
              child: Lottie.asset('assets/404-error-robot.json', animate: true),
            ),
            TopAnime(
              2,
              5,
              curve: Curves.fastOutSlowIn,
              child: Column(
                children: [
                  const Text(
                    "TRY AGAIN LATER",
                    style: TextStyle(
                      fontSize: 45,
                      fontFamily: 'FiraSans',
                      color: Color(0xfffdfdfd),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: Text(
                      "The page you are looking for was moved, removed renamed or might never have existed.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.normal,
                        fontSize: 18,
                        color: const Color(0xfffdfdfd),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TopAnime extends StatelessWidget {
  Widget? child;
  Curve? curve;
  int seconds;
  int topPadding;

  TopAnime(this.seconds, this.topPadding, {Key? key, required this.child, this.curve})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
        child: child,
        tween: Tween<double>(begin: 0, end: 1),
        duration: Duration(seconds: seconds),
        curve: curve ?? Curves.bounceIn,
        builder: (BuildContext context, double value, child) {
          return Opacity(
            opacity: value,
            child: Padding(
              padding: EdgeInsets.only(top: value * topPadding),
              child: this.child,
            ),
          );
        });
  }
}

class BottomAnime extends StatelessWidget {
  Widget? child;
  Curve? curve;
  int seconds;
  int topPadding;

  BottomAnime(this.seconds, this.topPadding, {required this.child, this.curve});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
        child: child,
        tween: Tween<double>(begin: 0, end: 1),
        curve: curve ?? Curves.bounceIn,
        duration: Duration(seconds: seconds),
        builder: (BuildContext context, double value, child) {
          return Opacity(
            opacity: value,
            child: Padding(
              padding: EdgeInsets.only(bottom: value * topPadding),
              child: this.child,
            ),
          );
        });
  }
}
