// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyCUounaAYB3pwzF7h5LzX_f_SpuXy6iKXg',
    appId: '1:36183839050:web:b9dd57df9ae8300c14f1b3',
    messagingSenderId: '36183839050',
    projectId: 'ecolapp-2754d',
    authDomain: 'ecolapp-2754d.firebaseapp.com',
    storageBucket: 'ecolapp-2754d.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDn53CC4bqtArbXLMSrQI4dnb62qzSy1go',
    appId: '1:36183839050:android:01a1285f5266ff1514f1b3',
    messagingSenderId: '36183839050',
    projectId: 'ecolapp-2754d',
    storageBucket: 'ecolapp-2754d.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDla85CQ2WxG3xH0Gr04iGuWJhjL9pXDPE',
    appId: '1:36183839050:ios:bb6b5305b2620ce714f1b3',
    messagingSenderId: '36183839050',
    projectId: 'ecolapp-2754d',
    storageBucket: 'ecolapp-2754d.firebasestorage.app',
    iosBundleId: 'com.example.bancosbase',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDla85CQ2WxG3xH0Gr04iGuWJhjL9pXDPE',
    appId: '1:36183839050:ios:bb6b5305b2620ce714f1b3',
    messagingSenderId: '36183839050',
    projectId: 'ecolapp-2754d',
    storageBucket: 'ecolapp-2754d.firebasestorage.app',
    iosBundleId: 'com.example.bancosbase',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCUounaAYB3pwzF7h5LzX_f_SpuXy6iKXg',
    appId: '1:36183839050:web:84decfeaf344198f14f1b3',
    messagingSenderId: '36183839050',
    projectId: 'ecolapp-2754d',
    authDomain: 'ecolapp-2754d.firebaseapp.com',
    storageBucket: 'ecolapp-2754d.firebasestorage.app',
  );

}