import 'package:flutter/material.dart';

class PostType extends StatelessWidget {
  const PostType({
    Key? key,
    required this.numOfDivisions,
    required this.icon,
    required this.bgColor,
  }) : super(key: key);

  final int numOfDivisions;
  final Icon icon;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: MediaQuery.of(context).size.width / numOfDivisions,
      child: icon,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.all(Radius.circular(-100)),
      ),
    );
  }
}
