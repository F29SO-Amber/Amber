import 'package:flutter/material.dart';

class PostType extends StatelessWidget {
  const PostType({
    Key? key,
    required this.numOfDivisions,
    required this.icon,
    required this.bgColor,
    required this.currentTab,
    required this.index,
    required this.onPress,
  }) : super(key: key);

  final int numOfDivisions;
  final int currentTab;
  final int index;
  final Icon icon;
  final Color bgColor;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Material(
        elevation: (currentTab == index) ? 10 : 0,
        child: Container(
          height: (currentTab == index) ? 45 : 40,
          width: MediaQuery.of(context).size.width / numOfDivisions,
          child: icon,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: const BorderRadius.all(Radius.circular(-100)),
          ),
        ),
      ),
    );
  }
}
