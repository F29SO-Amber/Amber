import 'package:amber/models/post.dart';
import 'package:amber/services/auth_service.dart';
import 'package:amber/services/database_service.dart';
import 'package:amber/widgets/post_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:amber/utilities/constants.dart';

class postscroller extends StatefulWidget {
  static const id = '/postscroller';
  static late String postID;

  const postscroller({Key? key}) : super(key: key);

  @override
  State<postscroller> createState() => _postscrollerState();
}

class _postscrollerState extends State<postscroller> {
  Future<List<UserPost>> getPosts() async {
    print(postscroller.postID);

    List<UserPost> posts = [];

    posts.addAll(
      ((await DatabaseService.postsRef
                  .where('id', isEqualTo: postscroller.postID)
                  .get())
              .docs)
          .map(
        (e) => UserPost(post: PostModel.fromDocument(e)),
      ),
    );

    return posts;
  }

  @override
  void initState() {
    super.initState();
    getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: createRandomColor(),
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text(
          kAppName,
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
      body: StreamBuilder(
        stream: getPosts().asStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView(
              children: snapshot.data as List<UserPost>,
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
