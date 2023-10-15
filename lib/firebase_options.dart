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
    apiKey: 'AIzaSyDxa3Xwc0lsE2LYN25dOQHKkEQd-NvS5m0',
    appId: '1:493223446402:web:7f4eefd9a06d17e7c7719b',
    messagingSenderId: '493223446402',
    projectId: 'n-b40e3',
    authDomain: 'n-b40e3.firebaseapp.com',
    storageBucket: 'n-b40e3.appspot.com',
    measurementId: 'G-PP348B0EHC',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCQAakescxhJ7oUOBpv92khf_ezw4a7vsI',
    appId: '1:493223446402:android:1ce3edf135d6a7f3c7719b',
    messagingSenderId: '493223446402',
    projectId: 'n-b40e3',
    storageBucket: 'n-b40e3.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC_9lJnTFUCXPyLqAEcvPZKn3A-9rAcixM',
    appId: '1:493223446402:ios:d405dcba420df4f4c7719b',
    messagingSenderId: '493223446402',
    projectId: 'n-b40e3',
    storageBucket: 'n-b40e3.appspot.com',
    iosClientId: '493223446402-t11c7osuu5tn8rg0gjsu3cnclok1topu.apps.googleusercontent.com',
    iosBundleId: 'com.example.amazon',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC_9lJnTFUCXPyLqAEcvPZKn3A-9rAcixM',
    appId: '1:493223446402:ios:d405dcba420df4f4c7719b',
    messagingSenderId: '493223446402',
    projectId: 'n-b40e3',
    storageBucket: 'n-b40e3.appspot.com',
    iosClientId: '493223446402-t11c7osuu5tn8rg0gjsu3cnclok1topu.apps.googleusercontent.com',
    iosBundleId: 'com.example.amazon',
  );
}