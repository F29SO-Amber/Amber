import 'package:amber/widgets/profile_picture.dart';
import 'package:flutter/material.dart';

// TODO: Enhance error page

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/error.jpeg'),
            fit: BoxFit.fitWidth,
          ),
          shape: BoxShape.rectangle,
        ),
      ),
    );
  }
}
