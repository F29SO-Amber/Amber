import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_login/flutter_login.dart';
import 'dart:ui';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

const String kAppName = 'ᗩмвєя';
const Color kAppColor = Colors.amber;

const colors = [
  Color(0xffff6767),
  Color(0xff66e0da),
  Color(0xfff5a2d9),
  Color(0xfff0c722),
  Color(0xff6a85e5),
  Color(0xfffd9a6f),
  Color(0xff92db6e),
  Color(0xff73b8e5),
  Color(0xfffd7590),
  Color(0xffc78ae5),
];

Color getUserAvatarNameColor(types.User user) {
  final index = user.id.hashCode % colors.length;
  return colors[index];
}

String getUserName(types.User user) => '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim();

final LoginTheme kLoginTheme = LoginTheme(
  primaryColor: const Color(0xffFFBF00),
  accentColor: Colors.white,
  errorColor: Colors.red,
  buttonStyle: const TextStyle(color: Colors.black54),
  cardTheme: CardTheme(
    color: Colors.white,
    elevation: 5,
    margin: const EdgeInsets.only(top: 15),
    shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
  ),
  inputTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xffFFBF00).withOpacity(.2),
    contentPadding: EdgeInsets.zero,
  ),
);

final kAppBar = AppBar(
  backgroundColor: kAppColor,
  title: const Text(kAppName),
  titleTextStyle: const TextStyle(color: Colors.white, letterSpacing: 3, fontSize: 25.0),
);

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  final swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

Color createRandomColor() {
  return Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
}

final TextStyle kDarkLabelTextStyle = GoogleFonts.dmSans(
  fontSize: 20,
  fontWeight: FontWeight.w500,
  fontStyle: FontStyle.normal,
);

final TextStyle kLightLabelTextStyle = GoogleFonts.dmSans(
  fontSize: 13,
  color: Colors.black38,
  fontWeight: FontWeight.w500,
  fontStyle: FontStyle.normal,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);
