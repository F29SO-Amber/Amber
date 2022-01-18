import 'package:amber/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:email_validator/email_validator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:amber/utilities/constants.dart';
import 'package:amber/screens/main_screen.dart';
import 'package:amber/services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  static const id = '/auth';
  String usernameTest = '';
  static String? temp;

  // Future<String?> validateUsername(String? value) async {
  //   return await FirebaseFirestore.instance
  //       .collection('users')
  //       .where('username', isEqualTo: value)
  //       .get()
  //       .then((value) => value.size > 0 ? "Nope" : null);
  // }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: kAppName,
      logo: const AssetImage('assets/logo.png'),
      loginAfterSignUp: false,
      theme: kLoginTheme,
      onLogin: AuthService.authUser,
      onSignup: AuthService.signupUser,
      onRecoverPassword: AuthService.recoverPassword,
      messages: LoginMessages(signUpSuccess: "Sign up successful!"),
      additionalSignupFields: [
        UserFormField(
          keyName: 'username',
          displayName: 'Username',
          icon: const Icon(FontAwesomeIcons.at),
          fieldValidator: (value) {
            // try {
            //   DatabaseService.usernamechecker(value);
            //   if (DatabaseService.usernameresult != "false") {
            //     DatabaseService.usernameresult = "0";
            //     return 'Username already exists';
            //   }
            // } finally {
            //   print(DatabaseService.usernameresult);
            // }
            // try {
            //   DatabaseService.isUserValueUnique(value!);
            //   return temp;
            // } catch (e) {
            //   print(e);
            // }
          },
        ),
        const UserFormField(
          keyName: 'name',
          displayName: 'Name',
          icon: Icon(FontAwesomeIcons.solidUser),
        ),
        UserFormField(
          keyName: 'account_type',
          displayName: 'Account Type',
          icon: const Icon(FontAwesomeIcons.artstation),
          fieldValidator: (value) {
            RegExp regExp = RegExp(r"^(Artist|Business|Personal)", caseSensitive: false);
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
            RegExp regExp = RegExp(
                r"^(?:(?:31(\/|-|\.)(?:0?[13578]|1[02]))\1|(?:(?:29|30)(\/|-|\.)(?:0?[13-9]|1[0-2])\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(\/|-|\.)0?2\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.)(?:(?:0?[1-9])|(?:1[0-2]))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$",
                caseSensitive: true,
                multiLine: false);
            if (!regExp.hasMatch(value!)) {
              return "Use dd.mm.yyyy, dd/mm/yyyy, dd-mm-yyyy";
            }
          },
        ),
      ],
      onSubmitAnimationCompleted: () {
        Navigator.pushReplacementNamed(context, MainScreen.id);
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
