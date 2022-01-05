import 'package:amber/models/user.dart';
import 'package:flutter/material.dart';
import 'package:amber/constants.dart';
import 'package:amber/screens/profile_screen/widgets/number_and_label.dart';
import 'package:amber/screens/profile_screen/widgets/profile_picture.dart';
import 'package:amber/services/authentication.dart';
import 'package:amber/screens/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  static const id = '/profile';
  final String profileID;

  const ProfilePage({Key? key, required this.profileID}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // am2024@hw.ac.uk
  // 1234567

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Authentication.getUser(widget.profileID).asStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var userData = snapshot.data as AmberUser;
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  '@${userData.username}',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
                actions: [
                  GestureDetector(
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Icon(
                        Icons.logout_outlined,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      Authentication.signOutUser();
                      Navigator.of(context, rootNavigator: true)
                          .pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                  ),
                ],
                backgroundColor: kAppColor,
              ),
              body: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    const ProfilePicture(
                      side: 100,
                      pathToImage: 'assets/img.png',
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${userData.name} ',
                            style: GoogleFonts.dmSans(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                          const Icon(
                            Icons.verified,
                            color: Colors.amber,
                            size: 22,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 3.0, bottom: 15),
                      child: Text(
                        userData.accountType,
                        style: GoogleFonts.dmSans(
                          fontSize: 13,
                          color: Colors.black38,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        NumberAndLabel(number: '140', label: '   Posts   '),
                        NumberAndLabel(number: '524', label: 'Followers'),
                        NumberAndLabel(number: '343', label: 'Following'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        OutlinedButton(
                          child: const Text('Message'),
                          style: OutlinedButton.styleFrom(
                            fixedSize: Size(
                                MediaQuery.of(context).size.width * 0.45, 43),
                            primary: Colors.black,
                            side: BorderSide(
                                width: 1.0, color: Colors.amber.shade300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {},
                        ),
                        ElevatedButton(
                          child: const Text('Follow'),
                          style: ElevatedButton.styleFrom(
                              fixedSize: Size(
                                  MediaQuery.of(context).size.width * 0.45, 43),
                              primary: Colors.amber.shade300, // background
                              onPrimary: Colors.black, // foreground
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                      width: 200,
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          height: 35,
                          width: MediaQuery.of(context).size.width / 4,
                          child: const Icon(Icons.image),
                          decoration: BoxDecoration(
                            color: Colors.red[100],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(-100)),
                          ),
                        ),
                        Container(
                          height: 35,
                          width: MediaQuery.of(context).size.width / 4,
                          child: const Icon(Icons.play_arrow_sharp),
                          decoration: BoxDecoration(
                            color: Colors.greenAccent[100],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(-100)),
                          ),
                        ),
                        Container(
                          height: 35,
                          width: MediaQuery.of(context).size.width / 4,
                          child: const Icon(Icons.article_outlined),
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(-100)),
                          ),
                        ),
                        Container(
                          height: 35,
                          width: MediaQuery.of(context).size.width / 4,
                          child: const Icon(Icons.group),
                          decoration: BoxDecoration(
                            color: Colors.brown[100],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(-100)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
