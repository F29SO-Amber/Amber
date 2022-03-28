import 'package:amber/models/thumbnail.dart';
import 'package:amber/pages/mash_up_collaborative.dart';
import 'package:amber/screens/profile/deep_info/user_articles.dart';
import 'package:amber/screens/profile/profile.dart';
import 'package:amber/widgets/custom_elevated_button.dart';
import 'package:amber/widgets/custom_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:amber/models/post.dart';
import 'package:amber/pages/comments.dart';
import 'package:amber/utilities/constants.dart';
import 'package:amber/pages/mash_up.dart';
import 'package:amber/services/auth_service.dart';
import 'package:amber/widgets/profile_picture.dart';
import 'package:amber/services/database_service.dart';

import 'package:amber/models/user.dart';
import 'package:amber/user_data.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedEntity extends StatefulWidget {
  final dynamic feedEntity;

  const FeedEntity({Key? key, required this.feedEntity}) : super(key: key);

  @override
  State<FeedEntity> createState() => _FeedEntityState();
}

class _FeedEntityState extends State<FeedEntity> {
  late bool? isLiked = false;
  Future<void>? _launched;
  int finalScore = 0;

  @override
  void initState() {
    super.initState();
    if (widget.feedEntity is PostModel) {
      isLiked = widget.feedEntity.likes.containsKey(AuthService.currentUser.uid)
          ? widget.feedEntity.likes[AuthService.currentUser.uid]
          : null;
      finalScore = widget.feedEntity.likes.values.toList().where((item) => item == true).length -
          widget.feedEntity.likes.values.toList().where((item) => item == false).length;
    }
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
                    child: CustomImage(
                      side: 32,
                      image: NetworkImage(widget.feedEntity.authorProfilePhotoURL),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        child: Text(
                          widget.feedEntity.authorName,
                          style: GoogleFonts.dmSans(fontSize: 15),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProfilePage(userUID: widget.feedEntity.authorId),
                            ),
                          );
                        },
                      ),
                      Text(
                          widget.feedEntity.location.isEmpty
                              ? timeago.format(widget.feedEntity.timestamp.toDate())
                              : widget.feedEntity.location,
                          style: kLightLabelTextStyle.copyWith(fontSize: 10)),
                    ],
                  ),
                ],
              ),
              (widget.feedEntity is PostModel)
                  ? Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (isLiked != true) {
                              DatabaseService.postsRef
                                  .doc(widget.feedEntity.id)
                                  .update({'likes.${AuthService.currentUser.uid}': true});
                              // finalScore += 1;
                              setState(() => isLiked = true);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: (isLiked != null && isLiked!)
                                ? const Icon(FontAwesomeIcons.arrowAltCircleUp, color: kAppColor)
                                : const Icon(FontAwesomeIcons.arrowAltCircleUp),
                          ),
                        ),
                        Text(
                            '${isLiked != null ? (isLiked! ? finalScore + 1 : finalScore - 1) : finalScore}'),
                        GestureDetector(
                          onTap: () {
                            if (isLiked != false) {
                              DatabaseService.postsRef
                                  .doc(widget.feedEntity.id)
                                  .update({'likes.${AuthService.currentUser.uid}': false});
                              // finalScore -= 1;
                              setState(() => isLiked = false);
                            }
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
                  : Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: (widget.feedEntity is ThumbnailModel)
                          ? CustomElevatedButton(
                              widthFactor: 0.2,
                              buttonHeight: 10,
                              buttonText: 'Watch',
                              onPress: () {
                                _launchInBrowser((widget.feedEntity as ThumbnailModel).link);
                              },
                            )
                          : CustomElevatedButton(
                              widthFactor: 0.2,
                              buttonHeight: 10,
                              buttonText: 'Read',
                              onPress: () {
                                Navigator.of(context, rootNavigator: true).push(
                                  MaterialPageRoute(
                                    builder: (_) => UserArticles(
                                      article: widget.feedEntity,
                                    ),
                                  ),
                                );
                              },
                            ),
                    )
            ],
          ),
          Slidable(
            startActionPane: ActionPane(
              motion: const DrawerMotion(),
              children: [
                SlidableAction(
                  backgroundColor: const Color(0xFFFE4A49),
                  foregroundColor: Colors.white,
                  icon: FontAwesomeIcons.retweet,
                  label: 'Mash-up',
                  onPressed: (context) {
                    showMaterialModalBottomSheet(
                      expand: false,
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context) => Material(
                        child: SafeArea(
                          top: false,
                          child: SizedBox(
                            height: 500,
                            width: MediaQuery.of(context).size.width,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 25.0),
                                    child: Text('Mash up with:', style: kDarkLabelTextStyle),
                                  ),
                                  StreamBuilder<List<types.Room>>(
                                    stream: FirebaseChatCore.instance.rooms(),
                                    // stream: DatabaseService.roomsRef.,
                                    initialData: const [],
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        List<dynamic> list = [
                                          UserData.currentUser!,
                                          ...snapshot.data!
                                        ];
                                        return GridView.builder(
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemCount: snapshot.data!.length + 1,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 0,
                                            mainAxisSpacing: 0,
                                            childAspectRatio: 1,
                                          ),
                                          itemBuilder: (context, index) {
                                            debugPrint('${snapshot.data!.length}');
                                            if (index == 0) {
                                              UserModel user = list[index];
                                              return GestureDetector(
                                                child: Column(
                                                  children: [
                                                    CustomImage(
                                                        side: 100,
                                                        image: NetworkImage(user.imageUrl)),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(
                                                          vertical: 10.0),
                                                      child: Text('My Profile',
                                                          style: kLightLabelTextStyle),
                                                    ),
                                                  ],
                                                ),
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (_) => MashUpScreen(
                                                        imageURL: widget.feedEntity.imageURL,
                                                        username: widget.feedEntity.authorUserName,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            } else {
                                              final room = list[index] as types.Room;
                                              return GestureDetector(
                                                child: Column(
                                                  children: [
                                                    CustomImage(
                                                      side: MediaQuery.of(context).size.width *
                                                          0.8 /
                                                          3,
                                                      image: NetworkImage('${room.imageUrl}'),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 10.0),
                                                      child: Text('${room.name}',
                                                          style: kLightLabelTextStyle),
                                                    ),
                                                  ],
                                                ),
                                                onTap: () async {
                                                  if (!(await DatabaseService.roomsRef
                                                          .doc(room.id)
                                                          .collection('posts')
                                                          .doc(widget.feedEntity.id)
                                                          .get())
                                                      .exists) {
                                                    DatabaseService.roomsRef
                                                        .doc(room.id)
                                                        .collection('posts')
                                                        .doc(widget.feedEntity.id)
                                                        .set({'squiggles': []});
                                                  }
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (_) => CollaborativeMashUpScreen(
                                                        imageURL: widget.feedEntity.imageURL,
                                                        username: widget.feedEntity.authorUserName,
                                                        mashupDetails: {
                                                          'room': room,
                                                          'post': widget.feedEntity
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            }
                                          },
                                        );
                                      } else {
                                        return const Center(child: CircularProgressIndicator());
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SlidableAction(
                  onPressed: (context) => EasyLoading.showSuccess('Post successfully reported!'),
                  backgroundColor: const Color(0xFF21B7CA),
                  foregroundColor: Colors.white,
                  icon: Icons.report,
                  label: 'Report',
                ),
              ],
            ),
            endActionPane: (widget.feedEntity.authorId != UserData.currentUser!.id)
                ? ActionPane(
                    extentRatio: 0.25,
                    motion: const DrawerMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (context) => CommentsPage(
                                postID: widget.feedEntity.id,
                                username: widget.feedEntity.authorUserName,
                                profilePhotoURL: widget.feedEntity.authorProfilePhotoURL,
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
                  )
                : ActionPane(
                    motion: const DrawerMotion(),
                    children: [
                      SlidableAction(
                        backgroundColor: Colors.deepOrange,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                        onPressed: (context) {
                          DatabaseService.postsRef.doc(widget.feedEntity.id).delete();
                          setState(() {});
                        },
                      ),
                      SlidableAction(
                        onPressed: (context) {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (context) => CommentsPage(
                                postID: widget.feedEntity.id,
                                username: widget.feedEntity.authorUserName,
                                profilePhotoURL: widget.feedEntity.authorProfilePhotoURL,
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
                if (widget.feedEntity is PostModel) {
                  if (isLiked != true) {
                    DatabaseService.postsRef
                        .doc(widget.feedEntity.id)
                        .update({'likes.${AuthService.currentUser.uid}': true});
                    setState(() => isLiked = true);
                  }
                }
              },
              child: Container(
                height: (widget.feedEntity is PostModel)
                    ? MediaQuery.of(context).size.width
                    : MediaQuery.of(context).size.width * 9 / 13,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.feedEntity.imageURL),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Text('${widget.feedEntity.authorUserName}  •  ',
                    style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.bold)),
                Text(widget.feedEntity.caption, style: GoogleFonts.dmSans()),
              ],
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }

  Future<void> _launchInBrowser(String url) async {
    if (!await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    )) {
      throw 'Could not launch $url';
    }
  }
}
