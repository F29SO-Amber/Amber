import 'dart:io';

import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({Key? key, required this.side, this.image, this.path}) : super(key: key);

  final double side;
  final ImageProvider? image;
  final String? path;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: side,
      width: side,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: image == null ? AssetImage(path!) : image!,
          fit: BoxFit.cover,
        ),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(33.0),
      ),
    );
  }
}
