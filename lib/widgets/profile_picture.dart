import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  final double? side;
  final double? height;
  final double? width;
  final ImageProvider? image;
  final String? path;
  final double? borderRadius;

  const CustomImage({
    Key? key,
    this.side,
    this.image,
    this.path,
    this.borderRadius,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? side,
      width: width ?? side,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: image == null ? AssetImage(path!) : image!,
          fit: BoxFit.cover,
        ),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(borderRadius ?? 33.0),
      ),
    );
  }
}
