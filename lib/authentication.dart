import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_login/flutter_login.dart';

class AuthenticationHelper {
  static final _auth = FirebaseAuth.instance;

  static Future<String?> authUser(LoginData data) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: data.name,
        password: data.password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  static Future<String?> signupUser(SignupData data) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: data.name!,
        password: data.password!,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  static Future<String?> recoverPassword(String email) async {
    return Future.delayed(Duration(milliseconds: 2250)).then((_) async{
     await _auth.sendPasswordResetEmail(email: email);
    });
  }

  static Future<String?> signOutUser() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
