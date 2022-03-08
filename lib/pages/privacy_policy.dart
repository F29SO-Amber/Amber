import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:amber/utilities/constants.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: kAppBar,
      backgroundColor: Colors.amber.shade50,
      body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Privacy Policy',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Last updated: March 08, 2022 \n '
                        'This Privacy Policy describes Our policies and procedures on the collection, use and disclosure of Your information when You use the Service and tells You about Your privacy rights and how the law protects You.We use Your Personal data to provide and improve the Service. By using the Service, You agree to the collection and use of information in accordance with this Privacy Policy.',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.normal, fontSize: 15),
                  ),
                  Text(
                    'Interpretation and Definitions',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'The words of which the initial letter is capitalized have meanings defined under the following conditions. The following definitions shall have the same meaning regardless of whether they appear in singular or in plural. \n For the purposes of this Privacy Policy:',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.normal, fontSize: 15),
                  ),
                  Text(
                    'Security of Your Personal Data',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Our Service does not address anyone under the age of 13. We do not knowingly collect personally identifiable information from anyone under the age of 13. If You are a parent or guardian and You are aware that Your child has provided Us with Personal Data, please contact Us. If We become aware that We have collected Personal Data from anyone under the age of 13 without verification of parental consent, We take steps to remove that information from Our servers.',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.normal, fontSize: 15),
                  ),
                  Text(
                    'Contact Us',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'If you have any questions about this Privacy Policy, You can contact us: \n By email: admin@gmail.com',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.normal, fontSize: 15),
                  ),
                  Text(
                    'Changes to this Privacy Policy',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'We may update Our Privacy Policy from time to time. We will notify You of any changes by posting the new Privacy Policy on this page.\nWe will let You know via email and/or a prominent notice on Our Service, prior to the change becoming effective and update the "Last updated" date at the top of this Privacy Policy.\nYou are advised to review this Privacy Policy periodically for any changes. Changes to this Privacy Policy are effective when they are posted on this page. s',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.normal, fontSize: 15),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}