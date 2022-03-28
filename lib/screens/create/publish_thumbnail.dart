import 'dart:io';
import 'package:amber/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:amber/utilities/constants.dart';
import 'package:amber/services/auth_service.dart';
import 'package:amber/services/image_service.dart';
import 'package:amber/widgets/profile_picture.dart';
import 'package:amber/services/storage_service.dart';
import 'package:amber/services/database_service.dart';

class PublishThumbnailScreen extends StatefulWidget {
  static const id = '/publish_thumbnail';

  const PublishThumbnailScreen({Key? key}) : super(key: key);

  @override
  _PublishThumbnailScreenState createState() => _PublishThumbnailScreenState();
}

class _PublishThumbnailScreenState extends State<PublishThumbnailScreen> {
  File? _file;
  bool _uploadButtonPresent = true;
  final _formKey = GlobalKey<FormState>();
  final _captionController = TextEditingController();
  final _linkController = TextEditingController();
  final _locationController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _captionController.dispose();
    _linkController.dispose();
    _locationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppColor,
        title: const Text('Create an Event', style: TextStyle(fontSize: 18, color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            color: Colors.white,
            onPressed: () => _disposeUserEventChanges(),
          ),
          Visibility(
            visible: _uploadButtonPresent,
            child: IconButton(
              icon: const Icon(Icons.publish),
              color: Colors.white,
              onPressed: () async {
                setState(() => _uploadButtonPresent = false);
                EasyLoading.show(status: 'Adding Thumbnail...');
                await _addUserThumbnail();
                EasyLoading.dismiss();
                _disposeUserEventChanges();
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  GestureDetector(
                    child: Container(
                      height: (MediaQuery.of(context).size.width / 16) * 9,
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
                    onTap: () => showMaterialModalBottomSheet(
                      expand: false,
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context) => Material(
                        child: SafeArea(
                          top: false,
                          child: SizedBox(
                            height: 250,
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 25.0),
                                  child: Text('Choose media from:', style: kDarkLabelTextStyle),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            _file = await ImageService.chooseFromCamera();
                                            if (_file != null) {
                                              setState(() {});
                                            }
                                            Navigator.pop(context);
                                          },
                                          child: const CustomImage(
                                              side: 100, path: 'assets/camera.png'),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                                          child: Text('Camera', style: kLightLabelTextStyle),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            _file = await ImageService.chooseFromGallery();
                                            if (_file != null) {
                                              setState(() {});
                                            }
                                            Navigator.pop(context);
                                          },
                                          child: const CustomImage(
                                              side: 100, path: 'assets/image.png'),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                                          child: Text('Gallery', style: kLightLabelTextStyle),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(left: 15),
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
                        hintText: "Whats your video about...",
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.info, color: kAppColor, size: 30),
                      ),
                    ),
                  ),
                  const Divider(),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(left: 15),
                    child: TextFormField(
                      controller: _linkController,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Link cannot be empty';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: "Provide a link...",
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.link, color: kAppColor, size: 30),
                      ),
                    ),
                  ),
                  const Divider(),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(left: 15),
                    child: TextFormField(
                      controller: _locationController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        hintText: "Where did it take place...",
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.pin_drop, color: kAppColor, size: 30),
                      ),
                    ),
                  ),
                  const Divider(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _disposeUserEventChanges() {
    setState(() {
      _file = null;
      _captionController.text = '';
      _locationController.text = '';
      _linkController.text = '';
      _uploadButtonPresent = true;
    });
  }

  Future<void> _addUserThumbnail() async {
    if (_formKey.currentState!.validate()) {
      Map<String, Object?> map = {};
      if (_file != null) {
        String eventID = const Uuid().v4();
        map['link'] = _linkController.text;
        map['caption'] = _captionController.text;
        map['location'] = _locationController.text;
        map['imageURL'] = await StorageService.uploadImage(eventID, _file!, 'thumbnails');
        map['authorId'] = UserData.currentUser!.id;
        map['timestamp'] = Timestamp.now();
        map['authorName'] = UserData.currentUser!.firstName;
        map['authorUserName'] = UserData.currentUser!.username;
        map['authorProfilePhotoURL'] = UserData.currentUser!.imageUrl;
        await DatabaseService.thumbnailsRef.doc(eventID).set(map);
      }
    }
  }
}
