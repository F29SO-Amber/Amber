import 'package:amber/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login/flutter_login.dart';

class Authentication {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;
  static late User currentUser;
  static CollectionReference usersRef = _firestore.collection('users');

  static Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  static Future<AmberUser> getUser(String uid) async {
    DocumentSnapshot doc = await usersRef.doc(uid).get();
    return AmberUser.fromDocument(doc);
  }

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
        'profilePhotoURL': '',
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
