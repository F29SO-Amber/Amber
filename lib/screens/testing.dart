import 'package:amber/utilities/constants.dart';
import 'package:flutter/material.dart';

import '../widgets/profile_picture.dart';

class Testing extends StatefulWidget {
  const Testing({Key? key}) : super(key: key);

  @override
  _TestingState createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  @override
  Widget build(BuildContext context) {
    double side = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: kAppBar,
      body: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              Icon(Icons.brush_outlined),
              Icon(Icons.text_fields),
              Icon(Icons.undo),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: side,
            width: side,
            child: Stack(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        CustomImage(
                          height: side / 2,
                          width: side / 2,
                          image: const AssetImage("assets/plus.png"),
                          borderRadius: 0,
                        ),
                        CustomImage(
                          height: side / 2,
                          width: side / 2,
                          image: const AssetImage("assets/camera.png"),
                          borderRadius: 0,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        CustomImage(
                          height: side / 2,
                          width: side / 2,
                          image: const AssetImage("assets/event.png"),
                          borderRadius: 0,
                        ),
                        CustomImage(
                          height: side / 2,
                          width: side / 2,
                          image: const AssetImage("assets/community.png"),
                          borderRadius: 0,
                        ),
                      ],
                    ),
                  ],
                ),
                Center(
                  child: CustomImage(
                    height: side / 3,
                    width: side * 0.33,
                    image: const AssetImage("assets/article.png"),
                    borderRadius: 0,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
