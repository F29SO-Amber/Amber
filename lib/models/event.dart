import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  String userID;
  String title;
  String description;
  String startingTime;
  String venue;
  String eventPhotoURL;

  EventModel({
    required this.userID,
    required this.title,
    required this.description,
    required this.startingTime,
    required this.venue,
    required this.eventPhotoURL,
  });

  factory EventModel.fromDocument(DocumentSnapshot doc) {
    return EventModel(
      userID: doc['userID'],
      title: doc['title'],
      description: doc['description'],
      startingTime: doc['startingTime'],
      venue: doc['venue'],
      eventPhotoURL: doc['eventPhotoURL'],
    );
  }
}
