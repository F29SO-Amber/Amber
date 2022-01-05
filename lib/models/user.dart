import 'package:cloud_firestore/cloud_firestore.dart';

class AmberUser {
  final String id;
  final String name;
  final String email;
  final String username;
  final String dob;
  final String gender;
  final String accountType;
  final Timestamp timeCreated;
  final String profilePhotoURL;
  //final Map followers;
  //final Map following;

  const AmberUser({
    required this.id,
    required this.name,
    required this.email,
    required this.username,
    required this.dob,
    required this.gender,
    required this.accountType,
    required this.timeCreated,
    required this.profilePhotoURL,
    // required this.followers,
    //required this.following
  });

  factory AmberUser.fromDocument(DocumentSnapshot doc) {
    return AmberUser(
      id: doc.id,
      name: doc['name'],
      email: doc['email'],
      username: doc['username'],
      dob: doc['dob'],
      gender: doc['gender'],
      accountType: doc['account_type'],
      timeCreated: doc['time_created'],
      profilePhotoURL: doc['profilePhotoURL'],
      // followers: doc['followers'],
      // following: doc['following'],
    );
  }
}
