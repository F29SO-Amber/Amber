import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import '../../utilities/constants.dart';
import '../../widgets/profile_picture.dart';
import '../../widgets/setting_item.dart';

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
                      // Get.toNamed('/space');
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
