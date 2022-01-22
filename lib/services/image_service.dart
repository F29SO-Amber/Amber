import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ImageService {
  final apiKey = 'm9invNolYWWbS1oLMBYmRvNgt0SDq49P';
  final picPurifyURL = 'https://www.picpurify.com/analyse/1.1';

  static Future<void> chooseFromGallery(File file) async {
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    file = File('${xFile?.path}');
  }

  static Future<void> chooseFromCamera(File file) async {
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.camera);
    file = File('${xFile?.path}');
  }

  // Future<dynamic> getData(String url) async {
  //   http.Response response = await http.get(Uri.parse(url));
  //
  //   if (response.statusCode == 200) {
  //     return jsonDecode(response.body);
  //   } else {
  //     print(response.statusCode);
  //   }
  // }
  //
  // Future<dynamic> getImageDetails(String File file) async {
  //   return getData('$picPurifyURL?key=$apiKey&url=$imageURL');
  // }
}
