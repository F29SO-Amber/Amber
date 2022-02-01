import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
    Hashtag(id: 2, name: "#brand_marketer"),
    Hashtag(id: 3, name: "#artist"),
    Hashtag(id: 4, name: "#paints"),
    Hashtag(id: 5, name: "#food"),
    Hashtag(id: 6, name: "#education"),
    Hashtag(id: 7, name: "#students"),
    Hashtag(id: 8, name: "#content"),
    Hashtag(id: 9, name: "#content_creator"),
    Hashtag(id: 10, name: "#games"),
    Hashtag(id: 11, name: "#music"),
    Hashtag(id: 12, name: "#school"),
    Hashtag(id: 13, name: "#sea"),
    Hashtag(id: 14, name: "#beautiful"),
    Hashtag(id: 15, name: "#colorful"),
  ];
}
