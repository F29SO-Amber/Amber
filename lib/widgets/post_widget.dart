import 'package:amber/models/post.dart';
import 'package:amber/pages/comments.dart';
import 'package:amber/pages/mash_up.dart';
import 'package:amber/services/auth_service.dart';
import 'package:amber/services/database_service.dart';
import 'package:amber/utilities/constants.dart';
import 'package:amber/widgets/profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class UserPost extends StatefulWidget {
  final PostModel post;

  const UserPost({Key? key, required this.post}) : super(key: key);

  @override
  State<UserPost> createState() => _UserPostState();
}

class _UserPostState extends State<UserPost> {
  late bool? isLiked;

  @override
  void initState() {
    super.initState();
    isLiked = widget.post.likes.containsKey(AuthService.currentUser.uid)
        ? widget.post.likes[AuthService.currentUser.uid]
        : null;
  }

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
                    child: ProfilePicture(
                        side: 32, image: NetworkImage(widget.post.authorProfilePhotoURL)),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.post.authorName, style: GoogleFonts.dmSans(fontSize: 15)),
                      Text(widget.post.location,
                          style: kLightLabelTextStyle.copyWith(fontSize: 10)),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      DatabaseService.postsRef
                          .doc(widget.post.id)
                          .update({'likes.${AuthService.currentUser.uid}': true});
                      setState(() {
                        isLiked = true;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: (isLiked != null && isLiked!)
                          ? const Icon(FontAwesomeIcons.arrowAltCircleUp, color: kAppColor)
                          : const Icon(FontAwesomeIcons.arrowAltCircleUp),
                    ),
                  ),
                  Text(
                    // TODO
                    '${widget.post.likes.values.where((element) => true).length - widget.post.likes.values.where((element) => false).length}',
                  ),
                  // const Text('0'),
                  GestureDetector(
                    onTap: () {
                      DatabaseService.postsRef
                          .doc(widget.post.id)
                          .update({'likes.${AuthService.currentUser.uid}': false});
                      setState(() {
                        isLiked = false;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: (isLiked != null && !(isLiked!))
                          ? const Icon(FontAwesomeIcons.arrowAltCircleDown, color: kAppColor)
                          : const Icon(FontAwesomeIcons.arrowAltCircleDown),
                    ),
                  ),
                ],
              )
            ],
          ),
          Slidable(
            // key: const ValueKey(0),
            startActionPane: ActionPane(
              motion: const DrawerMotion(),
              // dismissible: DismissiblePane(onDismissed: () {}),
              children: [
                SlidableAction(
                  onPressed: (context) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MashUpPost(imageURL: widget.post.imageURL),
                      ),
                    );
                  },
                  backgroundColor: const Color(0xFFFE4A49),
                  foregroundColor: Colors.white,
                  icon: FontAwesomeIcons.retweet,
                  label: 'Mash-up',
                ),
                const SlidableAction(
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
              // dismissible: DismissiblePane(onDismissed: () {}),
              children: [
                const SlidableAction(
                  onPressed: null,
                  backgroundColor: Color(0xFF7BC043),
                  foregroundColor: Colors.white,
                  icon: Icons.report,
                  label: 'Report',
                ),
                SlidableAction(
                  onPressed: (context) {
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                        builder: (context) => CommentsPage(
                          postID: widget.post.id,
                          username: widget.post.authorUserName,
                          profilePhotoURL: widget.post.authorProfilePhotoURL,
                        ),
                      ),
                    );
                  },
                  backgroundColor: const Color(0xFF0392CF),
                  foregroundColor: Colors.white,
                  icon: Icons.comment,
                  label: 'Comment',
                ),
              ],
            ),
            child: GestureDetector(
              onDoubleTap: () {
                DatabaseService.postsRef
                    .doc(widget.post.id)
                    .update({'likes.${AuthService.currentUser.uid}': true});
                setState(() {
                  isLiked = true;
                });
              },
              child: Container(
                height: (MediaQuery.of(context).size.width / 16) * 9,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image:
                      DecorationImage(image: NetworkImage(widget.post.imageURL), fit: BoxFit.cover),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Text('${widget.post.authorUserName}  •  ',
                    style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.bold)),
                Text(widget.post.caption, style: GoogleFonts.dmSans()),
              ],
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
