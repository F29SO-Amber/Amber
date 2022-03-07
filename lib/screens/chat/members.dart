import 'package:flutter/material.dart';
import 'package:amber/screens/chat/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:amber/screens/chat/rooms.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import '../../widgets/setting_item.dart';
import '../../utilities/constants.dart';
import '../../widgets/setting_item.dart';

class Members extends StatefulWidget {
  final types.Room room;
  const Members({Key? key, required this.room}) : super(key: key);

  @override
  _MembersState createState() => _MembersState();
}

class _MembersState extends State<Members> {
  Future<void> deleteUserFromFirestore(String userId) async {
  await FirebaseFirestore.instance
      .collection('rooms')
      .doc(widget.room.id)
      .delete();
}
  void onLeavingGroup() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    for (int i = 0; i < widget.room.users.length; i++) {
      if (widget.room.users[i] == uid) {
        widget.room.users.removeAt(i);
      }
    }
    await FirebaseFirestore.instance
        .collection('rooms')
        .doc(widget.room.id)
        .update({'rooms': widget.room.users});

    await FirebaseFirestore.instance
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
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: kAppBar,
      body: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                SizedBox(
                  height: size.height / 20,
                ),
                Container(
                    width: size.width / 1.1,
                    child: Text(
                      "${widget.room.users.length} Members",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: size.width / 20,
                        fontWeight: FontWeight.w500,
                      ),
                    )),
                SizedBox(
                  height: size.height / 20,
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                UsersPage()));
                  },

                  leading: Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                  title: Text(
                    "Add Members",
                    style: TextStyle(
                        fontSize: size.width / 22,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ),
                Flexible(
                    child: ListView.builder(
                      itemCount: widget.room.users.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final user = widget.room.users[index];
                        // bool isSelected = false;
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Row(
                            children: [
                              _buildAvatar(user),
                              Text(getUserName(user)),
                            ],
                          ),
                        );
                      })),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () {
                          deleteUserFromFirestore(widget.room.id);
                        },
                        leading: Icon(
                          Icons.logout,
                          color: Colors.black,
                        ),
                        title: Text(
                          "Leave Group",
                          style: TextStyle(
                              fontSize: size.width / 22,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                      )
                    ],
                  ),
                )
              ],

            ),
      ),
    );
  }

  Widget _buildAvatar(types.User user) {
    final color = getUserAvatarNameColor(user);
    final hasImage = user.imageUrl != null;
    final name = getUserName(user);

    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: CircleAvatar(
        backgroundColor: hasImage ? Colors.transparent : color,
        backgroundImage: hasImage ? NetworkImage(user.imageUrl!) : null,
        radius: 20,
        child: !hasImage
            ? Text(
                name.isEmpty ? '' : name[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              )
            : null,
      ),

    );
  }
}
