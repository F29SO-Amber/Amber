import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:amber/utilities/constants.dart';
import 'package:amber/services/auth_service.dart';
import 'package:amber/services/image_service.dart';
import 'package:amber/widgets/profile_picture.dart';
import 'package:amber/services/storage_service.dart';
import 'package:amber/services/database_service.dart';

class PublishCommunityScreen extends StatefulWidget {
  static const id = '/publish_community';

  const PublishCommunityScreen({Key? key}) : super(key: key);

  @override
  _PublishCommunityScreenState createState() => _PublishCommunityScreenState();
}

class _PublishCommunityScreenState extends State<PublishCommunityScreen> {
  File? _file;
  bool _uploadButtonPresent = true;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    disposeUserEventChanges();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppColor,
        title:
            const Text('Create a Community', style: TextStyle(fontSize: 18, color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            color: Colors.white,
            onPressed: () => disposeUserEventChanges(),
          ),
          Visibility(
            visible: _uploadButtonPresent,
            child: IconButton(
              icon: const Icon(Icons.publish),
              color: Colors.white,
              onPressed: () async {
                setState(() => _uploadButtonPresent = false);
                EasyLoading.show(status: 'Creating Community...');
                await _addUserCommunity();
                EasyLoading.dismiss();
                disposeUserEventChanges();
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
                      controller: _nameController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        hintText: "Name your community...",
                        border: InputBorder.none,
                        prefixIcon: Icon(FontAwesomeIcons.userFriends, color: kAppColor, size: 23),
                      ),
                    ),
                  ),
                  const Divider(),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(left: 15),
                    child: TextFormField(
                      controller: _descriptionController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        hintText: "Describe your community...",
                        border: InputBorder.none,
                        prefixIcon: Icon(FontAwesomeIcons.pen, color: kAppColor, size: 23),
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

  void disposeUserEventChanges() {
    setState(() {
      _file = null;
      _nameController.text = '';
      _uploadButtonPresent = true;
      _descriptionController.text = '';
    });
  }

  Future<void> _addUserCommunity() async {
    if (_formKey.currentState!.validate()) {
      Map<String, Object?> map = {};
      if (_file != null) {
        String communityID = const Uuid().v4();
        map['name'] = _nameController.text;
        map['timeCreated'] = Timestamp.now();
        map['ownerID'] = AuthService.currentUser.uid;
        map['description'] = _descriptionController.text;
        map['communityPhotoURL'] =
            await StorageService.uploadImage(communityID, _file!, 'communities');
        await DatabaseService.communityRef.doc(communityID).set(map);
      }
    }
  }
}
