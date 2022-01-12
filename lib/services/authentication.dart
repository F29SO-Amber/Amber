import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login/flutter_login.dart';

class Authentication {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;
  static late User currentUser;

  static Future<String?> authUser(LoginData data) async {
    try {
      UserCredential authResult = await _auth.signInWithEmailAndPassword(
        email: data.name,
        password: data.password,
      );
      currentUser = authResult.user!;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  static Future<String?> signupUser(SignupData data) async {
    try {
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
        email: data.name!,
        password: data.password!,
      );
      currentUser = authResult.user!;

      Map<String, dynamic> map = {};
      map.addAll({
        'id': currentUser.uid,
        'email': '${data.name}',
        'time_created': Timestamp.now(),
        'profilePhotoURL':
            'https://firebasestorage.googleapis.com/v0/b/f29so-group-5-amber.appspot.com/o/profile%2Fcommon_profile_pic.jpeg?alt=media&token=1ffabf13-40e5-493e-ac53-e13656d3f430',
      });
      data.additionalSignupData?.forEach((key, value) {
        map.addAll({key: value});
      });
      _firestore.collection('users').doc(currentUser.uid).set(map);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
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
