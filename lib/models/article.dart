import 'package:cloud_firestore/cloud_firestore.dart';

class ArticleModel {
  final String id;
  final String text;
  final String caption;
  final String authorId;
  final String location;
  final String imageURL;
  final String authorName;
  final Timestamp timestamp;
  final String authorUserName;
  final String authorProfilePhotoURL;

  ArticleModel({
    required this.id,
    required this.text,
    required this.caption,
    required this.imageURL,
    required this.location,
    required this.authorId,
    required this.timestamp,
    required this.authorName,
    required this.authorUserName,
    required this.authorProfilePhotoURL,
  });

  factory ArticleModel.fromDocument(DocumentSnapshot doc) {
    return ArticleModel(
      id: doc.id,
      text: doc['text'],
      caption: doc['caption'],
      imageURL: doc['imageURL'],
      location: doc['location'],
      authorId: doc['authorId'],
      timestamp: doc['timestamp'],
      authorName: doc['authorName'],
      authorUserName: doc['authorUserName'],
      authorProfilePhotoURL: doc['authorProfilePhotoURL'],
    );
  }
}
