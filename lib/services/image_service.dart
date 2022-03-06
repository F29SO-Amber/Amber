import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImageService {
  final apiKey = 'm9invNolYWWbS1oLMBYmRvNgt0SDq49P';
  final picPurifyURL = 'https://www.picpurify.com/analyse/1.1';

  static Future<File?> chooseFromGallery() async {
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    return (xFile != null) ? File(xFile.path) : null;
  }

  static Future<File?> chooseFromCamera() async {
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.camera);
    return (xFile != null) ? File(xFile.path) : null;
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
