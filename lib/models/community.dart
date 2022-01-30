import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityModel {
  final String name;
  final String ownerID;
  final String description;
  final Timestamp timeCreated;
  final String communityPhotoURL;

  const CommunityModel({
    required this.name,
    required this.ownerID,
    required this.description,
    required this.timeCreated,
    required this.communityPhotoURL,
  });

  factory CommunityModel.fromDocument(DocumentSnapshot doc) {
    return CommunityModel(
      name: doc['name'],
      ownerID: doc['ownerID'],
      description: doc['description'],
      timeCreated: doc['timeCreated'],
      communityPhotoURL: doc['communityPhotoURL'],
    );
  }
}
