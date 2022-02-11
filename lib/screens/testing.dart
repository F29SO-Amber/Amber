import 'package:amber/mash-up/collage.dart';
import 'package:amber/mash-up/crop.dart';
import 'package:amber/mash-up/draw.dart';
import 'package:amber/utilities/constants.dart';
import 'package:amber/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';

class Testing extends StatefulWidget {
  const Testing({Key? key}) : super(key: key);

  @override
  _TestingState createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomElevatedButton(
              widthFactor: 0.7,
              onPress: () {
                Navigator.pushNamed(context, Collage.id);
              },
              buttonText: 'Collage',
            ),
            CustomElevatedButton(
              widthFactor: 0.7,
              onPress: () {
                Navigator.pushNamed(context, Crop.id);
              },
              buttonText: 'Crop',
            ),
            CustomElevatedButton(
              widthFactor: 0.7,
              onPress: () {
                Navigator.pushNamed(context, Draw.id);
              },
              buttonText: 'Draw',
            ),
          ],
        ),
      ),
    );
  }
}
