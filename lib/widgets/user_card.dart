import 'package:amber/models/user.dart';
import 'package:amber/widgets/profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserCard extends StatelessWidget {
  const UserCard({
    Key? key,
    required this.user,
    required this.onPress,
  }) : super(key: key);

  final UserModel user;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onTap: onPress,
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              // color: Colors.amber.shade100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 15.0),
                        child: ProfilePicture(side: 40, image: NetworkImage(user.profilePhotoURL)),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: GoogleFonts.dmSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user.accountType,
                            style: GoogleFonts.dmSans(
                              fontSize: 10,
                              color: Colors.black38,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 15.0),
                    child: Icon(Icons.person_add),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 3,
            ),
          ],
        ),
      ),
    );
  }
}
