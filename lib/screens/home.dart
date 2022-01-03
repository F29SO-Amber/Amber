import 'package:flutter/material.dart';
import 'package:amber/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const id = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: createRandomColor(),
      body: Center(
        child: ElevatedButton(
          child: const Text('Home'),
          onPressed: () {
            Navigator.pushNamed(context, '/home2');
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.amber, // background
            onPrimary: Colors.black, // foreground
          ),
        ),
      ),
    );
  }
}
