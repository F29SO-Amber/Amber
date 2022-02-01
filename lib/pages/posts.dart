// import 'package:amber/models/hashtag.dart';
// import 'package:amber/models/post.dart';
// import 'package:amber/services/database_service.dart';
// import 'package:amber/widgets/post_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
//
// class Posts extends StatefulWidget {
//   final String tag;
//   const Posts({Key? key, required this.tag}) : super(key: key);
//
//   @override
//   _PostsState createState() => _PostsState();
// }
//
// class _PostsState extends State<Posts> {
//   final ItemScrollController itemScrollController = ItemScrollController();
//   final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
//
//   Future<List<String>> getPostsIDS() async {
//         return (await DatabaseService.hashtagsRef.where('hashtag', isEqualTo: widget.tag).get())
//             .docs
//             .map((e) => HashtagModel.fromDocument(e).postID)
//             .toList();
//     // PostModel.fromDocument(await DatabaseService.postsRef.doc(uid).get());
//   }
//
//   getPosts() async {
//     List<PostModel> list = ge
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: DatabaseService.hashtagsRef.where('hashtag', isEqualTo: widget.tag).snapshots(),
//       builder: (_, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           ScrollablePositionedList list = ScrollablePositionedList.builder(
//             itemCount: (snapshot.data! as dynamic).length,
//             itemBuilder: (context, index) => UserPost(
//                 post: PostModel.fromDocument(DatabaseService.postsRef
//                     .doc(HashtagModel.fromDocument((snapshot.data! as dynamic)[index]).postID)
//                     .get())),
//             itemScrollController: itemScrollController,
//             itemPositionsListener: itemPositionsListener,
//           );
//           return list;
//         } else {
//           return const Center(child: CircularProgressIndicator());
//         }
//       },
//     );
//   }
// }
