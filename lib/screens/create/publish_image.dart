import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:amber/models/user.dart';
import 'package:amber/models/hashtag.dart';
import 'package:amber/utilities/constants.dart';
import 'package:amber/services/auth_service.dart';
import 'package:amber/services/image_service.dart';
import 'package:amber/widgets/profile_picture.dart';
import 'package:amber/services/storage_service.dart';
import 'package:amber/services/database_service.dart';

class PublishImageScreen extends StatefulWidget {
  static const id = '/publish_image';

  final List? mashUpDetails;

  const PublishImageScreen({Key? key, this.mashUpDetails}) : super(key: key);

  @override
  _PublishImageScreenState createState() => _PublishImageScreenState();
}

class _PublishImageScreenState extends State<PublishImageScreen> {
  File? _file;
  List _selectedHashtags = [];
  bool _uploadButtonPresent = true;
  final _formKey = GlobalKey<FormState>();
  final _captionController = TextEditingController();
  final _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.mashUpDetails != null) {
      _file = File(widget.mashUpDetails![0]);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _captionController.dispose();
    _locationController.dispose();
    debugPrint('cllaed');
    // _disposeUserPostChanges(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppColor,
        title: const Text('Create a Post', style: TextStyle(fontSize: 18, color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            color: Colors.white,
            onPressed: () => _disposeUserPostChanges(true),
          ),
          Visibility(
            visible: _uploadButtonPresent,
            child: IconButton(
              icon: const Icon(Icons.publish),
              color: Colors.white,
              onPressed: () async {
                setState(() => _uploadButtonPresent = false);
                EasyLoading.show(status: 'Uploading...');
                await _addUserPost();
                EasyLoading.dismiss();
                _disposeUserPostChanges(true);
                if (widget.mashUpDetails != null) {
                  Navigator.pop(context);
                }
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
                      height: MediaQuery.of(context).size.width,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: (widget.mashUpDetails != null)
                              ? FileImage(File(widget.mashUpDetails![0]))
                              : (_file == null)
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
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(left: 15, top: 20),
                    child: TextFormField(
                      controller: _captionController,
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
                      controller: _locationController,
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
                            items: Hashtag.hashtags
                                .map((tag) => MultiSelectItem<Hashtag>(tag, tag.name))
                                .toList(),
                            onConfirm: (values) {
                              _selectedHashtags = values;
                              setState(() {});
                            },
                            chipDisplay: MultiSelectChipDisplay(
                              onTap: (value) {
                                setState(() => _selectedHashtags.remove(value));
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
      ),
    );
  }

  void _disposeUserPostChanges(bool reset) {
    _file = null;
    _locationController.text = '';
    _captionController.text = '';
    _selectedHashtags = [];
    _uploadButtonPresent = true;
    _selectedHashtags.clear();
    if (reset) setState(() {});
  }

  Future<void> _addUserPost() async {
    UserModel user = await DatabaseService.getUser(AuthService.currentUser.uid);
    if (_formKey.currentState!.validate()) {
      Map<String, Object?> map = {};
      if (_file != null) {
        String postId = const Uuid().v4();
        map['id'] = postId;
        map['location'] = (widget.mashUpDetails != null)
            ? 'Mashed-up from ${widget.mashUpDetails![1]}'
            : _locationController.text;
        map['imageURL'] = await StorageService.uploadImage(postId, _file!, 'posts');
        map['caption'] = _captionController.text;
        map['likes'] = {};
        map['authorId'] = AuthService.currentUser.uid;
        map['timestamp'] = Timestamp.now();
        map['authorName'] = user.firstName;
        map['authorUserName'] = user.username;
        map['authorProfilePhotoURL'] = user.imageUrl;
        await DatabaseService.postsRef.doc(postId).set(map);
        for (Hashtag tag in _selectedHashtags) {
          _addPostHashtag(postId, tag.name);
        }
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Image Posted!")));
      }
    }
  }

  Future<void> _addPostHashtag(postId, hashtag) async {
    Map<String, Object?> map = {};
    map['post_id'] = postId;
    map['hashtag'] = hashtag;
    await DatabaseService.hashtagsRef.doc().set(map);
  }
}
