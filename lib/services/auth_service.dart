import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:amber/services/database_service.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static late User currentUser;

  static easySignIn() async {
    try {
      UserCredential authResult = await _auth.signInWithEmailAndPassword(
        email: 'f29so-group5@gmail.com',
        password: '1234567',
      );
      currentUser = authResult.user!;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
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

      DatabaseService.addUserData(data);
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
