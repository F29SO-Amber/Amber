import 'package:flutter/material.dart';

import 'package:amber/models/user.dart';
import 'package:amber/screens/profile/profile.dart';
import 'package:amber/widgets/user_card.dart';
import 'package:amber/utilities/constants.dart';
import 'package:amber/services/database_service.dart';

class UserList extends StatelessWidget {
  final String userUID;
  final bool followers;

  const UserList({Key? key, required this.userUID, required this.followers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.amber, title: const Text(kAppName)),
      body: FutureBuilder(
        future: (followers)
            ? DatabaseService.getFollowersUIDs(userUID)
            : DatabaseService.getFollowingUID(userUID),
        builder: (context, snapshot) {
          // TODO: Keeps loading forever
          if (snapshot.data != null) {
            List<UserCard> list = [];
            var a = snapshot.data as List<UserModel>;
            for (UserModel user in a) {
              list.add(
                UserCard(
                  user: user,
                  onPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage(userUID: user.id)),
                    );
                  },
                ),
              );
            }
            return ListView(children: list);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
