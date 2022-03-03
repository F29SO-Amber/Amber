import 'dart:io';
import 'package:image/image.dart' as image;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

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

  static Future<File> compressImageFile(File file, String postID) async {
    image.Image? imageFile = image.decodeImage(file.readAsBytesSync());
    return File('${(await getTemporaryDirectory()).path}/img_$postID.jpg')
      ..writeAsBytesSync(image.encodeJpg(imageFile!, quality: 85));
    // setState(() => file = compressedImageFile);
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
