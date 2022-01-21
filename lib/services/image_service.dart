import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImageService {
  static Future<void> chooseFromGallery(File file) async {
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    file = File('${xFile?.path}');
  }

  static Future<void> chooseFromCamera(File file) async {
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.camera);
    file = File('${xFile?.path}');
  }
}
