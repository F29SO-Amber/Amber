import 'package:flutter/material.dart';
import 'package:amber/constants.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({Key? key}) : super(key: key);
  static const id = '/discover';

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: createRandomColor(),
        body: Center(
          child: ElevatedButton(
            child: const Text('Discover'),
            onPressed: () {
              Navigator.pushNamed(context, '/discover2');
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.amber, // background
              onPrimary: Colors.black, // foreground
            ),
          ),
        ),
      ),
    );
  }
}
