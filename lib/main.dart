import 'package:amber/screens/chats.dart';
import 'package:amber/screens/discover.dart';
import 'package:amber/screens/navbar.dart';
import 'package:amber/screens/post.dart';
import 'package:amber/screens/login.dart';
import 'package:amber/services/authentication.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:amber/screens/profile_screen/profile.dart';
import 'package:amber/screens/home.dart';
import 'package:amber/firebase_options.dart';
import 'package:amber/constants.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: createMaterialColor(const Color(0xff9eb7ff)),
        ).copyWith(secondary: Colors.orange),
        textSelectionTheme:
            const TextSelectionThemeData(cursorColor: Colors.orange),
      ),
      initialRoute: LoginScreen.id,
      routes: {
        LoginScreen.id: (context) => const LoginScreen(),
        ConvexAppBarDemo.id: (context) => const ConvexAppBarDemo()
      },
    );
  }
}
