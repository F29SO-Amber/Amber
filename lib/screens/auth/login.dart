import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:email_validator/email_validator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:amber/screens/home.dart';
import 'package:amber/utilities/constants.dart';
import 'package:amber/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  static const id = '/auth';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Hive.openBox('user'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Box box = snapshot.data as Box;
          return FlutterLogin(
            title: kAppName,
            logo: const AssetImage('assets/logo/logo.png'),
            loginAfterSignUp: false,
            theme: kLoginTheme,
            onLogin: AuthService.authUser,
            onSignup: AuthService.signupUser,
            savedEmail: box.get('email') ?? '',
            savedPassword: box.get('password') ?? '',
            onRecoverPassword: AuthService.recoverPassword,
            messages: LoginMessages(signUpSuccess: "Sign up successful!"),
            additionalSignupFields: [
              const UserFormField(
                // TODO: Only allow unique username
                keyName: 'username',
                displayName: 'Username',
                icon: Icon(FontAwesomeIcons.at),
              ),
              const UserFormField(
                keyName: 'firstName',
                displayName: 'Name',
                icon: Icon(FontAwesomeIcons.solidUser),
              ),
              UserFormField(
                keyName: 'account_type',
                displayName: 'Account Type',
                icon: const Icon(FontAwesomeIcons.artstation),
                fieldValidator: (value) {
                  RegExp regExp = RegExp(
                      r"^(Artist|Student|Content Creator|Brand Marketer|Personal)",
                      caseSensitive: false);
                  if (!regExp.hasMatch(value!)) {
                    return "Accounts should be Artist, Student, Content Creator, Brand Marketer or Personal";
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
              Navigator.pushReplacementNamed(context, HomePage.id);
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
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class PWValidator {
  static bool validatePassword(String pass) {
    RegExp exp = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    return exp.hasMatch(pass) ? true : false;
  }

  static bool validateAccount(String acc) {
    RegExp exp =
        RegExp(r"^(Artist|Student|Content Creator|Brand Marketer|Personal)", caseSensitive: false);
    return exp.hasMatch(acc) ? true : false;
  }

  static bool validateDOB(String dob) {
    RegExp exp = RegExp(
        r"^(?:(?:31(\/|-|\.)(?:0?[13578]|1[02]))\1|(?:(?:29|30)(\/|-|\.)(?:0?[13-9]|1[0-2])\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(\/|-|\.)0?2\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.)(?:(?:0?[1-9])|(?:1[0-2]))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$",
        caseSensitive: true,
        multiLine: false);
    return exp.hasMatch(dob) ? true : false;
  }
}
