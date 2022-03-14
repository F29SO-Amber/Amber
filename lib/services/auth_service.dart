import 'package:amber/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:amber/services/database_service.dart';
import 'package:hive/hive.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static late User currentUser;

  static Future<String?> authUser(LoginData data) async {
    try {
      UserCredential authResult = await _auth.signInWithEmailAndPassword(
        email: data.name,
        password: data.password,
      );
      // await Hive.openBox('user');
      // Hive.box('user').put('status', 'logged-in');
      // Hive.box('user').put('email', data.name);
      // Hive.box('user').put('password', data.password);
      currentUser = authResult.user!;
      UserData.currentUser = await DatabaseService.getUser(currentUser.uid);
      return null;
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
      // await Hive.openBox('user');
      // Hive.box('user').put('email', data.name!);
      // Hive.box('user').put('password', data.password!);
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
      // await Hive.openBox('user');
      // Hive.box('user').put('status', 'logged-out');
      // Hive.close();
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
