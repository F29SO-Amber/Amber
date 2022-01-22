import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  String username;
  String comment;
  Timestamp timestamp;
  String userProfilePhoto;

  CommentModel({
    required this.username,
    required this.comment,
    required this.timestamp,
    required this.userProfilePhoto,
  });

  factory CommentModel.fromDocument(DocumentSnapshot doc) {
    return CommentModel(
      username: doc['username'],
      comment: doc['text'],
      timestamp: doc['timestamp'],
      userProfilePhoto: doc['profilePhotoURL'],
    );
  }
}
