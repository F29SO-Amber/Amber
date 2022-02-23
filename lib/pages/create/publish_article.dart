import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:amber/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tuple/tuple.dart';
import 'package:uuid/uuid.dart';

import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';
import '../../services/image_service.dart';

class PublishArticleScreen extends StatefulWidget {
  static const id = '/publish_article';
  const PublishArticleScreen({Key? key}) : super(key: key);

  @override
  _PublishArticleScreenState createState() => _PublishArticleScreenState();
}

class _PublishArticleScreenState extends State<PublishArticleScreen> {
  File? file;
  bool uploadButtonPresent = true;
  final QuillController _controller = QuillController.basic();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppColor,
        title: const Text('Create an Article', style: TextStyle(fontSize: 18, color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            color: Colors.white,
            onPressed: () => disposeUserPostChanges(),
          ),
          Visibility(
            visible: uploadButtonPresent,
            child: IconButton(
              icon: const Icon(Icons.publish),
              color: Colors.white,
              onPressed: () async {
                setState(() => uploadButtonPresent = false);
                EasyLoading.show(status: 'Uploading...');
                await addUserArticle();
                EasyLoading.dismiss();
                disposeUserPostChanges();
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () async {
              file = await ImageService.chooseFromGallery();
              if (file != null) {
                setState(() {});
              }
            },
            child: Container(
              height: MediaQuery.of(context).size.width * 9 / 16,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: (file == null)
                      ? const AssetImage('assets/taptoselect.png')
                      : FileImage(file!) as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            child: QuillEditor.basic(
              controller: _controller,
              readOnly: false, // true for view only mode
            ),
          ),
          Container(
            color: Colors.black,
            width: double.infinity,
            height: 1,
          ),
          QuillToolbar.basic(
            controller: _controller,
            showImageButton: false,
            showVideoButton: false,
            showCameraButton: false,
            toolbarSectionSpacing: 10,
          ),
          const SizedBox(height: 5)
        ],
      ),
    );
  }

  disposeUserPostChanges() {}

  Future<void> addUserArticle() async {
    UserModel user = await DatabaseService.getUser(AuthService.currentUser.uid);
    Map<String, Object?> map = {};
    if (file != null) {
      String articleID = const Uuid().v4();
      map['id'] = articleID;
      map['imageURL'] = await uploadImage(articleID);
      map['text'] = jsonEncode(_controller.document.toDelta().toJson());
      map['authorId'] = AuthService.currentUser.uid;
      map['timestamp'] = Timestamp.now();
      map['authorUserName'] = user.username;
      await DatabaseService.articlesRef.doc(articleID).set(map);
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Image Posted!")));
    }
  }

  Future<String> uploadImage(String pID) async {
    TaskSnapshot ts =
        await FirebaseStorage.instance.ref().child('articles').child(pID).putFile(file!);
    return ts.ref.getDownloadURL();
  }
}
// class _PublishArticleScreenState extends State<PublishArticleScreen> {
//   final QuillController? _controller = QuillController.basic();
//   final FocusNode _focusNode = FocusNode();
//
//   @override
//   Widget build(BuildContext context) {
//     if (_controller == null) {
//       return const Scaffold(body: Center(child: Text('Loading...')));
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.grey.shade800,
//         elevation: 0,
//         centerTitle: false,
//         title: const Text('Flutter Quill'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.publish),
//             color: Colors.white,
//             onPressed: () {
//               debugPrint(jsonEncode(_controller!.document.toDelta().toJson()));
//               // _controller = QuillController(
//               //     document: Document.fromJson(myJSON),
//               //     selection: TextSelection.collapsed(offset: 0));
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           QuillEditor.basic(
//             controller: _controller!,
//             readOnly: false,
//           ),
//           QuillToolbar.basic(
//             controller: _controller!,
//             showAlignmentButtons: true,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildWelcomeEditor(BuildContext context) {
//     var quillEditor = QuillEditor(
//       controller: _controller!,
//       scrollController: ScrollController(),
//       scrollable: true,
//       focusNode: _focusNode,
//       autoFocus: false,
//       readOnly: false,
//       placeholder: 'Add content',
//       expands: false,
//       padding: EdgeInsets.zero,
//       customStyles: DefaultStyles(
//         h1: DefaultTextBlockStyle(
//           const TextStyle(
//             fontSize: 32,
//             color: Colors.black,
//             height: 1.15,
//             fontWeight: FontWeight.w300,
//           ),
//           const Tuple2(16, 0),
//           const Tuple2(0, 0),
//           null,
//         ),
//         sizeSmall: const TextStyle(fontSize: 9),
//       ),
//     );
//     var toolbar = QuillToolbar.basic(
//       controller: _controller!,
//       onImagePickCallback: _onImagePickCallback,
//       onVideoPickCallback: _onVideoPickCallback,
//       showAlignmentButtons: true,
//     );
//
//     return SafeArea(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           Expanded(
//             flex: 15,
//             child: Container(
//               color: Colors.white,
//               padding: const EdgeInsets.only(left: 16, right: 16),
//               child: quillEditor,
//             ),
//           ),
//           Container(child: toolbar)
//         ],
//       ),
//     );
//   }
//
//   Future<String> _onImagePickCallback(File file) async {
//     final appDocDir = await getApplicationDocumentsDirectory();
//     final copiedFile = await file.copy('${appDocDir.path}/${basename(file.path)}');
//     return copiedFile.path.toString();
//   }
//
//   Future<String> _onVideoPickCallback(File file) async {
//     final appDocDir = await getApplicationDocumentsDirectory();
//     final copiedFile = await file.copy('${appDocDir.path}/${basename(file.path)}');
//     return copiedFile.path.toString();
//   }
// }
