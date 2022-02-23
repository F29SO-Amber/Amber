import 'package:amber/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:amber/screens/start_page.dart';

class Testing extends StatefulWidget {
  const Testing({Key? key}) : super(key: key);

  @override
  _TestingState createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  @override
  Widget build(BuildContext context) => Provider<Firestore>(
    create: (_) => Firestore.instance,
    child: MaterialApp(
      title: 'Whiteboard Demo',
      home: StartPage(),
    ),
  );
}
