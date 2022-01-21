import 'package:cloud_firestore/cloud_firestore.dart';

//Class for defining all User details
class UserModel {
  //Initializing user details
  final String id;
  final String name;
  final String email;
  final String username;
  final String dob;
  final String accountType;
  final Timestamp timeCreated;
  final String profilePhotoURL;

  //Required details from users
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

  //Returns the instance of class UserModel
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
