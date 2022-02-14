
import 'package:amber/screens/collagegen.dart';
import 'package:amber/screens/transitions/fade_route_transition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_collage_widget/image_collage_widget.dart';
import 'package:image_collage_widget/utils/CollageType.dart';
import 'package:flutter/src/widgets/framework.dart';

class CollagePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CollagePageState();
}

class _CollagePageState extends State<CollagePage> {
  @override
  Widget build(BuildContext context) {
    Widget buildRaisedButton(CollageType collageType, String text) {
      return RaisedButton(
        onPressed: () => pushImageWidget(collageType),
        shape: buttonShape(),
        color: Colors.amber,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(text),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Test"),
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(16.0),
          shrinkWrap: true,
          children: <Widget>[
            buildRaisedButton(CollageType.VSplit, 'Vsplit'),
            buildRaisedButton(CollageType.HSplit, 'HSplit'),
            buildRaisedButton(CollageType.FourSquare, 'FourSquare'),
            buildRaisedButton(CollageType.NineSquare, 'NineSquare'),
            buildRaisedButton(CollageType.ThreeVertical, 'ThreeVertical'),
            buildRaisedButton(CollageType.ThreeHorizontal, 'ThreeHorizontal'),
            buildRaisedButton(CollageType.LeftBig, 'LeftBig'),
            buildRaisedButton(CollageType.RightBig, 'RightBig'),
            buildRaisedButton(CollageType.FourLeftBig, 'FourLeftBig'),
            buildRaisedButton(CollageType.VMiddleTwo, 'VMiddleTwo'),
            buildRaisedButton(CollageType.CenterBig, 'CenterBig'),
          ],
        ),
      ),
    );
  }

  pushImageWidget(CollageType type) async {
    await Navigator.of(context).push(
      FadeRouteTransition(page: CollageSample(type)),
    );
  }

  RoundedRectangleBorder buttonShape() {
    return RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0));
  }
}
