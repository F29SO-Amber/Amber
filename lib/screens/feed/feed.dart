import 'package:amber/user_data.dart';
import 'package:flutter/material.dart';

import 'package:amber/widgets/post_widget.dart';
import 'package:amber/utilities/constants.dart';
import 'package:amber/services/database_service.dart';

import '../../models/post.dart';

class FeedPage extends StatefulWidget {
  static const id = '/feed';

  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppColor,
        title: const Text(kAppName),
        titleTextStyle: const TextStyle(color: Colors.white, letterSpacing: 3, fontSize: 25.0),
      ),
      body: StreamBuilder(
        stream: DatabaseService.timelineRef
            .doc(UserData.currentUser!.id)
            .collection('timelinePosts')
            .snapshots()
            .map((snapshot) => snapshot.docs.map((e) => PostModel.fromDocument(e))),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List list = (snapshot.data as dynamic).toList() as List;
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                return UserPost(post: list[index]);
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
