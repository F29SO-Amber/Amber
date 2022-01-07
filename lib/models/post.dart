import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String imageUrl;
  final String caption;
  final int score;
  final String authorId;
  final Timestamp timestamp;

  Post({
    required this.id,
    required this.imageUrl,
    required this.caption,
    required this.score,
    required this.authorId,
    required this.timestamp,
  });

  factory Post.fromDocument(DocumentSnapshot doc) {
    return Post(
      id: doc.id,
      imageUrl: doc['imageUrl'],
      caption: doc['caption'],
      score: doc['score'],
      authorId: doc['authorId'],
      timestamp: doc['timestamp'],
    );
  }
}
