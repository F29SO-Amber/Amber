import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:amber/constants.dart';
import 'package:amber/screens/login.dart';
import 'package:amber/screens/navbar.dart';
import 'package:amber/firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // DatabaseService.testMethod('am2024');
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
