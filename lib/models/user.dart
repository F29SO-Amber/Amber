import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String firstName;
  final String email;
  final String username;
  final String dob;
  final String accountType;
  final Timestamp timeCreated;
  final int createdAt;
  final String imageUrl;
  final int lastSeen;
  final String role;
  final int updatedAt;

  const UserModel({
    required this.id,
    required this.firstName,
    required this.email,
    required this.username,
    required this.createdAt,
    required this.dob,
    required this.accountType,
    required this.timeCreated,
    required this.imageUrl,
    required this.lastSeen,
    required this.role,
    required this.updatedAt,
  });

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
      id: doc.id,
      firstName: doc['firstName'],
      email: doc['email'],
      username: doc['username'],
      dob: doc['dob'],
      accountType: doc['account_type'],
      createdAt: doc['createdAt'],
      timeCreated: doc['timeCreated'],
      imageUrl: doc['imageUrl'],
      lastSeen: doc['lastSeen'],
      role: doc['role'],
      updatedAt: doc['updatedAt'],
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
