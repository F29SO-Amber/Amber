import 'package:amber/screens/profile_screen/widgets/profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserCard extends StatelessWidget {
  const UserCard(
      {Key? key,
      required this.name,
      required this.accountType,
      required this.onPress})
      : super(key: key);

  final String name;
  final String accountType;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: onPress,
        child: Container(
          height: 75,
          width: double.infinity,
          color: Colors.amber.shade100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0, right: 15.0),
                    child: ProfilePicture(side: 60, path: 'assets/img.png'),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.dmSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        accountType,
                        style: GoogleFonts.dmSans(
                          fontSize: 13,
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
      ),
    );
  }
}
