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
