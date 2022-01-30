import 'dart:io';
import 'package:amber/services/image_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as image;
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:amber/models/user.dart';
import 'package:amber/models/hashtag.dart';
import 'package:amber/utilities/constants.dart';
import 'package:amber/services/auth_service.dart';
import 'package:amber/widgets/profile_picture.dart';
import 'package:amber/services/database_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class PublishCommunityScreen extends StatefulWidget {
  static const id = '/publish_community';

  const PublishCommunityScreen({Key? key}) : super(key: key);

  @override
  _PublishCommunityScreenState createState() => _PublishCommunityScreenState();
}

class _PublishCommunityScreenState extends State<PublishCommunityScreen> {
  File? file;
  bool uploadButtonPresent = true;
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppColor,
        title: const Text(
          'Create a Community',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            color: Colors.white,
            onPressed: () => disposeUserEventChanges(),
          ),
          Visibility(
            visible: uploadButtonPresent,
            child: IconButton(
              icon: const Icon(Icons.publish),
              color: Colors.white,
              onPressed: () async {
                setState(() => uploadButtonPresent = false);
                EasyLoading.show(status: 'Creating Community...');
                await addUserPost();
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
                          image: (file == null)
                              ? const AssetImage('assets/taptoselect.png')
                              : FileImage(file!) as ImageProvider,
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
                                            XFile? xFile = await ImagePicker()
                                                .pickImage(source: ImageSource.camera);
                                            setState(() => file = File('${xFile?.path}'));
                                            Navigator.pop(context);
                                          },
                                          child: const ProfilePicture(
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
                                            XFile? xFile = await ImagePicker()
                                                .pickImage(source: ImageSource.gallery);
                                            setState(() => file = File('${xFile?.path}'));
                                            Navigator.pop(context);
                                          },
                                          child: const ProfilePicture(
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
                      controller: nameController,
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
                      controller: descriptionController,
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
      file = null;
      nameController.text = '';
      uploadButtonPresent = true;
      descriptionController.text = '';
    });
  }

  Future<void> compressImageFile(String postID) async {
    image.Image? imageFile = image.decodeImage(file!.readAsBytesSync());
    final compressedImageFile = File('${(await getTemporaryDirectory()).path}/img_$postID.jpg')
      ..writeAsBytesSync(image.encodeJpg(imageFile!, quality: 85));
    setState(() => file = compressedImageFile);
  }

  Future<void> addUserPost() async {
    if (_formKey.currentState!.validate()) {
      Map<String, Object?> map = {};
      if (file != null) {
        String communityID = const Uuid().v4();
        await compressImageFile(communityID);
        map['name'] = nameController.text;
        map['timeCreated'] = Timestamp.now();
        map['ownerID'] = AuthService.currentUser.uid;
        map['description'] = descriptionController.text;
        map['communityPhotoURL'] = await uploadImage(communityID);
        await DatabaseService.communityRef.doc(communityID).set(map);
      }
    }
  }

  Future<String> uploadImage(String id) async {
    TaskSnapshot ts =
        await FirebaseStorage.instance.ref().child('community').child(id).putFile(file!);
    return ts.ref.getDownloadURL();
  }
}
