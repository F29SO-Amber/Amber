import 'package:amber/services/database_service.dart';
import 'package:amber/user_data.dart';
import 'package:amber/utilities/constants.dart';
import 'package:flutter/material.dart';

import '../../models/post.dart';
import '../../widgets/feed_entity.dart';

class DiscoverImages extends StatelessWidget {
  static const id = '/discover_images';

  const DiscoverImages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kAppBar,
      body: StreamBuilder(
        stream: DatabaseService.postsRef
            .where('authorId', isNotEqualTo: UserData.currentUser!.id)
            .snapshots()
            .map((snapshot) => snapshot.docs.map((e) => PostModel.fromDocument(e))),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List list = (snapshot.data as dynamic).toList();
            list.sort((a, b) => a.timestamp.compareTo(b.timestamp));
            list = list.reversed.toList();
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) => FeedEntity(feedEntity: list[index]),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
