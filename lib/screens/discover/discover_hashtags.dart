import 'package:amber/models/post.dart';
import 'package:amber/services/database_service.dart';
import 'package:amber/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../widgets/feed_entity.dart';

class DiscoverHashtags extends StatefulWidget {
  static const id = '/discover_hashtags';
  final String hashtag;

  const DiscoverHashtags({Key? key, required this.hashtag}) : super(key: key);

  @override
  State<DiscoverHashtags> createState() => _DiscoverHashtagsState();
}

class _DiscoverHashtagsState extends State<DiscoverHashtags> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kAppBar,
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream:
              DatabaseService.postsRef.where("hashtags", arrayContains: widget.hashtag).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var list = (snapshot.data as QuerySnapshot).docs.toList();
              return list.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.only(top: 120.0),
                      child: Center(child: Text('No posts to display!')),
                    )
                  : ListView.builder(
                      itemCount: list.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) =>
                          FeedEntity(feedEntity: PostModel.fromDocument(list[index])));
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
