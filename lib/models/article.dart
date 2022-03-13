import 'package:cloud_firestore/cloud_firestore.dart';

class ArticleModel {
  final String id;
  final String authorId;
  final String imageURL;
  final String text;
  final Map likes;
  // final Map likes; TODO: Add comments to articles
  final Timestamp timestamp;
  final String authorUserName;
  final String authorName;
  final String authorProfilePhotoURL;
  // TODO: Should Articles have a heading

  ArticleModel({
    required this.text,
    required this.likes,
    required this.authorUserName,
    required this.authorName,
    required this.authorProfilePhotoURL,
    required this.id,
    required this.imageURL,
    required this.authorId,
    required this.timestamp,
    // required this.likes,
  });

  factory ArticleModel.fromDocument(DocumentSnapshot doc) {
    return ArticleModel(
      id: doc.id,
      imageURL: doc['imageURL'],
      likes: doc['likes'],
      text: doc['text'],
      authorName: doc['authorName'],
      authorProfilePhotoURL: doc['authorProfilePhotoURL'],
      authorId: doc['authorId'],
      timestamp: doc['timestamp'],
      authorUserName: doc['authorUserName'],
    );
  }
}
