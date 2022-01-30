import 'package:flutter/material.dart';

class CommunityPage extends StatefulWidget {
  static const id = '/community';
  final String userUID;

  const CommunityPage({Key? key, required this.userUID}) : super(key: key);

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Community',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
      body: const Center(child: Text('Community')),
    );
  }
}
