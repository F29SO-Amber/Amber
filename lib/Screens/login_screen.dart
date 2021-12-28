import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

class LoginScreen extends StatelessWidget {
  static const id = '/auth';

  Future<String?> _authUser(LoginData data) {
    return Future.delayed(Duration(milliseconds: 2250)).then((_) {
      return null;
    });
  }

  Future<String?> _signupUser(SignupData data) {
    return Future.delayed(Duration(milliseconds: 2250)).then((_) {
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'AMBER',
      logo: const AssetImage('assets/logo.webp'),
      onLogin: _authUser,
      onSignup: _signupUser,
      loginAfterSignUp: false,
      onRecoverPassword: (String) {},
      onSubmitAnimationCompleted: () {},
    );
  }
}
