import 'package:amber/models/post.dart';
import 'package:amber/services/auth_service.dart';
import 'package:amber/services/database_service.dart';
import 'package:amber/widgets/post_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:amber/utilities/constants.dart';

class HomePage extends StatefulWidget {
  static const id = '/home';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<UserPost>> getPosts() async {
    QuerySnapshot followingUsers = await DatabaseService.followingRef
        .doc(AuthService.currentUser.uid)
        .collection('userFollowing')
        .get();

    List<String> following = followingUsers.docs.map((e) => e.id).toList();

    List<UserPost> posts = [];

    for (String userID in following) {
      posts.addAll(
        ((await DatabaseService.postsRef.where('authorId', isEqualTo: userID).get()).docs).map(
          (e) => UserPost(post: PostModel.fromDocument(e)),
        ),
      );
    }

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
