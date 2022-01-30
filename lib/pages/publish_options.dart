import 'package:amber/models/user.dart';
import 'package:amber/screens/publish.dart';
import 'package:amber/services/auth_service.dart';
import 'package:amber/services/database_service.dart';
import 'package:amber/utilities/constants.dart';
import 'package:amber/widgets/profile_picture.dart';
import 'package:flutter/material.dart';

class PublishOptions extends StatelessWidget {
  const PublishOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppColor,
        title: const Text('Publish', style: TextStyle(fontSize: 18, color: Colors.white)),
      ),
      body: FutureBuilder(
        future: DatabaseService.getUser(AuthService.currentUser.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var user = snapshot.data as UserModel;
            List<String> list = [];
            switch (user.accountType) {
              case 'Artist':
                list = ['Image', 'Article'];
                break;
              case 'Brand Marketer':
                list = ['Image', 'Article', 'Event'];
                break;
              case 'Content Creator':
                list = ['Image', 'Article'];
                break;
              case 'Student':
                list = ['Image', 'Article'];
                break;
              default:
                list = ['Image'];
                break;
            }
            return GridView.builder(
              padding: const EdgeInsets.all(10).copyWith(top: 30),
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
                            Navigator.pushNamed(context, PublishScreen.id);
                        }
                      },
                      child: ProfilePicture(
                        side: MediaQuery.of(context).size.width * 0.3,
                        path: 'assets/camera.png',
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
