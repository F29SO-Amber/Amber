import 'dart:convert';

import 'package:amber/models/article.dart';
import 'package:amber/utilities/constants.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:google_fonts/google_fonts.dart';

import '../screens/profile/profile.dart';
import '../services/database_service.dart';
import '../user_data.dart';
import '../widgets/profile_picture.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'comments.dart';

class ArticleScreen extends StatefulWidget {
  static const id = '/read_article';
  final List articles;
  const ArticleScreen({Key? key, required this.articles}) : super(key: key);

  @override
  _ArticleScreenState createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  String heading = 'An article';
  late bool? isLiked;
  int finalScore = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppColor,
        title: Text(heading, style: const TextStyle(fontSize: 18, color: Colors.white)),
      ),
      body: CarouselSlider(
        options: CarouselOptions(
          height: MediaQuery.of(context).size.height,
          viewportFraction: 1.0,
          enlargeCenterPage: false,
        ),
        items: widget.articles
            .map((item) => Builder(builder: (context) {
                  ArticleModel article = ArticleModel.fromDocument(item);
                  isLiked = article.likes.containsKey(UserData.currentUser!.id)
                      ? article.likes[UserData.currentUser!.id]
                      : null;
                  finalScore = article.likes.values.toList().where((item) => item == true).length -
                      article.likes.values.toList().where((item) => item == false).length;
                  QuillController _controller = QuillController(
                      document: Document.fromJson(jsonDecode(article.text)),
                      selection: const TextSelection.collapsed(offset: 0));
                  return Stack(
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
                                    image: NetworkImage(ArticleModel.fromDocument(item).imageURL),
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
                                    image: NetworkImage(article.authorProfilePhotoURL),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        child: Text(
                                          article.authorName,
                                          style:
                                              GoogleFonts.dmSans(fontSize: 17, color: Colors.white),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ProfilePage(userUID: article.authorId),
                                            ),
                                          );
                                        },
                                      ),
                                      Text(article.authorUserName,
                                          style: kLightLabelTextStyle.copyWith(
                                              fontSize: 10, color: Colors.white)),
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
                                          postID: article.id,
                                          username: article.authorUserName,
                                          profilePhotoURL: article.authorProfilePhotoURL,
                                        ),
                                      ),
                                    );
                                  }),
                              Row(
                                // TODO: Avoid entire rebuild to manage likes and dislikes
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (isLiked != true) {
                                        DatabaseService.articlesRef
                                            .doc(article.id)
                                            .update({'likes.${UserData.currentUser!.id}': true});
                                        // finalScore += 1;
                                        setState(() => isLiked = true);
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: (isLiked != null && isLiked!)
                                          ? const Icon(FontAwesomeIcons.arrowAltCircleUp,
                                              color: kAppColor)
                                          : const Icon(FontAwesomeIcons.arrowAltCircleUp,
                                              color: Colors.white),
                                    ),
                                  ),
                                  Text(
                                    '${isLiked != null ? (isLiked! ? finalScore + 1 : finalScore - 1) : finalScore}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (isLiked != false) {
                                        DatabaseService.articlesRef
                                            .doc(article.id)
                                            .update({'likes.${UserData.currentUser!.id}': false});
                                        // finalScore -= 1;
                                        setState(() => isLiked = false);
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: (isLiked != null && !(isLiked!))
                                          ? const Icon(FontAwesomeIcons.arrowAltCircleDown,
                                              color: kAppColor)
                                          : const Icon(FontAwesomeIcons.arrowAltCircleDown,
                                              color: Colors.white),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                }))
            .toList(),
      ),
    );
  }
}
