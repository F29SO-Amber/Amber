import 'package:amber/widgets/profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExploreEntity extends StatefulWidget {
  final String imagePath;
  final VoidCallback onTap;
  final String title;

  const ExploreEntity({Key? key, required this.imagePath, required this.onTap, required this.title})
      : super(key: key);

  @override
  State<ExploreEntity> createState() => _ExploreEntityState();
}

class _ExploreEntityState extends State<ExploreEntity> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomLeft,
          children: [
            GestureDetector(
              child: CustomImage(
                height: MediaQuery.of(context).size.width * 0.3,
                width: MediaQuery.of(context).size.width * 0.9,
                path: widget.imagePath,
                borderRadius: 15,
              ),
              onTap: widget.onTap,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(widget.title, style: GoogleFonts.dmSans(fontSize: 20)),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
