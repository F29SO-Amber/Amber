import 'package:cloud_firestore/cloud_firestore.dart';

class ThumbnailModel {
  final String id;
  final String link;
  final String caption;
  final String authorId;
  final String imageURL;
  final String location;
  final String authorName;
  final Timestamp timestamp;
  final String authorUserName;
  final String authorProfilePhotoURL;

  ThumbnailModel({
    required this.id,
    required this.link,
    required this.caption,
    required this.location,
    required this.imageURL,
    required this.authorId,
    required this.timestamp,
    required this.authorName,
    required this.authorUserName,
    required this.authorProfilePhotoURL,
  });

  factory ThumbnailModel.fromDocument(DocumentSnapshot doc) {
    return ThumbnailModel(
      id: doc.id,
      link: doc['link'],
      caption: doc['caption'],
      location: doc['location'],
      imageURL: doc['imageURL'],
      authorId: doc['authorId'],
      timestamp: doc['timestamp'],
      authorName: doc['authorName'],
      authorUserName: doc['authorUserName'],
      authorProfilePhotoURL: doc['authorProfilePhotoURL'],
    );
  }
}
