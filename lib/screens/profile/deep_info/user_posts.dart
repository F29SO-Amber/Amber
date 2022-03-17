import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'package:amber/utilities/constants.dart';
import 'package:amber/services/database_service.dart';

class CurrentUserPosts extends StatefulWidget {
  static const id = '/CurrentUserPosts';
  final String coll;
  final String uid;
  final int index;

  const CurrentUserPosts({Key? key, required this.uid, required this.index, required this.coll})
      : super(key: key);

  @override
  State<CurrentUserPosts> createState() => _CurrentUserPostsState();
}

class _CurrentUserPostsState extends State<CurrentUserPosts> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

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
        stream: DatabaseService.getUserPosts(widget.coll, widget.uid).asStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            ScrollablePositionedList list = ScrollablePositionedList.builder(
              itemCount: (snapshot.data! as dynamic).length,
              itemBuilder: (context, index) => (snapshot.data! as dynamic)[index],
              itemScrollController: itemScrollController,
              itemPositionsListener: itemPositionsListener,
              initialScrollIndex: widget.index,
            );
            return list;
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
