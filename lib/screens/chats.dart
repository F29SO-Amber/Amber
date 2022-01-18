import 'dart:io';

import 'package:amber/services/auth_service.dart';
import 'package:amber/widgets/post_widget.dart';
import 'package:amber/widgets/profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:amber/utilities/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:amber/screens/post.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({Key? key}) : super(key: key);
  static const id = '/chats';

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  File? file;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: createRandomColor(),
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text(
          kAppName,
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const UserPost(),
          GestureDetector(
            child: const Center(child: Text('To be implemented!')),
            onTap: () => showMaterialModalBottomSheet(
              expand: false,
              // shape: RoundedRectangleBorder(
              //   borderRadius: BorderRadius.circular(33),
              // ),
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) => const ModalFit(),
            ),
          ),
        ],
      ),
    );
  }
}

class ModalFit extends StatelessWidget {
  const ModalFit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String currentUserId = AuthService.currentUser.uid;
    PostPage func = PostPage(currentUserId: currentUserId);
    XFile? xFile;
    File? file;
    handleTakePhoto() async {
      //Navigator.pop(dialogContext);
      //Navigator.of(context, rootNavigator: true).pop();
      XFile? xFile = await ImagePicker().pickImage(source: ImageSource.camera);
      file = File('${xFile?.path}');
      //return file;
    }

    handleChooseFromGallery() async {
      //Navigator.pop(dialogContext);
      XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      file = File('${xFile?.path}');
      //return file;
      //if (!mounted) return;
    }

    return Material(
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
                        onTap: handleTakePhoto,
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
                        onTap: handleChooseFromGallery,
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
    );
  }
}
