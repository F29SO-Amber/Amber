import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as image;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:amber/models/user.dart';
import 'package:amber/utilities/constants.dart';
import 'package:amber/services/auth_service.dart';
import 'package:amber/widgets/profile_picture.dart';
import 'package:amber/services/database_service.dart';

class PublishScreen extends StatefulWidget {
  static const id = '/publish';

  const PublishScreen({Key? key}) : super(key: key);

  @override
  _PublishScreenState createState() => _PublishScreenState();
}

class _PublishScreenState extends State<PublishScreen> {
  File? file;
  bool uploadButtonPresent = true;
  List _selectedHashtags = [];
  final _formKey = GlobalKey<FormState>();
  final captionController = TextEditingController();
  final locationController = TextEditingController();
  static final List<Hashtag> _hashtags = [
    Hashtag(id: 1, name: "Lion"),
    Hashtag(id: 2, name: "Flamingo"),
    Hashtag(id: 3, name: "Hippo"),
    Hashtag(id: 4, name: "Horse"),
    Hashtag(id: 5, name: "Tiger"),
    Hashtag(id: 6, name: "Penguin"),
    Hashtag(id: 7, name: "Spider"),
    Hashtag(id: 8, name: "Snake"),
    Hashtag(id: 9, name: "Bear"),
    Hashtag(id: 10, name: "Beaver"),
    Hashtag(id: 11, name: "Cat"),
    Hashtag(id: 12, name: "Fish"),
    Hashtag(id: 13, name: "Rabbit"),
    Hashtag(id: 14, name: "Mouse"),
    Hashtag(id: 15, name: "Dog"),
    Hashtag(id: 16, name: "Zebra"),
    Hashtag(id: 17, name: "Cow"),
    Hashtag(id: 18, name: "Frog"),
    Hashtag(id: 19, name: "Blue Jay"),
    Hashtag(id: 20, name: "Moose"),
    Hashtag(id: 21, name: "Gecko"),
    Hashtag(id: 22, name: "Kangaroo"),
    Hashtag(id: 23, name: "Shark"),
    Hashtag(id: 24, name: "Crocodile"),
    Hashtag(id: 25, name: "Owl"),
    Hashtag(id: 26, name: "Dragonfly"),
    Hashtag(id: 27, name: "Dolphin"),
    Hashtag(id: 28, name: "x"),
  ];
  final _items = _hashtags.map((tag) => MultiSelectItem<Hashtag>(tag, tag.name)).toList();

  @override
  void dispose() {
    super.dispose();
    captionController.dispose();
    locationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppColor,
        title: const Text(
          'Create a Post',
          style: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            color: Colors.black54,
            onPressed: () => disposeUserPostChanges(),
          ),
          Visibility(
            visible: uploadButtonPresent,
            child: IconButton(
              icon: const Icon(Icons.publish),
              color: Colors.black54,
              onPressed: () async {
                setState(() => uploadButtonPresent = false);
                EasyLoading.show(status: 'Uploading...');
                await addUserPost();
                EasyLoading.dismiss();
                disposeUserPostChanges();
              },
            ),
          ),
        ],
      ),
      body: Column(
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
                                            side: 100, path: 'assets/gallery.png'),
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
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(left: 15, top: 20),
                  child: TextFormField(
                    controller: captionController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      hintText: "Write a caption...",
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.create_sharp, color: kAppColor, size: 30),
                    ),
                  ),
                ),
                const Divider(),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(left: 15),
                  child: TextFormField(
                    controller: locationController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      //hintText: "Locate your post...",
                      hintText: "Add a location...",
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.pin_drop_outlined, color: kAppColor, size: 30),
                      suffixIcon: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: Icon(Icons.my_location, color: kAppColor, size: 30),
                      ),
                    ),
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.only(left: 28, right: 7),
                  child: Row(
                    children: [
                      const Icon(FontAwesomeIcons.hashtag, color: kAppColor, size: 25),
                      Expanded(
                        child: MultiSelectBottomSheetField(
                          buttonIcon: const Icon(FontAwesomeIcons.arrowDown, color: kAppColor),
                          decoration: BoxDecoration(border: Border.all(color: Colors.white)),
                          initialChildSize: 0.4,
                          listType: MultiSelectListType.CHIP,
                          searchable: true,
                          buttonText: Text(
                            (_selectedHashtags.isEmpty)
                                ? "Select your favorite Hashtags..."
                                : "Your selected Hashtags:",
                            style: const TextStyle(fontSize: 16, color: Colors.black54),
                          ),
                          title: const Text("Hashtags"),
                          items: _items,
                          onConfirm: (values) {
                            _selectedHashtags = values;
                            setState(() {});
                          },
                          chipDisplay: MultiSelectChipDisplay(
                            onTap: (value) {
                              setState(() {
                                _selectedHashtags.remove(value);
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void disposeUserPostChanges() {
    setState(() {
      file = null;
      locationController.text = '';
      captionController.text = '';
      uploadButtonPresent = true;
    });
  }

  Future<void> compressImageFile(String postID) async {
    image.Image? imageFile = image.decodeImage(file!.readAsBytesSync());
    final compressedImageFile = File('${(await getTemporaryDirectory()).path}/img_$postID.jpg')
      ..writeAsBytesSync(image.encodeJpg(imageFile!, quality: 85));
    setState(() => file = compressedImageFile);
  }

  Future<void> addUserPost() async {
    UserModel user = await DatabaseService.getUser(AuthService.currentUser.uid);
    if (_formKey.currentState!.validate()) {
      Map<String, Object?> map = {};
      if (file != null) {
        String postId = const Uuid().v4();
        await compressImageFile(postId);
        map['id'] = postId;
        map['location'] = locationController.text;
        map['imageURL'] = await uploadImage(postId);
        map['caption'] = captionController.text;
        map['likes'] = {};
        map['authorId'] = AuthService.currentUser.uid;
        map['timestamp'] = Timestamp.now();
        map['authorName'] = user.name;
        map['authorUserName'] = user.username;
        map['authorProfilePhotoURL'] = user.profilePhotoURL;
        await DatabaseService.postsRef.doc(postId).set(map);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Image Posted!")));
      }
    }
  }

  Future<String> uploadImage(String pID) async {
    TaskSnapshot ts = await FirebaseStorage.instance.ref().child('posts').child(pID).putFile(file!);
    return ts.ref.getDownloadURL();
  }
}

class Hashtag {
  final int id;
  final String name;

  Hashtag({Key? key, required this.id, required this.name});
}
