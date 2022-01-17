import 'package:amber/constants.dart';
import 'package:amber/widgets/profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserPost extends StatelessWidget {
  const UserPost({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: ProfilePicture(side: 32, path: 'assets/img.png'),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Abdullah Meda', style: GoogleFonts.dmSans(fontSize: 15)),
                      Text('Cairo, Egypt', style: kLightLabelTextStyle.copyWith(fontSize: 10)),
                    ],
                  ),
                ],
              ),
              Row(
                children: const [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(FontAwesomeIcons.arrowAltCircleUp),
                  ),
                  Text('2.5K'),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(FontAwesomeIcons.arrowAltCircleDown),
                  ),
                ],
              )
            ],
          ),
          Container(
            height: (MediaQuery.of(context).size.width / 16) * 9,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/upload.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Text('abd.m.3303  •  ',
                    style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.bold)),
                Text('Lorem Ipsum', style: GoogleFonts.dmSans()),
              ],
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
