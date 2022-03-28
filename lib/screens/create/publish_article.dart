import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:amber/models/user.dart';
import 'package:amber/utilities/constants.dart';
import 'package:amber/services/auth_service.dart';
import 'package:amber/services/image_service.dart';
import 'package:amber/services/storage_service.dart';
import 'package:amber/services/database_service.dart';

import 'package:amber/user_data.dart';

class PublishArticleScreen extends StatefulWidget {
  static const id = '/publish_article';

  const PublishArticleScreen({Key? key}) : super(key: key);

  @override
  _PublishArticleScreenState createState() => _PublishArticleScreenState();
}

class _PublishArticleScreenState extends State<PublishArticleScreen> {
  File? _file;
  bool _uploadButtonPresent = true;
  final _formKey = GlobalKey<FormState>();
  final _captionController = TextEditingController();
  final QuillController _controller = QuillController.basic();

  @override
  void dispose() {
    _controller.dispose();
    _captionController.dispose();
    super.dispose();
  }

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
            onPressed: () => _disposeUserArticleChanges(),
          ),
          Visibility(
            visible: _uploadButtonPresent,
            child: IconButton(
              icon: const Icon(Icons.publish),
              color: Colors.white,
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  setState(() => _uploadButtonPresent = false);
                  EasyLoading.show(status: 'Uploading...');
                  await addUserArticle();
                  EasyLoading.dismiss();
                  _disposeUserArticleChanges();
                  setState(() => _uploadButtonPresent = true);
                }
              },
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                _file = await ImageService.chooseFromGallery();
                if (_file != null) {
                  setState(() {});
                }
              },
              child: Container(
                height: MediaQuery.of(context).size.width * 9 / 16,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: (_file == null)
                        ? const AssetImage('assets/taptoselect.png')
                        : FileImage(_file!) as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(left: 15, top: 20, bottom: 10),
              child: TextFormField(
                controller: _captionController,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Caption cannot be empty';
                  } else if (_captionController.text.length > 20) {
                    return 'Max Caption length is 20';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: "Write a caption...",
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.create_sharp, color: kAppColor, size: 30),
                ),
              ),
            ),
            Container(color: Colors.black, width: double.infinity, height: 0.3),
            Expanded(
              child: QuillEditor(
                controller: _controller,
                readOnly: false,
                autoFocus: true,
                expands: false,
                padding: EdgeInsets.zero,
                placeholder: 'Start typing...',
                scrollController: ScrollController(),
                focusNode: FocusNode(),
                scrollable: true,
              ),
            ),
            Container(color: Colors.black, width: double.infinity, height: 1),
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
      ),
    );
  }

  void _disposeUserArticleChanges() {
    setState(() {
      _file = null;
      _controller.clear();
      _captionController.clear();
    });
  }

  Future<void> addUserArticle() async {
    Map<String, Object?> map = {};
    if (_file != null) {
      String articleID = const Uuid().v4();
      map['id'] = articleID;
      map['imageURL'] = await StorageService.uploadImage(articleID, _file!, 'articles');
      map['text'] = jsonEncode(_controller.document.toDelta().toJson());
      map['caption'] = _captionController.text;
      map['authorId'] = AuthService.currentUser.uid;
      map['timestamp'] = Timestamp.now();
      map['location'] = '';
      map['authorUserName'] = UserData.currentUser!.username;
      map['authorName'] = UserData.currentUser!.firstName;
      map['authorProfilePhotoURL'] = UserData.currentUser!.imageUrl;
      await DatabaseService.articlesRef.doc(articleID).set(map);
    }
  }
}
