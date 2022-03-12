import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  // TODO: Update User Model properly
  final String id;
  final String firstName;
  // final String lastName;
  final String email;
  final String username;
  final String dob;
  final String accountType;
  final Timestamp timeCreated;
  final String imageUrl;
  final String role;

  const UserModel({
    required this.id,
    required this.firstName,
    // required this.lastName,
    required this.email,
    required this.username,
    required this.dob,
    required this.accountType,
    required this.timeCreated,
    required this.imageUrl,
    required this.role,
  });

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
      id: doc.id,
      firstName: doc['firstName'],
      // lastName: doc['lastName'],
      email: doc['email'],
      username: doc['username'],
      dob: doc['dob'],
      accountType: doc['account_type'],
      timeCreated: doc['timeCreated'],
      imageUrl: doc['imageUrl'],
      role: doc['role'],
    );
  }

  List<String> getCurrentUserPostTypes() {
    switch (accountType) {
      case 'Artist':
        return ['Image', 'Article', 'Community', 'Public Group'];
      case 'Brand Marketer':
        return ['Image', 'Article', 'Event', 'Public Group'];
      case 'Content Creator':
        return ['Image', 'Article', 'Thumbnail', 'Public Group'];
      case 'Student':
        return ['Image', 'Article', 'Public Group'];
      default:
        return ['Image'];
    }
  }
}
