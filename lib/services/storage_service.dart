import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:amber/services/auth_service.dart';

class StorageService {
  static final _storage = FirebaseStorage.instance;
  static final storageRef = FirebaseStorage.instance.ref();

  static Future<String> uploadProfileImage(String userUID, File file) async {
    return (await _storage.ref().child('profile').child(userUID).putFile(file))
        .ref
        .getDownloadURL();
  }
}
