import 'package:flutter/material.dart';

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
      appBar: kAppBar,
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
