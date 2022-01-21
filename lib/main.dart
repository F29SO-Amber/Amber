import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:amber/screens/login.dart';
import 'package:amber/firebase_options.dart';
import 'package:amber/utilities/constants.dart';
import 'package:amber/screens/home.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    // DevicePreview(
    //   enabled: !kReleaseMode,
    //   builder: (context) => const MyApp(),
    // ),
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Authentication.easySignIn();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
      title: 'Login Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: createMaterialColor(const Color(0xff9eb7ff)),
        ).copyWith(secondary: Colors.orange),
        textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.orange),
      ),
      //initialRoute: LoginScreen.id,
      initialRoute:ChatsPage.id,
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        HomePage.id: (context) => const HomePage()
      },
    );
  }
}
