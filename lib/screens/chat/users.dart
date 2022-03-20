import 'package:amber/services/auth_service.dart';
import 'package:amber/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:amber/services/database_service.dart';
import 'package:amber/utilities/constants.dart';
import 'chat.dart';

class UsersPage extends StatefulWidget {
  final List<types.User>? oldMembers;
  final types.Room? room;
  const UsersPage({Key? key, this.oldMembers, this.room}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late List<types.User> users;

  @override
  void initState() {
    users = widget.oldMembers != null ? widget.oldMembers! : [];
    super.initState();
  }

  void _handlePressed(BuildContext context) async {
    if (widget.oldMembers == null) {
      if (users.length == 1) {
        final room = await FirebaseChatCore.instance.createRoom(users[0]);
        Navigator.pop(context);
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(builder: (context) => ChatPage(room: room)),
        );
      } else if (users.length > 1) {
        final room = await FirebaseChatCore.instance.createGroupRoom(
          name: '${UserData.currentUser!.username}\'s Group',
          users: users,
          imageUrl: 'https://bit.ly/3sB5zcK',
          metadata: {'createdBy': AuthService.currentUser.uid},
        );
        Navigator.pop(context);
        await Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(builder: (_) => ChatPage(room: room)),
        );
      }
    } else {
      await DatabaseService.roomsRef
          .doc(widget.room!.id)
          .update({'userIds': users.map((e) => e.id).toList()});
      Navigator.pop(context);
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rooms'),
        backgroundColor: kAppColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: () => _handlePressed(context),
          )
        ],
      ),
      body: StreamBuilder<List<types.User>>(
        stream: FirebaseChatCore.instance.users(),
        initialData: const [],
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(bottom: 200),
              child: const Text('No users'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final user = snapshot.data![index];
              // bool isSelected = false;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (!users.contains(user)) {
                      users.add(user);
                    } else {
                      // if (widget.oldMembers != null && !(widget.oldMembers!).contains(user)) {
                      users.remove(user);
                      // }
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: users.contains(user) ? Colors.amber.shade50 : Colors.white,
                  child: Row(
                    children: [
                      _buildAvatar(user),
                      Text(getUserName(user)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
