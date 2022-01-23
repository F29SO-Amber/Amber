import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  String comment;
  String username;
  Timestamp timestamp;
  String profilePhotoURL;

  CommentModel({
    required this.comment,
    required this.username,
    required this.timestamp,
    required this.profilePhotoURL,
  });

  factory CommentModel.fromDocument(DocumentSnapshot doc) {
    return CommentModel(
      username: doc['username'],
      comment: doc['text'],
      timestamp: doc['timestamp'],
      profilePhotoURL: doc['profilePhotoURL'],
    );
  }
}
