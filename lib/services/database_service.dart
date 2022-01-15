import 'package:amber/models/user.dart';
import 'package:amber/screens/login.dart';
import 'package:amber/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  static final _firestore = FirebaseFirestore.instance;
  static CollectionReference usersRef = _firestore.collection('users');
  static CollectionReference postsRef = _firestore.collection('posts');
  static late String usernameresult;

  static Future<UserModel> getUser(String uid) async {
    DocumentSnapshot doc = await usersRef.doc(uid).get();
    return UserModel.fromDocument(doc);
  }

  static Future<String?> isUserValueUnique(String username) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('users')
        .where('username', isEqualTo: username)
        .get();

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

  static addUserPost(String imageURL) {
    Map<String, dynamic> map = {};
    map.addAll({
      'id': '${Authentication.currentUser.uid}_${Timestamp.now()}',
      'imageUrl': imageURL,
      'caption': '',
      'score': 0,
      'authorId': Authentication.currentUser.uid,
      'timestamp': Timestamp.now(),
    });
    _firestore
        .collection('posts')
        .doc('${Authentication.currentUser.uid}_${Timestamp.now()}')
        .set(map);
  }
}
