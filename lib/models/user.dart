import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  // TODO: Update User Model properly (lastname)
  final String id;
  final String dob;
  // final String role;
  final String email;
  final String imageUrl;
  // final String lastName;
  final String username;
  final String firstName;
  final String accountType;
  final Timestamp timeCreated;

  const UserModel({
    required this.id,
    required this.dob,
    // required this.role,
    required this.email,
    required this.imageUrl,
    // required this.lastName,
    required this.username,
    required this.firstName,
    required this.accountType,
    required this.timeCreated,
  });

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
      id: doc.id,
      dob: doc['dob'],
      // role: doc['role'],
      email: doc['email'],
      // lastName: doc['lastName'],
      username: doc['username'],
      imageUrl: doc['imageUrl'],
      firstName: doc['firstName'],
      timeCreated: doc['timeCreated'],
      accountType: doc['account_type'],
    );
  }

  List<String> getCurrentUserPostTypes() {
    switch (accountType) {
      case 'Artist':
        return ['Image', 'Article', 'Community'];
      case 'Brand Marketer':
        return ['Image', 'Article', 'Event'];
      case 'Content Creator':
        return ['Image', 'Article', 'Thumbnail'];
      case 'Student':
        return ['Image', 'Article'];
      default:
        return ['Image'];
    }
  }
}
