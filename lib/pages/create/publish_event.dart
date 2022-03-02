import 'dart:io';
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

class PublishEventScreen extends StatefulWidget {
  static const id = '/publish_event';

  const PublishEventScreen({Key? key}) : super(key: key);

  @override
  _PublishEventScreenState createState() => _PublishEventScreenState();
}

class _PublishEventScreenState extends State<PublishEventScreen> {
  File? _file;
  bool _uploadButtonPresent = true;
  final _formKey = GlobalKey<FormState>();
  final _timeController = TextEditingController();
  final _venueController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _timeController.dispose();
    _titleController.dispose();
    _venueController.dispose();
    _descriptionController.dispose();
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
                EasyLoading.show(status: 'Adding Event...');
                await _addUserEvent();
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
                      controller: _titleController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        hintText: "What's your event called...",
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.text_fields, color: kAppColor, size: 30),
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
                        hintText: "Describe the event...",
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
                      controller: _timeController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        hintText: "When is it taking place...",
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.access_time_sharp, color: kAppColor, size: 30),
                      ),
                    ),
                  ),
                  const Divider(),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(left: 15),
                    child: TextFormField(
                      controller: _venueController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        hintText: "Where is it taking place...",
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
      _timeController.text = '';
      _venueController.text = '';
      _titleController.text = '';
      _uploadButtonPresent = true;
      _descriptionController.text = '';
    });
  }

  Future<void> _addUserEvent() async {
    if (_formKey.currentState!.validate()) {
      Map<String, Object?> map = {};
      if (_file != null) {
        String eventID = const Uuid().v4();
        map['userID'] = AuthService.currentUser.uid;
        map['title'] = _titleController.text;
        map['description'] = _descriptionController.text;
        map['startingTime'] = _timeController.text;
        map['venue'] = _venueController.text;
        map['eventPhotoURL'] = await StorageService.uploadImage(eventID, _file!, 'events');
        await DatabaseService.eventsRef.doc(eventID).set(map);
      }
    }
  }
}
