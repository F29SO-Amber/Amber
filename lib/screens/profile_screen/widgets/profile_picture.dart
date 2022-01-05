import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture(
      {Key? key, required this.side, required this.pathToImage})
      : super(key: key);

  final double side;
  final String pathToImage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        height: side,
        width: side,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(pathToImage),
            fit: BoxFit.fill,
          ),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(33.0),
        ),
      ),
    );
  }
}
