import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:amber/utilities/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/post_type.dart';
import 'chat.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'users.dart';

class RoomsPage extends StatefulWidget {
  const RoomsPage({Key? key}) : super(key: key);

  @override
  _RoomsPageState createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  int selectedTab = 0;

  Widget _buildAvatar(types.Room room) {
    var color = Colors.transparent;
    final hasImage = room.imageUrl != null;
    final name = room.name ?? '';

    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: CircleAvatar(
        backgroundColor: hasImage ? Colors.transparent : color,
        backgroundImage: hasImage ? NetworkImage(room.imageUrl!) : null,
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
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => const UsersPage(),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: <Widget>[
                PostType(
                  numOfDivisions: 2,
                  bgColor: Colors.red[100]!,
                  icon: const Icon(FontAwesomeIcons.userAlt),
                  index: 0,
                  currentTab: selectedTab,
                  onPress: () {
                    setState(() => selectedTab = 0);
                  },
                ),
                PostType(
                  numOfDivisions: 2,
                  bgColor: Colors.greenAccent[100]!,
                  icon: const Icon(FontAwesomeIcons.userFriends),
                  index: 1,
                  currentTab: selectedTab,
                  onPress: () {
                    setState(() => selectedTab = 1);
                  },
                ),
              ],
            ),
            StreamBuilder<List<types.Room>>(
              stream: FirebaseChatCore.instance.rooms(),
              initialData: const [],
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(bottom: 200),
                    child: const Text('No rooms'),
                  );
                }
                List<types.Room> list = snapshot.data!
                    .where((e) =>
                        e.type ==
                        ((selectedTab == 0) ? types.RoomType.direct : types.RoomType.group))
                    .toList();
                return ListView.builder(
                  itemCount: list.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final room = list[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(builder: (context) => ChatPage(room: room)),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          children: [
                            _buildAvatar(room),
                            Text(room.name ?? ''),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
