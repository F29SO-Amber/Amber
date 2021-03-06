// Package Imports
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

// Local Imports
import 'package:amber/user_data.dart';
import 'package:amber/models/user.dart';
import 'package:amber/models/hashtag.dart';
import 'package:amber/models/community.dart';
import 'package:amber/utilities/constants.dart';
import 'package:amber/services/auth_service.dart';
import 'package:amber/services/image_service.dart';
import 'package:amber/widgets/profile_picture.dart';
import 'package:amber/services/storage_service.dart';
import 'package:amber/services/database_service.dart';

class PublishImageScreen extends StatefulWidget {
  static const id = '/publish_image';

  final List? mashUpDetails;
  final types.Room? room;
  final String? postId;

  const PublishImageScreen({Key? key, this.mashUpDetails, this.room, this.postId})
      : super(key: key);

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
    if (widget.mashUpDetails != null) {
      setState(() => _file = File(widget.mashUpDetails![0]));
    }
    super.initState();
  }

  @override
  void dispose() {
    _captionController.dispose();
    _locationController.dispose();
    super.dispose();
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
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  showMaterialModalBottomSheet(
                    expand: false,
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) => Material(
                      child: SafeArea(
                        top: false,
                        child: SizedBox(
                          height: 500,
                          width: MediaQuery.of(context).size.width,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 25.0),
                                  child: Text('Post media to:', style: kDarkLabelTextStyle),
                                ),
                                FutureBuilder(
                                  future: DatabaseService.getUserCommunities(
                                      AuthService.currentUser.uid),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      var communities = snapshot.data as List<CommunityModel>;
                                      List<dynamic> list = [UserData.currentUser!, ...communities];
                                      return GridView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: list.length,
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 0,
                                          mainAxisSpacing: 0,
                                          childAspectRatio: 1,
                                        ),
                                        itemBuilder: (BuildContext context, int index) {
                                          if (index == 0) {
                                            UserModel user = list[index];
                                            return GestureDetector(
                                              child: Column(
                                                children: [
                                                  CustomImage(
                                                      side: 100,
                                                      image: NetworkImage(user.imageUrl)),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(vertical: 10.0),
                                                    child: Text('My Profile',
                                                        style: kLightLabelTextStyle),
                                                  ),
                                                ],
                                              ),
                                              onTap: () async {
                                                setState(() => _uploadButtonPresent = false);
                                                EasyLoading.show(status: 'Uploading...');
                                                await _addUserPost(false, '');
                                                EasyLoading.dismiss();
                                                _disposeUserPostChanges(true);
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              },
                                            );
                                          } else {
                                            CommunityModel community = list[index];
                                            return GestureDetector(
                                              child: Column(
                                                children: [
                                                  CustomImage(
                                                    side:
                                                        MediaQuery.of(context).size.width * 0.8 / 3,
                                                    image:
                                                        NetworkImage(community.communityPhotoURL),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 10.0),
                                                    child: Text(community.name,
                                                        style: kLightLabelTextStyle),
                                                  ),
                                                ],
                                              ),
                                              onTap: () async {
                                                setState(() => _uploadButtonPresent = false);
                                                EasyLoading.show(status: 'Uploading...');
                                                await _addUserPost(true, community.id);
                                                EasyLoading.dismiss();
                                                _disposeUserPostChanges(true);
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              },
                                            );
                                          }
                                        },
                                      );
                                    } else {
                                      return const Center(child: CircularProgressIndicator());
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  debugPrint('Not validated');
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
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(left: 15, top: 20),
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
                  const Divider(),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(left: 15),
                    child: TextFormField(
                      controller: _locationController,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (_locationController.text.length > 20) {
                          return 'Max Location length is 20';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
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

  Future<void> _addUserPost(bool forCommunity, String communityID) async {
    // UserModel user = await DatabaseService.getUser(AuthService.currentUser.uid);
    if (widget.room != null) {
      for (types.User user in widget.room!.users) {
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
          map['authorId'] = user.id;
          map['forCommunity'] = forCommunity ? communityID : 'No';
          map['timestamp'] = Timestamp.now();
          map['authorName'] =
              forCommunity ? 'Collaboratively with ${widget.room!.name}' : user.firstName;
          map['authorUserName'] = user.firstName;
          map['authorProfilePhotoURL'] = user.imageUrl;
          List<String> tags = [];
          for (Hashtag tag in _selectedHashtags) {
            tags.add(tag.name);
          }
          map['hashtags'] = tags;
          await DatabaseService.postsRef.doc(postId).set(map);
          if (forCommunity) {
            break;
          }
        }
      }
      DatabaseService.roomsRef.doc(widget.room!.id).collection('posts').doc(widget.postId).delete();
    } else {
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
        map['forCommunity'] = forCommunity ? communityID : 'No';
        map['timestamp'] = Timestamp.now();
        map['authorName'] = UserData.currentUser!.firstName;
        map['authorUserName'] = UserData.currentUser!.username;
        map['authorProfilePhotoURL'] = UserData.currentUser!.imageUrl;
        List<String> tags = [];
        for (Hashtag tag in _selectedHashtags) {
          tags.add(tag.name);
        }
        map['hashtags'] = tags;
        await DatabaseService.postsRef.doc(postId).set(map);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Image Posted!")));
      }
    }
  }
}
