import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String username;
  final String dob;
  final String accountType;
  final Timestamp timeCreated;
  final String profilePhotoURL;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.username,
    required this.dob,
    required this.accountType,
    required this.timeCreated,
    required this.profilePhotoURL,
  });

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
      id: doc.id,
      name: doc['name'],
      email: doc['email'],
      username: doc['username'],
      dob: doc['dob'],
      accountType: doc['account_type'],
      timeCreated: doc['time_created'],
      profilePhotoURL: doc['profilePhotoURL'],
    );
  }
}
