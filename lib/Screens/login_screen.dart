import 'package:amber/Screens/profile_screen.dart';
import 'package:amber/authentication.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:amber/constants.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const id = '/auth';

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: kAppName,
      logo: const AssetImage('assets/logo.png'),
      onLogin: AuthenticationHelper.authUser,
      onSignup: AuthenticationHelper.signupUser,
      onRecoverPassword: AuthenticationHelper.recoverPassword,
      loginAfterSignUp: false,
      theme: kLoginTheme,
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
        String pattern =
            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
        RegExp exp = new RegExp(pattern);
        if (!exp.hasMatch(value!)) {
          return "Use Uppercase, Lowercase, Digits and Symbols";
        }

        if (value.length < 7) {
          return "Password should have at least 7 characters.";
        }
      },
    );
  }
}
