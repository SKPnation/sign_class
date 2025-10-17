// lib/firebase_options.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform, kIsWeb;

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // 🔹 Replace the values below with those from your Firebase Console

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyD--sT_bY-9dXT2dgAhymsAEPCEdFYh7BM",
    appId: "1:757260583433:web:627fe15ebb56e11865eed8",
    messagingSenderId: "757260583433",
    projectId: "pvamu-student-sign-in",
    authDomain: "pvamu-student-sign-in.firebaseapp.com",
    storageBucket: "pvamu-student-sign-in.appspot.com",
    measurementId: "G-K99SQFSL9H"
  );


  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "YOUR_ANDROID_API_KEY",
    appId: "YOUR_ANDROID_APP_ID",
    messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
    projectId: "YOUR_PROJECT_ID",
    storageBucket: "YOUR_STORAGE_BUCKET",
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "YOUR_IOS_API_KEY",
    appId: "YOUR_IOS_APP_ID",
    messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
    projectId: "YOUR_PROJECT_ID",
    storageBucket: "YOUR_STORAGE_BUCKET",
    iosClientId: "YOUR_IOS_CLIENT_ID",
    iosBundleId: "YOUR_BUNDLE_ID",
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: "YOUR_MACOS_API_KEY",
    appId: "YOUR_MACOS_APP_ID",
    messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
    projectId: "YOUR_PROJECT_ID",
    storageBucket: "YOUR_STORAGE_BUCKET",
    iosClientId: "YOUR_IOS_CLIENT_ID",
    iosBundleId: "YOUR_BUNDLE_ID",
  );
}
