import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:amber/models/user.dart';
import 'package:amber/screens/profile.dart';
import 'package:amber/widgets/user_card.dart';
import 'package:amber/utilities/constants.dart';
import 'package:amber/services/auth_service.dart';
import 'package:amber/services/database_service.dart';

class DiscoverPage extends StatefulWidget {
  static const id = '/discover';

  const DiscoverPage({Key? key}) : super(key: key);

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

/*
  Discover Page helps users to discover various other users and communities that
  they might be interested in following or having a glance at.
*/
class _DiscoverPageState extends State<DiscoverPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber, //sets the color to amber
        title: const Text(kAppName), //Title of the app
      ),
      body: FutureBuilder(
        future: DatabaseService.usersRef.get(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          //Show a list of the current users in the app
          List<UserCard> list = [];
          snapshot.data?.docs.forEach((doc) {
            UserModel user = UserModel.fromDocument(doc);
            if (user.id != AuthService.currentUser.uid) {
              list.add(
                UserCard(
                  user: user,
                  onPress: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ProfilePage(userUID: user.id)));
                  },
                ),
              );
            }
          });
          return ListView(children: list);
        },
      ),
    );
  }
}
