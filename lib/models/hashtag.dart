import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HashtagModel {
  final String postID;
  final String hashtag;

  HashtagModel({
    required this.postID,
    required this.hashtag,
  });

  factory HashtagModel.fromDocument(DocumentSnapshot doc) {
    return HashtagModel(
      postID: doc['postID'],
      hashtag: doc['hashtag'],
    );
  }
}

class Hashtag {
  final int id;
  final String name;

  Hashtag({Key? key, required this.id, required this.name});

  static final List<Hashtag> hashtags = [
    Hashtag(id: 1, name: "#brand"),
    Hashtag(id: 2, name: "#selfie"),
    Hashtag(id: 3, name: "#artist"),
    Hashtag(id: 4, name: "#baby"),
    Hashtag(id: 5, name: "#food"),
    Hashtag(id: 6, name: "#summer"),
    Hashtag(id: 7, name: "#students"),
    Hashtag(id: 8, name: "#content"),
    Hashtag(id: 9, name: "#motivation"),
    Hashtag(id: 10, name: "#games"),
    Hashtag(id: 11, name: "#music"),
    Hashtag(id: 12, name: "#beach"),
    Hashtag(id: 13, name: "#sunset"),
    Hashtag(id: 14, name: "#beauty"),
    Hashtag(id: 15, name: "#peaceful"),
    Hashtag(id: 16, name: "#love"),
    Hashtag(id: 17, name: "#nature"),
    Hashtag(id: 18, name: "#memes"),
    Hashtag(id: 19, name: "#home"),
    Hashtag(id: 20, name: "#school"),
    Hashtag(id: 21, name: "#happy"),
  ];
}
