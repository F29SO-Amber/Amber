import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:intl/intl.dart';

class SettingItem extends StatelessWidget {
  final IconData? leadingIcon;
  final Color? leadingIconColor;
  final Color? bgIconColor;
  final String title;
  final GestureTapCallback? onTap;

  const SettingItem({
    Key? key,
    required this.title,
    this.onTap,
    this.leadingIcon,
    this.leadingIconColor = Colors.white,
    this.bgIconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          textDirection: ui.TextDirection.ltr,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: leadingIcon != null
              ? [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: bgIconColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: Icon(leadingIcon, size: 24, color: leadingIconColor),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                      child: Text(
                    title,
                    style: const TextStyle(fontSize: 16),
                    textDirection: ui.TextDirection.ltr,
                  )),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                    size: 17,
                  )
                ]
              : [
                  Expanded(
                      child: Text(
                    title,
                    style: const TextStyle(fontSize: 16),
                    textDirection: ui.TextDirection.ltr,
                  )),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                    size: 17,
                    textDirection: ui.TextDirection.ltr,
                  )
                ],
        ),
      ),
    );
  }
}
