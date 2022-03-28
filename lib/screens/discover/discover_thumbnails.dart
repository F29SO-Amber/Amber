import 'package:amber/models/thumbnail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:amber/services/database_service.dart';
import 'package:amber/user_data.dart';
import 'package:amber/utilities/constants.dart';
import 'package:amber/widgets/feed_entity.dart';

class DiscoverThumbnails extends StatelessWidget {
  static const id = '/discover_thumbnails';

  const DiscoverThumbnails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kAppBar,
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: DatabaseService.thumbnailsRef
              .where('authorId', isNotEqualTo: UserData.currentUser!.id)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var list = (snapshot.data as QuerySnapshot).docs.toList();
              return list.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.only(top: 120.0),
                      child: Center(child: Text('No thumbnails to display!')),
                    )
                  : ListView.builder(
                      itemCount: list.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => FeedEntity(feedEntity: list[index]),
                    );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
