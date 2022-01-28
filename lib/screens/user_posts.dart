import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'package:amber/models/post.dart';
import 'package:amber/widgets/post_widget.dart';
import 'package:amber/utilities/constants.dart';
import 'package:amber/services/database_service.dart';

class CurrentUserPosts extends StatefulWidget {
  static const id = '/CurrentUserPosts';
  final String uid;
  final int index;

  const CurrentUserPosts({Key? key, required this.uid, required this.index}) : super(key: key);

  @override
  State<CurrentUserPosts> createState() => _CurrentUserPostsState();
}

class _CurrentUserPostsState extends State<CurrentUserPosts> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  Future<List<UserPost>> getPosts() async {
    List<UserPost> posts = [];
    posts.addAll(
      ((await DatabaseService.postsRef
                  .where('authorId', isEqualTo: widget.uid)
                  .orderBy('timestamp', descending: true)
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

      // backgroundColor: createRandomColor(),
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
            ScrollablePositionedList list = ScrollablePositionedList.builder(
              itemCount: (snapshot.data! as dynamic).length,
              itemBuilder: (context, index) => (snapshot.data! as dynamic)[index],
              itemScrollController: itemScrollController,
              itemPositionsListener: itemPositionsListener,
              initialScrollIndex: widget.index,
            );
            // itemScrollController.jumpTo(index: 3);
            return list;
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}




