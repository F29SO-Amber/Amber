import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_login/flutter_login.dart';

class AuthenticationHelper {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;

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
    } finally {
      Map<String, String> map = {};
      map.addAll({'email': '${data.name}'});
      data.additionalSignupData?.forEach((key, value) {
        map.addAll({key: value});
      });
      _firestore.collection('users').add(map);
    }
  }

  static Future<String?> recoverPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  static Future<String?> signOutUser() async {
    try {
      await _auth.signOut();
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
