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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA2dw8y8jst1YE2G0zGnsHpQaVKuDWzf3o',
    appId: '1:304618395292:android:5c23885982250d4952bf59',
    messagingSenderId: '304618395292',
    projectId: 'zoo-zimba',
    databaseURL: 'https://zoo-zimba-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'zoo-zimba.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: '', //key here
    appId: '1:304618395292:ios:ca9158abf6ed64a952bf59',
    messagingSenderId: '304618395292',
    projectId: 'zoo-zimba',
    databaseURL: 'https://zoo-zimba-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'zoo-zimba.appspot.com',
    androidClientId: '304618395292-87cua4eoh7balvssn7c074o74dguekqs.apps.googleusercontent.com',
    iosClientId: '304618395292-jok532o5b7g9la79mspgv0t47c2d70is.apps.googleusercontent.com',
    iosBundleId: 'com.example.zooZimba',
  );
}
