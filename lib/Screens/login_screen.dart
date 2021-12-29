import 'package:amber/Screens/profile_screen.dart';
import 'package:amber/authentication.dart';
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
        // TODO: by John
        return null;
      },
      passwordValidator: (value) {
        // TODO: by John
        return null;
      },
    );
  }
}
