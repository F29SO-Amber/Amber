import 'package:cloud_firestore/cloud_firestore.dart';

class ArticleModel {
  final String id;
  final String authorId;
  final String imageURL;
  final String text;
  // final Map likes; TODO: Add likes and comments to articles
  final Timestamp timestamp;
  final String authorUserName;
  // TODO: Should Articles have a heading

  ArticleModel({
    required this.text,
    required this.authorUserName,
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
      text: doc['text'],
      // likes: doc['likes'],
      authorId: doc['authorId'],
      timestamp: doc['timestamp'],
      authorUserName: doc['authorUserName'],
    );
  }
}
