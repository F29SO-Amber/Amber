import 'package:amber/widgets/profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:amber/constants.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({Key? key}) : super(key: key);
  static const id = '/chats';

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
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
      body: GestureDetector(
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
    );
  }
}

class ModalFit extends StatelessWidget {
  const ModalFit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                      const ProfilePicture(side: 100, path: 'assets/camera.png'),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text('Camera', style: kLightLabelTextStyle),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const ProfilePicture(side: 100, path: 'assets/gallery.png'),
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
