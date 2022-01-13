import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:amber/services/auth_service.dart';

class StorageService {
  static final _storage = FirebaseStorage.instance;

  static Future<String> uploadPost(File file) async {
    TaskSnapshot taskSnapshot = await _storage
        .ref()
        .child('posts')
        .child('${Authentication.currentUser.uid}_${Timestamp.now()}')
        .putFile(file);

    return taskSnapshot.ref.getDownloadURL();
  }
}
