import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:amber/mash-up/squiggles.dart';
import 'package:amber/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:path_provider/path_provider.dart';

import 'package:amber/utilities/utils.dart';
import 'package:amber/utilities/constants.dart';
import 'package:amber/services/image_service.dart';
import 'package:amber/widgets/profile_picture.dart';
import 'package:amber/widgets/widget_to_image.dart';
import 'package:amber/screens/create/publish_image.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../mash-up/squiggle.dart';
import '../mash-up/sketcher.dart';

class CollaborativeMashUpScreen extends StatefulWidget {
  final String? imageURL;
  final String? username;
  final Map? mashupDetails;

  static const id = '/mash-up_screen';

  const CollaborativeMashUpScreen({Key? key, this.imageURL, this.username, this.mashupDetails})
      : super(key: key);

  @override
  _CollaborativeMashUpScreenState createState() => _CollaborativeMashUpScreenState();
}

class _CollaborativeMashUpScreenState extends State<CollaborativeMashUpScreen> {
  List images = [const AssetImage("assets/plus.png")];
  List collageTypes = [];
  int index = 0;
  GlobalKey? _globalKey;
  late Uint8List bytes;
  List<Squiggle?> points = [];
  Color selectedColor = Colors.black;
  double strokeWidth = 2.0;
  static int x = 0;

  @override
  void initState() {
    super.initState();
    if (widget.imageURL != null) {
      setState(() => images.insert(images.length - 1, NetworkImage('${widget.imageURL}')));
    }
    for (int x in [1, 2, 4, 5, 9]) {
      collageTypes.add(
        CustomImage(side: 120, image: AssetImage("assets/$x.png"), borderRadius: 10),
      );
    }
  }

