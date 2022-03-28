import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityModel {
  final String id;
  final String name;
  final String ownerID;
  final String description;
  final String ownerUsername;
  final Timestamp timeCreated;
  final String communityPhotoURL;

  const CommunityModel({
    required this.id,
    required this.name,
    required this.ownerID,
    required this.description,
    required this.timeCreated,
    required this.ownerUsername,
    required this.communityPhotoURL,
  });

  factory CommunityModel.fromDocument(DocumentSnapshot doc) {
    return CommunityModel(
      id: doc.id,
      name: doc['name'],
      ownerID: doc['ownerID'],
      description: doc['description'],
      timeCreated: doc['timeCreated'],
      ownerUsername: doc['ownerUsername'],
      communityPhotoURL: doc['communityPhotoURL'],
    );
  }
}
