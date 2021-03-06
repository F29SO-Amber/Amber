// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAcTgsuK8pFtup2AmhJN4Iondc24QxMXVE',
    appId: '1:150117404817:web:fba5147cc54f73d00eef30',
    messagingSenderId: '150117404817',
    projectId: 'f29so-group-5-amber',
    authDomain: 'f29so-group-5-amber.firebaseapp.com',
    storageBucket: 'f29so-group-5-amber.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDCr1r6D9YSERsAB9Ld7gQHit2mVT4h_hc',
    appId: '1:150117404817:android:3e884ad585c8c8630eef30',
    messagingSenderId: '150117404817',
    projectId: 'f29so-group-5-amber',
    storageBucket: 'f29so-group-5-amber.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB3HWkO_lFaDgkTiAMZ2Ig8HWN-c_ZRaNE',
    appId: '1:150117404817:ios:1fd2884a65dd74bf0eef30',
    messagingSenderId: '150117404817',
    projectId: 'f29so-group-5-amber',
    storageBucket: 'f29so-group-5-amber.appspot.com',
    iosClientId: '150117404817-ldt04gq662el0o3smnp7s9j1juh71m36.apps.googleusercontent.com',
    iosBundleId: 'com.f29sogroup5.amber',
  );
}
