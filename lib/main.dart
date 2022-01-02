import 'package:amber/Screens/chats.dart';
import 'package:amber/Screens/discover.dart';
import 'package:amber/Screens/navbar.dart';
import 'package:amber/Screens/post.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:amber/Screens/profile.dart';
import 'package:amber/Screens/login.dart';
import 'package:amber/Screens/home.dart';
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
        ProfilePage.id: (context) => const ProfilePage(),
        ChatsPage.id: (context) => const ChatsPage(),
        DiscoverPage.id: (context) => const DiscoverPage(),
        PostPage.id: (context) => const PostPage(),
        HomePage.id: (context) => const HomePage(),
        ProvidedStylesExample.id: (context) => ProvidedStylesExample()
      },
    );
  }
}
