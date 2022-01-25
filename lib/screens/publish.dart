import 'dart:io';
import 'package:amber/services/image_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

class PublishScreen extends StatefulWidget {
  static const id = '/publish';
  final String mashUpLink;

  const PublishScreen({Key? key, required this.mashUpLink}) : super(key: key);

  @override
  _PublishScreenState createState() => _PublishScreenState();
}

class _PublishScreenState extends State<PublishScreen> {
  File? file;
  List _selectedHashtags = [];
  bool uploadButtonPresent = true;
  final _formKey = GlobalKey<FormState>();
  final captionController = TextEditingController();
  final locationController = TextEditingController();

  // @override
  // void initState() {
  //   super.initState();
  //   getLocation();
  // }

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
                if (_formKey.currentState!.validate() && file != null) {
                  await DatabaseService.addUserPost(
                    file!,
                    captionController.text,
                    locationController.text,
                  );
                }
                EasyLoading.dismiss();
                disposeUserPostChanges();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Image Posted!")),
                );
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
                          fit: BoxFit.cover,
                          image: (widget.mashUpLink.isNotEmpty)
                              ? FileImage(File(widget.mashUpLink))
                              : (file == null)
                                  ? const AssetImage('assets/taptoselect.png')
                                  : FileImage(file!) as ImageProvider,
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
                                            file = await ImageService.chooseFromCamera();
                                            setState(() {});
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
                                            file = await ImageService.chooseFromGallery();
                                            setState(() {});
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

  void disposeUserPostChanges() {
    setState(() {
      file = null;
      locationController.text = '';
      captionController.text = '';
      _selectedHashtags = [];
      uploadButtonPresent = true;
    });
  }

  // void getLocation() async {
  //   Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //   print(position);
  // }
}
