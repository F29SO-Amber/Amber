import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

class LoginScreen extends StatelessWidget {
  static const id = '/auth';
  final _auth = FirebaseAuth.instance;

  Future<String?> _authUser(LoginData data) {
    return Future.delayed(Duration(milliseconds: 2250)).then((_) async {
      try {
        final User = _auth.signInWithEmailAndPassword(
            email: data.name, password: data.password);
      } catch (e) {
        print(e);
      }
    });
  }

  Future<String?> _signupUser(SignupData data) {
    return Future.delayed(Duration(milliseconds: 2250)).then((_) async {
      try {
        final newUser = await _auth.createUserWithEmailAndPassword(
            email: data.name!, password: data.password!);
      } catch (e) {
        print(e);
      }
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
