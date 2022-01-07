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

  Future<String?> isUserValueUnique(String email) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    List<QueryDocumentSnapshot> docs = snapshot.docs;
    for (var doc in docs) {
      if (doc.data() != null) {
        var data = doc.data() as Map<String, dynamic>;
        var name = data['email']; // You can get other data in this manner.
        print(name);
      }
    }

    return snapshot.docs.isEmpty ? 'null' : 'Nope';
  }
}
