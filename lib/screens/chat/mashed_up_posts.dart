import 'package:amber/models/post.dart';
import 'package:amber/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import '../../pages/mash_up_collaborative.dart';
import '../../services/database_service.dart';

class MashedUpPosts extends StatefulWidget {
  final types.Room room;
  const MashedUpPosts({Key? key, required this.room}) : super(key: key);

  @override
  _MashedUpPostsState createState() => _MashedUpPostsState();
}

class _MashedUpPostsState extends State<MashedUpPosts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kAppBar,
      body: StreamBuilder(
        stream: DatabaseService.roomsRef
            .doc(widget.room.id)
            .collection('posts')
            .snapshots()
            .map((snapshot) => snapshot.docs.map((e) => e.id)),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            List list = (snapshot.data as dynamic).toList() as List<String>;
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                return StreamBuilder(
                    stream: DatabaseService.postsRef.doc(list[index]).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        PostModel post = PostModel.fromDocument(snapshot.data as DocumentSnapshot);
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => CollaborativeMashUpScreen(
                                  imageURL: post.imageURL,
                                  username: post.authorUserName,
                                  mashupDetails: {'roomId': widget.room.id, 'postId': list[index]},
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(list[index]),
                          ),
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    });
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
