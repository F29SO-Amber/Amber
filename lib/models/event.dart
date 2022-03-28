import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  String title;
  String venue;
  String userID;
  String description;
  String startingTime;
  String eventPhotoURL;

  EventModel({
    required this.title,
    required this.venue,
    required this.userID,
    required this.description,
    required this.startingTime,
    required this.eventPhotoURL,
  });

  factory EventModel.fromDocument(DocumentSnapshot doc) {
    return EventModel(
      title: doc['title'],
      venue: doc['venue'],
      userID: doc['userID'],
      description: doc['description'],
      startingTime: doc['startingTime'],
      eventPhotoURL: doc['eventPhotoURL'],
    );
  }
}
