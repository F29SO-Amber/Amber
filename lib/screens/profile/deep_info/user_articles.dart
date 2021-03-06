import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:amber/user_data.dart';
import 'package:amber/models/article.dart';
import 'package:amber/pages/comments.dart';
import 'package:amber/utilities/constants.dart';
import 'package:amber/widgets/profile_picture.dart';
import 'package:amber/screens/profile/profile.dart';
import 'package:amber/services/database_service.dart';

class UserArticles extends StatefulWidget {
  static const id = '/read_article';
  final ArticleModel article;

  const UserArticles({Key? key, required this.article}) : super(key: key);

  @override
  _UserArticlesState createState() => _UserArticlesState();
}

class _UserArticlesState extends State<UserArticles> {
  @override
  Widget build(BuildContext context) {
    QuillController _controller = QuillController(
        document: Document.fromJson(jsonDecode(widget.article.text)),
        selection: const TextSelection.collapsed(offset: 0));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppColor,
        title: Text(widget.article.caption),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.width * 9 / 16,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.article.imageURL),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  QuillEditor(
                    controller: _controller,
                    readOnly: true,
                    autoFocus: false,
                    expands: false,
                    padding: EdgeInsets.zero,
                    scrollController: ScrollController(),
                    focusNode: FocusNode(),
                    scrollable: false,
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 65,
            width: double.infinity,
            color: Colors.brown,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CustomImage(
                        side: 40,
                        image: NetworkImage(widget.article.authorProfilePhotoURL),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            child: Text(
                              widget.article.authorName,
                              style: GoogleFonts.dmSans(fontSize: 17, color: Colors.white),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProfilePage(userUID: widget.article.authorId),
                                ),
                              );
                            },
                          ),
                          Text(widget.article.authorUserName,
                              style:
                                  kLightLabelTextStyle.copyWith(fontSize: 10, color: Colors.white)),
                        ],
                      ),
                    ],
                    // crossAxisAlignment: CrossAxisAlignment.center,
                  ),
                  GestureDetector(
                      child: const Icon(FontAwesomeIcons.comment, color: Colors.white),
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (context) => CommentsPage(
                              postID: widget.article.id,
                              username: widget.article.authorUserName,
                              profilePhotoURL: widget.article.authorProfilePhotoURL,
                            ),
                          ),
                        );
                      }),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
