import 'package:amber/screens/create/publish_thumbnail.dart';
import 'package:flutter/material.dart';
import 'package:styled_text/styled_text.dart';
import 'package:amber/models/user.dart';
import 'package:amber/utilities/constants.dart';
import 'package:amber/services/auth_service.dart';
import 'package:amber/widgets/profile_picture.dart';
import 'package:amber/services/database_service.dart';
import 'package:amber/screens/create/publish_event.dart';
import 'package:amber/screens/create/publish_image.dart';
import 'package:amber/screens/create/publish_article.dart';
import 'package:amber/screens/create/publish_community.dart';

class Create extends StatelessWidget {
  static const id = '/create';

  const Create({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: kAppColor,
        title: const Text(kAppName),
        titleTextStyle: const TextStyle(color: Colors.white, letterSpacing: 3, fontSize: 25.0),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.info_outline,
              size: 30,
            ),
            onPressed: () {
              showDialogFunc(context, "Hey there!");
            },
          )
        ],),
      body: FutureBuilder(
        future: DatabaseService.getUser(AuthService.currentUser.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<String> list = (snapshot.data as UserModel).getCurrentUserPostTypes();
            return GridView.builder(
              padding: const EdgeInsets.all(10).copyWith(top: 40),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: list.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        switch (list[index]) {
                          case 'Event':
                            Navigator.pushNamed(context, PublishEventScreen.id);
                            break;
                          case 'Image':
                            Navigator.pushNamed(context, PublishImageScreen.id);
                            break;
                          case 'Community':
                            Navigator.pushNamed(context, PublishCommunityScreen.id);
                            break;
                          case 'Thumbnail':
                            Navigator.pushNamed(context, PublishThumbnailScreen.id);
                            break;
                          case 'Article':
                            Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(builder: (context) => const PublishArticleScreen()),
                            );
                            break;
                        }
                      },
                      child: CustomImage(
                        side: MediaQuery.of(context).size.width * 0.3,
                        path: 'assets/create/${list[index].toLowerCase()}.png',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(list[index], style: kLightLabelTextStyle),
                    ),
                  ],
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

showDialogFunc(context, title) {
  return showDialog(
    context: context,
    builder: (context) {
      return Center(
        child: Material(
          type: MaterialType.transparency,
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              padding: EdgeInsets.all(15),
              height: 700,
              width: 440,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 50,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    StyledText(
                      text: """

<bold><head>Create your first post.</head></bold>
<upsize>Based on the account type you have selected, you have access to creating different kinds of posts. All Amber accounts can create image posts so let's start with that shall we? Click on the "Image" option to create your first post.</upsize>

<bold><head>Keep On Discovering</head></bold>
<upsize>There's a lot more for you to discover, one place you can start with is the "Profile Page", this is where you can see your account in all it's glory. Click on the numbers above "Followers" and "Following" to see what accounts interact with you and vice-versa.</upsize>



""",
                      tags: {
                        'bold': StyledTextTag(style: TextStyle(fontWeight: FontWeight.bold)),
                        'head': StyledTextTag(style: TextStyle(fontSize: 20)),
                        'upsize': StyledTextTag(style: TextStyle(fontSize: 17))
                      },
                    )
                  ],
                ),
              )),
        ),
      );
    },
  );
}