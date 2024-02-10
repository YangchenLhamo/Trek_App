// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA75l0Gn6dG7nflym7X-A4qA3BfbJz8kR8',
    appId: '1:68394056912:web:8c418e5f3f6366059a32d5',
    messagingSenderId: '68394056912',
    projectId: 'trekguide-73723',
    authDomain: 'trekguide-73723.firebaseapp.com',
    storageBucket: 'trekguide-73723.appspot.com',
    measurementId: 'G-P6N939JJSK',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAUpjC-SPjPey9POWM2dhtTycS12EQySYE',
    appId: '1:68394056912:android:1adf8f57f127b3229a32d5',
    messagingSenderId: '68394056912',
    projectId: 'trekguide-73723',
    storageBucket: 'trekguide-73723.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAU48n1EtN_It_1bnAbiyQjLotFPBBd-4Q',
    appId: '1:68394056912:ios:0d5473d93ee3535b9a32d5',
    messagingSenderId: '68394056912',
    projectId: 'trekguide-73723',
    storageBucket: 'trekguide-73723.appspot.com',
    iosBundleId: 'com.example.trekkingGuide',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAU48n1EtN_It_1bnAbiyQjLotFPBBd-4Q',
    appId: '1:68394056912:ios:fe816307522554439a32d5',
    messagingSenderId: '68394056912',
    projectId: 'trekguide-73723',
    storageBucket: 'trekguide-73723.appspot.com',
    iosBundleId: 'com.example.trekkingGuide.RunnerTests',
  );
}
