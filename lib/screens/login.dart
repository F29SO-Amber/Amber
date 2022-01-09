import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:email_validator/email_validator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:amber/constants.dart';
import 'package:amber/screens/navbar.dart';
import 'package:amber/services/authentication.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const id = '/auth';

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: kAppName,
      logo: const AssetImage('assets/logo.png'),
      loginAfterSignUp: false,
      theme: kLoginTheme,
      onLogin: Authentication.authUser,
      onSignup: Authentication.signupUser,
      onRecoverPassword: Authentication.recoverPassword,
      messages: LoginMessages(signUpSuccess: "Sign up successful!"),
      additionalSignupFields: [
        UserFormField(
            keyName: 'username',
            displayName: 'Username',
            icon: Icon(FontAwesomeIcons.at),
            fieldValidator: (value) {
              try {
                Authentication.usernamechecker(value);
              } finally {
                print(Authentication.usernameresult);
                if (Authentication.usernameresult != "false") {
                  Authentication.usernameresult = "0";
                  return 'Username already exists';
                }
              }
            }),
        const UserFormField(
          keyName: 'name',
          displayName: 'Name',
          icon: const Icon(FontAwesomeIcons.solidUser),
        ),
        UserFormField(
          keyName: 'account_type',
          displayName: 'Account Type',
          icon: const Icon(FontAwesomeIcons.artstation),
          fieldValidator: (value) {
            RegExp regExp =
                RegExp(r"^(Artist|Business|Personal)", caseSensitive: false);
            if (!regExp.hasMatch(value!)) {
              return "Accounts should be Artist, Business or Personal";
            }
          },
        ),
        UserFormField(
          keyName: 'dob',
          displayName: 'Date Of Birth',
          icon: const Icon(FontAwesomeIcons.calendarAlt),
          fieldValidator: (value) {
            // ignore: unnecessary_new
            RegExp regExp = new RegExp(
                r"^(?:(?:31(\/|-|\.)(?:0?[13578]|1[02]))\1|(?:(?:29|30)(\/|-|\.)(?:0?[13-9]|1[0-2])\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(\/|-|\.)0?2\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.)(?:(?:0?[1-9])|(?:1[0-2]))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$",
                caseSensitive: true,
                multiLine: false);
            if (!regExp.hasMatch(value!)) {
              return "Use dd.mm.yyyy, dd/mm/yyyy, dd-mm-yyyy";
            }
          },
        ),
        const UserFormField(
          keyName: 'gender',
          displayName: 'Gender',
          icon: const Icon(FontAwesomeIcons.atom),
        ),
      ],
      onSubmitAnimationCompleted: () {
        Navigator.pushReplacementNamed(context, ConvexAppBarDemo.id);
      },
      userValidator: (value) {
        if (!EmailValidator.validate(value!)) {
          return "Enter a valid Email";
        }
      },
      passwordValidator: (value) {
        // RegExp exp = RegExp(
        //     r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
        // if (!exp.hasMatch(value!)) {
        //   return "Use Uppercase, Lowercase, Digits and Symbols";
        // }
        // if (value.trim().isEmpty || value.length < 7) {
        //   return "Password should have at least 7 characters.";
        // }
      },
    );
  }
}
