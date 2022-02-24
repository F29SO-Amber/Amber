import 'dart:convert';

import 'package:amber/models/article.dart';
import 'package:amber/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;

class ArticleScreen extends StatefulWidget {
  static const id = '/publish_article';
  final ArticleModel article;
  const ArticleScreen({Key? key, required this.article}) : super(key: key);

  @override
  _ArticleScreenState createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  late final QuillController _controller;

  @override
  void initState() {
    var myJSON = jsonDecode(widget.article.text);
    _controller = QuillController(
        document: Document.fromJson(myJSON), selection: const TextSelection.collapsed(offset: 0));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppColor,
        title: Text(
          widget.article.authorUserName,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
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
    );
  }
}
