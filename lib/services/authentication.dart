import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login/flutter_login.dart';

class Authentication {
  static final auth = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;
  static late User currentUser;

  static Future<String?> authUser(LoginData data) async {
    try {
      UserCredential authResult = await auth.signInWithEmailAndPassword(
        email: data.name,
        password: data.password,
      );
      // List<String> list =
      //     await auth.fetchSignInMethodsForEmail('am2023@hw.ac.uk');
      // print(list.toString());
      currentUser = authResult.user!;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

//   static usernamechecker(username) async {
//     try {
// // if the size of value is greater then 0 then that doc exist.
//       await FirebaseFirestore.instance
//           .collection('users')
//           .where('username', isEqualTo: username)
//           .get()
//           .then((value) => value.size > 0 ? true : false);
//     } catch (e) {
//       print(e.toString());
//     }
//   }

  static Future<String?> signupUser(SignupData data) async {
    try {
      UserCredential authResult = await auth.createUserWithEmailAndPassword(
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
      // var val = usernamechecker(map["username"]);
      // //remove this if case for firestore to work, im not sure how to fix it :(
      // if (val = false) {
      _firestore.collection('users').doc(currentUser.uid).set(map);
      // } else {
      //   return "Username already exists";
      // }
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  static Future<String?> recoverPassword(String email) async {
    await auth.sendPasswordResetEmail(email: email);
    try {
      await auth.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  static Future<String?> signOutUser() async {
    try {
      await auth.signOut();
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
