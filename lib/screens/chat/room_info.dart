import 'dart:io';

import 'package:amber/screens/chat/mashed_up_posts.dart';
import 'package:amber/screens/chat/members.dart';
import 'package:amber/screens/chat/users.dart';
import 'package:amber/services/auth_service.dart';
import 'package:amber/services/database_service.dart';
import 'package:amber/services/image_service.dart';
import 'package:amber/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:amber/screens/chat/rooms.dart';
import 'package:amber/utilities/constants.dart';
import 'package:amber/widgets/profile_picture.dart';
import 'package:amber/widgets/setting_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RoomInfo extends StatefulWidget {
  final types.Room room;
  const RoomInfo({Key? key, required this.room}) : super(key: key);

  @override
  _RoomInfoState createState() => _RoomInfoState();
}

class _RoomInfoState extends State<RoomInfo> {
  final TextEditingController _textFieldController = TextEditingController();
  File? profilePic;
  String? codeDialog;
  String? valueText;

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
                image: profilePic == null
                    ? NetworkImage('${widget.room.imageUrl}')
                    : FileImage(profilePic!) as ImageProvider,
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
                        title: "Edit Group Profile Picture",
                        leadingIcon: Icons.image,
                        bgIconColor: Colors.brown,
                        onTap: () async {
                          File? file = await ImageService.chooseFromGallery();
                          if (file != null) {
                            setState(() => profilePic = file);
                            String url = await StorageService.uploadImage(
                                widget.room.id, file, 'room_profile_pic');
                            DatabaseService.roomsRef.doc(widget.room.id).update({'imageUrl': url});
                          }
                        },
                      ),
                    if (widget.room.type == types.RoomType.group)
                      SettingItem(
                          title: "Edit Group Name",
                          leadingIcon: Icons.edit_attributes,
                          bgIconColor: Colors.cyan,
                          onTap: () async {
                            await _displayTextInputDialog(context);
                            if (codeDialog!.isNotEmpty) {
                              DatabaseService.roomsRef
                                  .doc(widget.room.id)
                                  .update({'name': codeDialog});
                              _textFieldController.clear();
                              setState(() {});
                            }
                          }),
                    SettingItem(
                      title: "Mashed up Posts",
                      leadingIcon: Icons.post_add,
                      bgIconColor: Colors.blue,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => MashedUpPosts(room: widget.room),
                          ),
                        );
                      },
                    ),
                    if (widget.room.type == types.RoomType.group &&
                        widget.room.metadata!['createdBy'] == AuthService.currentUser.uid)
                      SettingItem(
                        title: "Modify Members",
                        leadingIcon: Icons.edit,
                        bgIconColor: Colors.brown,
                        onTap: () async {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => UsersPage(
                                oldMembers: widget.room.users,
                                room: widget.room,
                              ),
                            ),
                          );
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
                                "Delete ${widget.room.type == types.RoomType.group ? 'Group ' : ''}Chat",
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
        context,
        MaterialPageRoute(builder: (_) => const RoomsPage()),
        (route) => false,
      );
    }
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

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Name your group'),
            content: TextField(
              onChanged: (value) {
                setState(() => valueText = value);
              },
              controller: _textFieldController,
              decoration: const InputDecoration(hintText: "eg: Core Four"),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                textColor: Colors.white,
                child: const Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: const Text('OK'),
                onPressed: () {
                  setState(() {
                    codeDialog = valueText;
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }
}
