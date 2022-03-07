import 'package:amber/screens/chat/members.dart';
import 'package:amber/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:amber/screens/chat/rooms.dart';
import '../../utilities/constants.dart';
import '../../widgets/profile_picture.dart';
import '../../widgets/setting_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RoomInfo extends StatefulWidget {
  final types.Room room;
  const RoomInfo({Key? key, required this.room}) : super(key: key);

  @override
  _RoomInfoState createState() => _RoomInfoState();
}

class _RoomInfoState extends State<RoomInfo> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void onLeavingGroup() async {
      String uid = _auth.currentUser!.uid;
      for (int i = 0; i < widget.room.users.length; i++) {
        if (widget.room.users[i] == uid) {
          widget.room.users.removeAt(i);
        }
      }

      await _firestore
          .collection('rooms')
          .doc(widget.room.id)
          .update({"rooms": widget.room.users.length});

      await _firestore
          .collection("users")
          .doc(uid)
          .collection("rooms")
          .doc(widget.room.id)
          .delete();
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => RoomsPage()), (route) => false);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(kAppName),
        backgroundColor: kAppColor,
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 15),
            CustomImage(
              side: 90,
              image: NetworkImage('${widget.room.imageUrl}'),
              borderRadius: 25,
            ),
            const SizedBox(height: 15),
            Text('${widget.room.name}', style: kDarkLabelTextStyle),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  SettingItem(
                    title: "Mashed up Posts",
                    leadingIcon: Icons.post_add,
                    bgIconColor: Colors.blue,
                    onTap: () {
                      // Get.toNamed('/space');
                    },
                  ),
                  SettingItem(
                    title: "Members",
                    leadingIcon: Icons.people,
                    bgIconColor: Colors.green,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => Members(room: widget.room)),
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
