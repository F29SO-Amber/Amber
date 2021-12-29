import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

const String kAppName = 'ᗩмвєя';

final LoginTheme kLoginTheme = LoginTheme(
  primaryColor: const Color(0xffFFBF00),
  accentColor: Colors.white,
  errorColor: Colors.red,
  buttonStyle: const TextStyle(color: Colors.black54),
  cardTheme: CardTheme(
    color: Colors.white,
    elevation: 5,
    margin: const EdgeInsets.only(top: 15),
    shape: ContinuousRectangleBorder(
      borderRadius: BorderRadius.circular(100.0),
    ),
  ),
  inputTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xffFFBF00).withOpacity(.2),
    contentPadding: EdgeInsets.zero,
  ),
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
