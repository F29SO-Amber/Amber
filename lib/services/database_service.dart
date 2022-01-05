import 'package:amber/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;
  static CollectionReference usersRef = _firestore.collection('users');

  static Future<AmberUser> getUser(String uid) async {
    DocumentSnapshot doc = await usersRef.doc(uid).get();
    return AmberUser.fromDocument(doc);
  }
}
