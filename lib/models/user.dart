import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  //final String id;
  //final String email;
  final String username;
  final String name;
  final String accountType;
  final String dob;
  final String gender;
  //final String photoURL;
  //final Map followers;
  //final Map following;

  const Users(
      {required this.dob,
      required this.gender,
      required this.accountType,
      required this.username,
     // required this.id,
      //required this.photoURL,
      //required this.email,
      required this.name,
     // required this.followers,
      //required this.following
      });

      factory Users.fromDocument(DocumentSnapshot doc) {
    return Users(
      //email: doc['email'],
      username: doc['username'],
      name: doc['name'],
      accountType: doc['account_type'],
      dob: doc['dob'],
      gender: doc['gender'],
      //photoURL: doc['photoURL'],
     // followers: doc['followers'],
     // following: doc['following'],
      //id: doc['id'],
    );
  }
}
