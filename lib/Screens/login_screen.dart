import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_login/flutter_login.dart';

import 'package:amber/Screens/profile_screen.dart';
import 'package:amber/authentication.dart';
import 'package:amber/constants.dart';

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
      onLogin: AuthenticationHelper.authUser,
      onSignup: AuthenticationHelper.signupUser,
      onRecoverPassword: AuthenticationHelper.recoverPassword,
      messages: LoginMessages(
        signUpSuccess: "Sign up successful!",
      ),
      onSubmitAnimationCompleted: () {
        Navigator.pushReplacementNamed(context, ProfilePage.id);
      },
      userValidator: (value) {
        if (!EmailValidator.validate(value!)) {
          return "Enter a valid Email";
        }
      },
      passwordValidator: (value) {
        RegExp exp = RegExp(
            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
        if (!exp.hasMatch(value!)) {
          return "Use Uppercase, Lowercase, Digits and Symbols";
        }
        if (value.trim().isEmpty || value.length < 7) {
          return "Password should have at least 7 characters.";
        }
      },
    );
  }
}
