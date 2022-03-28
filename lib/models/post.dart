import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final Map likes;
  final String caption;
  final String authorId;
  final String imageURL;
  final String location;
  final String authorName;
  final Timestamp timestamp;
  final String forCommunity;
  final String authorUserName;
  final List hashtags;
  final String authorProfilePhotoURL;

  PostModel({
    required this.id,
    required this.likes,
    required this.caption,
    required this.location,
    required this.imageURL,
    required this.authorId,
    required this.hashtags,
    required this.timestamp,
    required this.authorName,
    required this.forCommunity,
    required this.authorUserName,
    required this.authorProfilePhotoURL,
  });

  factory PostModel.fromDocument(DocumentSnapshot doc) {
    return PostModel(
      id: doc.id,
      likes: doc['likes'],
      caption: doc['caption'],
      location: doc['location'],
      imageURL: doc['imageURL'],
      authorId: doc['authorId'],
      hashtags: doc['hashtags'],
      timestamp: doc['timestamp'],
      authorName: doc['authorName'],
      forCommunity: doc['forCommunity'],
      authorUserName: doc['authorUserName'],
      authorProfilePhotoURL: doc['authorProfilePhotoURL'],
    );
  }
}
