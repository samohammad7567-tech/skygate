import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyC0EGkAoRR8EMIBChmlV8_yUZy3OS6KdVQ',
    appId: '1:1016963884485:android:570fdaca03543d602497ac',
    messagingSenderId: '1016963884485',
    projectId: 'skygate-1a526',
    storageBucket: 'skygate-1a526.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA7z0kJdHzazBMg9wbTUQjJ5jqRwy6h1r8',
    appId: '1:1016963884485:ios:ff64592d3d9f228a2497ac',
    messagingSenderId: '1016963884485',
    projectId: 'skygate-1a526',
    storageBucket: 'skygate-1a526.firebasestorage.app',
    iosBundleId: 'com.eliasdahi.skygate.skyGate',
  );
}
