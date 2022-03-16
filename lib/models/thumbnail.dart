import 'package:cloud_firestore/cloud_firestore.dart';

class ThumbnailModel {
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
  final String authorProfilePhotoURL;

  ThumbnailModel({
    required this.id,
    required this.likes,
    required this.caption,
    required this.location,
    required this.imageURL,
    required this.authorId,
    required this.timestamp,
    required this.authorName,
    required this.forCommunity,
    required this.authorUserName,
    required this.authorProfilePhotoURL,
  });

  factory ThumbnailModel.fromDocument(DocumentSnapshot doc) {
    return ThumbnailModel(
      id: doc.id,
      likes: doc['likes'],
      caption: doc['caption'],
      location: doc['location'],
      imageURL: doc['imageURL'],
      authorId: doc['authorId'],
      timestamp: doc['timestamp'],
      authorName: doc['authorName'],
      forCommunity: doc['forCommunity'],
      authorUserName: doc['authorUserName'],
      authorProfilePhotoURL: doc['authorProfilePhotoURL'],
    );
  }
}
