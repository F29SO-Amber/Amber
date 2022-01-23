import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String authorId;
  final String imageURL;
  final String caption;
  final Map likes;
  final String location;
  final Timestamp timestamp;
  final String authorName;
  final String authorUserName;
  final String authorProfilePhotoURL;

  PostModel({
    required this.authorName,
    required this.authorUserName,
    required this.authorProfilePhotoURL,
    required this.id,
    required this.location,
    required this.imageURL,
    required this.caption,
    required this.likes,
    required this.authorId,
    required this.timestamp,
  });

  factory PostModel.fromDocument(DocumentSnapshot doc) {
    return PostModel(
      id: doc.id,
      imageURL: doc['imageURL'],
      caption: doc['caption'],
      likes: doc['likes'],
      authorId: doc['authorId'],
      timestamp: doc['timestamp'],
      location: doc['location'],
      authorUserName: doc['authorUserName'],
      authorProfilePhotoURL: doc['authorProfilePhotoURL'],
      authorName: doc['authorName'],
    );
  }
}
