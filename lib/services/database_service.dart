import 'package:amber/models/user.dart';
import 'package:amber/screens/login.dart';
import 'package:amber/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_login/flutter_login.dart';

class DatabaseService {
  static final _firestore = FirebaseFirestore.instance;
  static final usersRef = _firestore.collection('users');
  static final postsRef = _firestore.collection('posts');
  static final followersRef = _firestore.collection('followers');
  static final followingRef = _firestore.collection('following');
  static late String usernameresult;

  static Future<UserModel> getUser(String uid) async {
    return UserModel.fromDocument(await usersRef.doc(uid).get());
  }

  static Future<String?> isUserValueUnique(String username) async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('users').where('username', isEqualTo: username).get();

    LoginScreen.temp = snapshot.docs.isEmpty ? null : 'Nope';
  }

  static usernamechecker(username) async {
    try {
// if the size of value is greater then 0 then that doc exist.
      var a = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .get()
          .then((value) => value.size > 0 ? true : false);

      String b = a.toString();
      usernameresult = b;
      print(usernameresult);
    } catch (e) {
      print(e.toString());
    }
  }

  static addUserData(SignupData data) {
    Map<String, dynamic> map = {};
    map.addAll({
      'id': AuthService.currentUser.uid,
      'email': '${data.name}',
      'time_created': Timestamp.now(),
      'profilePhotoURL':
          'https://firebasestorage.googleapis.com/v0/b/f29so-group-5-amber.appspot.com/o/profile%2Fcommon_profile_pic.jpeg?alt=media&token=1ffabf13-40e5-493e-ac53-e13656d3f430',
    });
    data.additionalSignupData?.forEach((key, value) {
      map.addAll({key: value});
    });
    usersRef.doc(AuthService.currentUser.uid).set(map);
  }

  static addUserPost(String imageURL) {
    Map<String, dynamic> map = {};
    map.addAll({
      'id': '${AuthService.currentUser.uid}_${Timestamp.now()}',
      'imageUrl': imageURL,
      'caption': '',
      'score': 0,
      'authorId': AuthService.currentUser.uid,
      'timestamp': Timestamp.now(),
    });
    postsRef.doc('${AuthService.currentUser.uid}_${Timestamp.now()}').set(map);
  }
}
