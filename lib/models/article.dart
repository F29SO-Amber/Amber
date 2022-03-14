import 'package:cloud_firestore/cloud_firestore.dart';

class ArticleModel {
  final String id;
  final Map likes;
  final String text;
  final String authorId;
  final String imageURL;
  final String authorName;
  final Timestamp timestamp;
  final String authorUserName;
  final String authorProfilePhotoURL;

  ArticleModel({
    required this.id,
    required this.text,
    required this.likes,
    required this.imageURL,
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
      likes: doc['likes'],
      imageURL: doc['imageURL'],
      authorId: doc['authorId'],
      timestamp: doc['timestamp'],
      authorName: doc['authorName'],
      authorUserName: doc['authorUserName'],
      authorProfilePhotoURL: doc['authorProfilePhotoURL'],
    );
  }
}
