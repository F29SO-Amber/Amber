import 'package:flutter/material.dart';

import 'package:amber/widgets/post_widget.dart';
import 'package:amber/utilities/constants.dart';
import 'package:amber/services/database_service.dart';

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
        // TODO: Use firebase functions
        stream: DatabaseService.getUserFeed().asStream(), // TODO
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView(children: snapshot.data as List<UserPost>);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