  @override
  void dispose() {
    // String json = jsonEncode(points);
    // var json = jsonEncode(points.map((e) => e == null ? {} : e.toJson()).toList());
    // debugPrint(json);
    // var decoded = jsonDecode(json);
    // debugPrint('${identical(points, decoded)}');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppColor,
        title: const Text(kAppName),
        titleTextStyle: const TextStyle(color: Colors.white, letterSpacing: 3, fontSize: 25.0),
        actions: [
          IconButton(
            icon: const Icon(Icons.done),
            color: Colors.white,
            onPressed: () async {
              final bytes = await Utils.capturePng(_globalKey!);
              setState(() => this.bytes = bytes);
              Directory dir;
              if (Platform.isIOS) {
                dir = await getApplicationDocumentsDirectory();
              } else {
                dir = (await getExternalStorageDirectory())!;
              }
              final file = await File('${dir.path}/${Random().nextInt(10000)}.jpg').create();
              file.writeAsBytesSync(this.bytes);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PublishImageScreen(mashUpDetails: [file.path, widget.username]),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder(
          stream: DatabaseService.roomsRef
              .doc(widget.mashupDetails!['roomId'])
              .collection('posts')
              .doc(widget.mashupDetails!['postId'])
              .snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              print(x++);
              // List x = (snapshot.data! as DocumentSnapshot)['squiggles'];
              // points = (jsonDecode((snapshot.data! as DocumentSnapshot)['points']))
              //     as List<DrawingArea?>;
              // final content = Squiggles.fromJson(snapshot.data as Map);
              // points = content.squiggles;
              // for (Map<String, dynamic>? y in x) {
              //   y == null ? points.add(null) : points.add(Squiggle.fromJson(y));
              // }
              points = Squiggles.fromJson(snapshot.data?.data() as Map).squiggles;
              // print(snapshot.data!.runtimeType);
              // print('data: !$x!');
              return Column(
                children: [
                  const SizedBox(height: 5),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 110,
                          child: GridView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 5.0),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: MediaQuery.of(context).size.width ~/ 55,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                              childAspectRatio: 1,
                            ),
                            itemCount: images.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 5.0),
                                child: GestureDetector(
                                  child: CustomImage(
                                    side: 50,
                                    borderRadius: 10,
                                    image: images[index],
                                  ),
                                  onTap: () async {
                                    if (index == images.length - 1) {
                                      File? file = await ImageService.chooseFromGallery();
                                      if (file != null) {
                                        setState(() =>
                                            images.insert(images.length - 1, FileImage(file)));
                                      }
                                    } else if (widget.imageURL != null && index != 0) {
                                      setState(() => images.removeAt(index));
                                    } else if (index < images.length - 2 && index > 0) {
                                      setState(() => images.removeAt(index));
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: <Widget>[
                                IconButton(
                                    icon: Icon(Icons.color_lens, color: selectedColor),
                                    onPressed: () {
                                      selectColor();
                                    }),
                                RotatedBox(
                                  quarterTurns: 1,
                                  child: Slider(
                                    min: 1.0,
                                    max: 10.0,
                                    label: "Stroke $strokeWidth",
                                    activeColor: selectedColor,
                                    value: strokeWidth,
                                    onChanged: (double value) {
                                      setState(() => strokeWidth = value);
                                    },
                                  ),
                                ),
                                IconButton(
                                    icon: const Icon(Icons.layers_clear, color: Colors.black),
                                    onPressed: () {
                                      setState(() => points.clear());
                                    }),
                              ],
                            ),
                            WidgetToImage(
                              builder: (key) {
                                _globalKey = key;
                                return Stack(
                                  children: [
                                    Container(
                                      // https://stackoverflow.com/questions/49713189
                                      child: (() {
                                        if (index == 0) {
                                          return get1Layout();
                                        } else if (index == 1) {
                                          return get2Layout();
                                        } else if (index == 2) {
                                          return get4Layout();
                                        } else if (index == 3) {
                                          return get5Layout();
                                        } else if (index == 4) {
                                          return get9Layout();
                                        }
                                      })(),
                                    ),
                                    SizedBox(
                                      width: 250,
                                      height: 250,
                                      child: GestureDetector(
                                        onPanDown: (details) {
                                          // setState(() {
                                          points.add(Squiggle(
                                            dx: details.localPosition.dx,
                                            dy: details.localPosition.dy,
                                            strokeWidth: strokeWidth,
                                            color: selectedColor.value,
                                          ));
                                          // });
                                        },
                                        onPanUpdate: (details) {
                                          // setState(() {
                                          points.add(Squiggle(
                                            dx: details.localPosition.dx,
                                            dy: details.localPosition.dy,
                                            strokeWidth: strokeWidth,
                                            color: selectedColor.value,
                                          ));
                                          // });
                                        },
                                        onPanEnd: (details) {
                                          setState(() => points.add(null));
                                          DatabaseService.roomsRef
                                              .doc(widget.mashupDetails!['roomId'])
                                              .collection('posts')
                                              .doc(widget.mashupDetails!['postId'])
                                              .set(Squiggles(points).toJson());
                                          // points = [];
                                        },
                                        child: SizedBox.expand(
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(Radius.circular(20.0)),
                                            child: CustomPaint(
                                              painter: Sketcher(points: points),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(FontAwesomeIcons.square, color: selectedColor),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  icon: Icon(FontAwesomeIcons.square, color: selectedColor),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  icon: Icon(FontAwesomeIcons.square, color: selectedColor),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  icon: Icon(FontAwesomeIcons.square, color: selectedColor),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  icon: Icon(FontAwesomeIcons.square, color: selectedColor),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 120,
                          child: Swiper(
                            outer: false,
                            itemHeight: 120,
                            itemWidth: 120,
                            viewportFraction: 0.3,
                            scale: 0.3,
                            itemCount: collageTypes.length,
                            loop: false,
                            itemBuilder: (c, i) => collageTypes[i],
                            onIndexChanged: (i) => setState(() => index = i),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  void selectColor() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Color Chooser'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: selectedColor,
              onColorChanged: (color) {
                setState(() => selectedColor = color);
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close"),
            )
          ],
        );
      },
    );
  }

  Widget get1Layout() {
    double side = 250;
    return SizedBox(
      height: side,
      width: side,
      child: CustomImage(
        height: side,
        width: side,
        image: (images.isNotEmpty) ? images[0] : const AssetImage("assets/plus.png"),
        borderRadius: 0,
      ),
    );
  }

  Widget get2Layout() {
    double side = 250;
    return SizedBox(
      height: side,
      width: side,
      child: Row(
        children: [
          CustomImage(
            height: side,
            width: side / 2,
            image: (images.isNotEmpty) ? images[0] : const AssetImage("assets/plus.png"),
            borderRadius: 0,
          ),
          CustomImage(
            height: side,
            width: side / 2,
            image: (images.length >= 2) ? images[1] : const AssetImage("assets/plus.png"),
            borderRadius: 0,
          ),
        ],
      ),
    );
  }

  Widget get4Layout() {
    double side = 250;
    return SizedBox(
      height: side,
      width: side,
      child: Column(
        children: [
          Row(
            children: [
              CustomImage(
                height: side / 2,
                width: side / 2,
                image: (images.isNotEmpty) ? images[0] : const AssetImage("assets/plus.png"),
                borderRadius: 0,
              ),
              CustomImage(
                height: side / 2,
                width: side / 2,
                image: (images.length >= 2) ? images[1] : const AssetImage("assets/plus.png"),
                borderRadius: 0,
              ),
            ],
          ),
          Row(
            children: [
              CustomImage(
                height: side / 2,
                width: side / 2,
                image: (images.length >= 3) ? images[2] : const AssetImage("assets/plus.png"),
                borderRadius: 0,
              ),
              CustomImage(
                height: side / 2,
                width: side / 2,
                image: (images.length >= 4) ? images[3] : const AssetImage("assets/plus.png"),
                borderRadius: 0,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget get5Layout() {
    double side = 250;
    return SizedBox(
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
                    image: (images.isNotEmpty) ? images[0] : const AssetImage("assets/plus.png"),
                    borderRadius: 0,
                  ),
                  CustomImage(
                    height: side / 2,
                    width: side / 2,
                    image: (images.length >= 2) ? images[1] : const AssetImage("assets/plus.png"),
                    borderRadius: 0,
                  ),
                ],
              ),
              Row(
                children: [
                  CustomImage(
                    height: side / 2,
                    width: side / 2,
                    image: (images.length >= 3) ? images[2] : const AssetImage("assets/plus.png"),
                    borderRadius: 0,
                  ),
                  CustomImage(
                    height: side / 2,
                    width: side / 2,
                    image: (images.length >= 4) ? images[3] : const AssetImage("assets/plus.png"),
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
              image: (images.length >= 5) ? images[4] : const AssetImage("assets/plus.png"),
              borderRadius: 0,
            ),
          )
        ],
      ),
    );
  }

  Widget get9Layout() {
    double side = 250;
    return SizedBox(
      height: side,
      width: side,
      child: Column(
        children: [
          Row(
            children: [
              CustomImage(
                height: side / 3,
                width: side / 3,
                image: (images.isNotEmpty) ? images[0] : const AssetImage("assets/plus.png"),
                borderRadius: 0,
              ),
              CustomImage(
                height: side / 3,
                width: side / 3,
                image: (images.length >= 2) ? images[1] : const AssetImage("assets/plus.png"),
                borderRadius: 0,
              ),
              CustomImage(
                height: side / 3,
                width: side / 3,
                image: (images.length >= 3) ? images[2] : const AssetImage("assets/plus.png"),
                borderRadius: 0,
              ),
            ],
          ),
          Row(
            children: [
              CustomImage(
                height: side / 3,
                width: side / 3,
                image: (images.length >= 4) ? images[3] : const AssetImage("assets/plus.png"),
                borderRadius: 0,
              ),
              CustomImage(
                height: side / 3,
                width: side / 3,
                image: (images.length >= 5) ? images[4] : const AssetImage("assets/plus.png"),
                borderRadius: 0,
              ),
              CustomImage(
                height: side / 3,
                width: side / 3,
                image: (images.length >= 6) ? images[5] : const AssetImage("assets/plus.png"),
                borderRadius: 0,
              ),
            ],
          ),
          Row(
            children: [
              CustomImage(
                height: side / 3,
                width: side / 3,
                image: (images.length >= 7) ? images[6] : const AssetImage("assets/plus.png"),
                borderRadius: 0,
              ),
              CustomImage(
                height: side / 3,
                width: side / 3,
                image: (images.length >= 8) ? images[7] : const AssetImage("assets/plus.png"),
                borderRadius: 0,
              ),
              CustomImage(
                height: side / 3,
                width: side / 3,
                image: (images.length >= 9) ? images[8] : const AssetImage("assets/plus.png"),
                borderRadius: 0,
              ),
            ],
          ),
        ],
      ),
    );
  }
}