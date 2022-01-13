import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String imageUrl;
  final String caption;
  final int score;
  final String authorId;
  final Timestamp timestamp;

  PostModel({
    required this.id,
    required this.imageUrl,
    required this.caption,
    required this.score,
    required this.authorId,
    required this.timestamp,
  });

  factory PostModel.fromDocument(DocumentSnapshot doc) {
    return PostModel(
      id: doc.id,
      imageUrl: doc['imageUrl'],
      caption: doc['caption'],
      score: doc['score'],
      authorId: doc['authorId'],
      timestamp: doc['timestamp'],
    );
  }
}
