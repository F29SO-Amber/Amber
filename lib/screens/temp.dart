// import 'package:amber/services/database_service.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_login/flutter_login.dart';
// import 'package:email_validator/email_validator.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//
// import 'package:amber/constants.dart';
// import 'package:amber/screens/navbar.dart';
// import 'package:amber/services/authentication.dart';
//
// class LoginPageTest extends StatefulWidget {
//   const LoginPageTest({Key? key}) : super(key: key);
//   static String id = 'a';
//
//   @override
//   _LoginPageTestState createState() => _LoginPageTestState();
// }
//
// class _LoginPageTestState extends State<LoginPageTest> {
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: DatabaseService().x(),
//       builder: (context, snapshot) {
//         DatabaseService b = snapshot.data as DatabaseService;
//         return FlutterLogin(
//           title: kAppName,
//           logo: const AssetImage('assets/logo.png'),
//           loginAfterSignUp: false,
//           theme: kLoginTheme,
//           onLogin: Authentication.authUser,
//           onSignup: Authentication.signupUser,
//           onRecoverPassword: Authentication.recoverPassword,
//           messages: LoginMessages(signUpSuccess: "Sign up successful!"),
//           additionalSignupFields: const [
//             UserFormField(
//               keyName: 'username',
//               displayName: 'Username',
//               icon: Icon(FontAwesomeIcons.at),
//               // fieldValidator: (value) {
//               //   String? b;
//               //   DatabaseService.usernameCheck(value!)
//               //       .then((value) => b = value ? null : "Nope!");
//               //   return b!;
//               // },
//             ),
//             UserFormField(
//               keyName: 'name',
//               displayName: 'Name',
//               icon: Icon(FontAwesomeIcons.solidUser),
//             ),
//             UserFormField(
//               keyName: 'account_type',
//               displayName: 'Account Type',
//               icon: Icon(FontAwesomeIcons.artstation),
//             ),
//             UserFormField(
//               keyName: 'dob',
//               displayName: 'Date Of Birth',
//               icon: Icon(FontAwesomeIcons.calendarAlt),
//             ),
//             UserFormField(
//               keyName: 'gender',
//               displayName: 'Gender',
//               icon: Icon(FontAwesomeIcons.atom),
//             ),
//           ],
//           onSubmitAnimationCompleted: () {
//             Navigator.pushReplacementNamed(context, ConvexAppBarDemo.id);
//           },
//           userValidator: (value) {
//             // print(b.testMethod(value!));
//             return "Nope";
//           },
//
//           // (value) {
//           // String? b;
//           // DatabaseService.testMethod(value!)
//           //     .then((value) => b = value ? null : "Nope!");
//           // return b!;
//           // if (!EmailValidator.validate(value!)) {
//           //   return "Enter a valid Email";
//           // }
//           // },
//           passwordValidator: (value) {
//             // RegExp exp = RegExp(
//             //     r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
//             // if (!exp.hasMatch(value!)) {
//             //   return "Use Uppercase, Lowercase, Digits and Symbols";
//             // }
//             // if (value.trim().isEmpty || value.length < 7) {
//             //   return "Password should have at least 7 characters.";
//             // }
//           },
//         );
//       },
//     );
//   }
// }
