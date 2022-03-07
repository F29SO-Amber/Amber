import 'package:amber/screens/chat/members.dart';
import 'package:amber/screens/chat/users.dart';
import 'package:amber/services/auth_service.dart';
import 'package:amber/services/database_service.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(kAppName),
        backgroundColor: kAppColor,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.room.type == types.RoomType.group)
                      SettingItem(
                        title: "Edit Group Profile",
                        leadingIcon: Icons.edit_attributes,
                        bgIconColor: Colors.cyan,
                        onTap: () {
                          // Get.toNamed('/space');
                        },
                      ),
                    SettingItem(
                      title: "Mashed up Posts",
                      leadingIcon: Icons.post_add,
                      bgIconColor: Colors.blue,
                      onTap: () {
                        // Get.toNamed('/space');
                      },
                    ),
                    if (widget.room.type == types.RoomType.group &&
                        widget.room.metadata!['createdBy'] == AuthService.currentUser.uid)
                      SettingItem(
                        title: "Modify Members",
                        leadingIcon: Icons.edit,
                        bgIconColor: Colors.brown,
                        onTap: () async {
                          final result = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => UsersPage(oldMembers: widget.room.users),
                            ),
                          );
                          // var map = {};
                          // (result as List<String>).map((e) => map[e] = 'user');
                          await DatabaseService.roomsRef
                              .doc(widget.room.id)
                              .update({'userIds': result});
                          setState(() {});
                        },
                      ),
                    (widget.room.type == types.RoomType.group &&
                            widget.room.metadata!['createdBy'] != AuthService.currentUser.uid)
                        ? SettingItem(
                            title: "Leave Group Chat",
                            leadingIcon: Icons.exit_to_app,
                            bgIconColor: Colors.red,
                            onTap: () => onLeavingGroup(),
                          )
                        : SettingItem(
                            title:
                                "Delete ${widget.room.type == types.RoomType.group ? 'Group' : ''}Chat",
                            leadingIcon: Icons.delete,
                            bgIconColor: Colors.red,
                            onTap: () => deleteRoom(widget.room.id),
                          ),
                    const SizedBox(height: 15),
                    Text('Members', style: kDarkLabelTextStyle, textAlign: TextAlign.start),
                    const SizedBox(height: 10),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.room.users.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final user = widget.room.users[index];
                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            children: [
                              _buildAvatar(user),
                              Text(getUserName(user)),
                            ],
                          ),
                        );
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void onLeavingGroup() async {
    if (widget.room.metadata!['createdBy'] != AuthService.currentUser.uid) {
      List<String> list = widget.room.users.map((e) => e.id).toList();
      list.remove(AuthService.currentUser.uid);
      await FirebaseFirestore.instance
          .collection('rooms')
          .doc(widget.room.id)
          .update({'userIds': list});

      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (_) => const RoomsPage()), (route) => false);
    } else {
      // TODO: Show alert that an admin can't leave
    }
  }

  void updateRoom(types.Room room) async {
    if (AuthService.currentUser == null) return;

    final roomMap = room.toJson();
    roomMap.removeWhere((key, value) =>
        key == 'createdAt' || key == 'id' || key == 'lastMessages' || key == 'users');

    if (room.type == types.RoomType.direct) {
      roomMap['imageUrl'] = null;
      roomMap['name'] = null;
    }

    roomMap['lastMessages'] = room.lastMessages?.map((m) {
      final messageMap = m.toJson();

      messageMap.removeWhere((key, value) =>
          key == 'author' || key == 'createdAt' || key == 'id' || key == 'updatedAt');

      messageMap['authorId'] = m.author.id;

      return messageMap;
    }).toList();
    roomMap['updatedAt'] = FieldValue.serverTimestamp();
    roomMap['userIds'] = room.users.map((u) => u.id).toList();

    await DatabaseService.roomsRef.doc(room.id).update(roomMap);
  }

  Future<void> deleteRoom(String roomId) async {
    await DatabaseService.roomsRef.doc(roomId).delete();
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
