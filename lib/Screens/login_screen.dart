import 'package:amber/Screens/profile_screen.dart';
import 'package:amber/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

class LoginScreen extends StatelessWidget {
  static const id = '/auth';

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'ᗩмвєя',
      logo: const AssetImage('assets/logo.png'),
      onLogin: AuthenticationHelper.authUser,
      onSignup: AuthenticationHelper.signupUser,
      onRecoverPassword: AuthenticationHelper.recoverPassword,
      loginAfterSignUp: false,
      theme: LoginTheme(
        primaryColor: Color(0xffFFBF00),
        accentColor: Colors.white,
        errorColor: Colors.red,
        buttonStyle: TextStyle(color: Colors.black54),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 5,
          margin: EdgeInsets.only(top: 15),
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(100.0),
          ),
        ),
        inputTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xffFFBF00).withOpacity(.2),
          contentPadding: EdgeInsets.zero,
        ),
      ),
      onSubmitAnimationCompleted: () {
        Navigator.pushReplacementNamed(context, ProfilePage.id);
      },
      // onRecoverPassword: (String) {},
    );
  }
}
