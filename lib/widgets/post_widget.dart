import 'package:amber/models/post.dart';
import 'package:amber/utilities/constants.dart';
import 'package:amber/widgets/profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserPost extends StatelessWidget {
  final PostModel post;

  const UserPost({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        ProfilePicture(side: 32, image: NetworkImage(post.authorProfilePhotoURL)),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.authorName, style: GoogleFonts.dmSans(fontSize: 15)),
                      Text(post.location, style: kLightLabelTextStyle.copyWith(fontSize: 10)),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(FontAwesomeIcons.arrowAltCircleUp),
                  ),
                  Text('${post.score}'),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(FontAwesomeIcons.arrowAltCircleDown),
                  ),
                ],
              )
            ],
          ),
          Slidable(
            key: const ValueKey(0),
            startActionPane: ActionPane(
              motion: const DrawerMotion(),
              dismissible: DismissiblePane(onDismissed: () {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text("Image Posted!")));
              }),
              children: const [
                SlidableAction(
                  onPressed: null,
                  backgroundColor: Color(0xFFFE4A49),
                  foregroundColor: Colors.white,
                  icon: FontAwesomeIcons.retweet,
                  label: 'Mash-up',
                ),
                SlidableAction(
                  onPressed: null,
                  backgroundColor: Color(0xFF21B7CA),
                  foregroundColor: Colors.white,
                  icon: Icons.share,
                  label: 'Share',
                ),
              ],
            ),
            endActionPane: ActionPane(
              motion: const DrawerMotion(),
              dismissible: DismissiblePane(onDismissed: () {}),
              children: const [
                SlidableAction(
                  // An action can be bigger than the others.
                  flex: 1,
                  onPressed: null,
                  backgroundColor: Color(0xFF7BC043),
                  foregroundColor: Colors.white,
                  icon: Icons.report,
                  label: 'Report',
                ),
                SlidableAction(
                  onPressed: null,
                  backgroundColor: Color(0xFF0392CF),
                  foregroundColor: Colors.white,
                  icon: Icons.comment,
                  label: 'Comment',
                ),
              ],
            ),
            child: Container(
              height: (MediaQuery.of(context).size.width / 16) * 9,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(image: NetworkImage(post.imageURL), fit: BoxFit.cover),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Text('${post.authorUserName}  •  ',
                    style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.bold)),
                Text(post.caption, style: GoogleFonts.dmSans()),
              ],
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
