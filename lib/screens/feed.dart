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
        backgroundColor: Colors.amber,
        title: const Text(kAppName, style: TextStyle(fontSize: 18, color: Colors.white)),
      ),
      body: StreamBuilder(
        stream: DatabaseService.getUserFeed().asStream(),
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
