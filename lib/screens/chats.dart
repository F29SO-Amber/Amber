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
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 50.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                ProfilePicture(side: 100, path: 'assets/camera.png'),
                ProfilePicture(side: 100, path: 'assets/gallery.png'),
              ],
            ),
          )),
    );
  }
}
