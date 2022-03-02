import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  static final _storage = FirebaseStorage.instance;

  static Future<String> uploadImage(String id, File file, String folder) async {
    TaskSnapshot ts = await _storage.ref().child(folder).child(id).putFile(file);
    return ts.ref.getDownloadURL();
  }
}
