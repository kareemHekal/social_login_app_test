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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDgCqcMMCuhHH8Y9y9BSwPnDE6oFcd0PeE',
    appId: '1:41238382280:android:8207d6e9d5ac66cba9c7fd',
    messagingSenderId: '41238382280',
    projectId: 'social-login-test-ef879',
    storageBucket: 'social-login-test-ef879.firebasestorage.app',
  );
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDjcXVeviA2_RwpFO48HRU2mL2KQw6dxMg',
    appId: '1:41238382280:web:5312b458af51f196a9c7fd',
    messagingSenderId: '41238382280',
    projectId: 'social-login-test-ef879',
    authDomain: 'social-login-test-ef879.firebaseapp.com',
    storageBucket: 'social-login-test-ef879.firebasestorage.app',
    measurementId: 'G-Z7JL3BJDBH',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBc-9dIP9EmoxHsy-rlNJAsRYgA_ld-4fE',
    appId: '1:41238382280:ios:2175cc354d4bd9bfa9c7fd',
    messagingSenderId: '41238382280',
    projectId: 'social-login-test-ef879',
    storageBucket: 'social-login-test-ef879.firebasestorage.app',
    iosClientId: '41238382280-11a1mhetigpmn9b5m6k9qhb0j6ucm4vd.apps.googleusercontent.com',
    iosBundleId: 'com.example.socialLoginAppTest',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBc-9dIP9EmoxHsy-rlNJAsRYgA_ld-4fE',
    appId: '1:41238382280:ios:2175cc354d4bd9bfa9c7fd',
    messagingSenderId: '41238382280',
    projectId: 'social-login-test-ef879',
    storageBucket: 'social-login-test-ef879.firebasestorage.app',
    iosClientId: '41238382280-11a1mhetigpmn9b5m6k9qhb0j6ucm4vd.apps.googleusercontent.com',
    iosBundleId: 'com.example.socialLoginAppTest',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDjcXVeviA2_RwpFO48HRU2mL2KQw6dxMg',
    appId: '1:41238382280:web:271770f5a1374daca9c7fd',
    messagingSenderId: '41238382280',
    projectId: 'social-login-test-ef879',
    authDomain: 'social-login-test-ef879.firebaseapp.com',
    storageBucket: 'social-login-test-ef879.firebasestorage.app',
    measurementId: 'G-X2G8CQ6ZGF',
  );
}
