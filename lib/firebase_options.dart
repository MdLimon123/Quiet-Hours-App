import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static bool get isConfigured => true;

  static FirebaseOptions get currentPlatform {
    if (!isConfigured) {
      throw UnsupportedError(
        'Firebase is not configured yet. Run `flutterfire configure` and '
        'replace lib/firebase_options.dart with the generated file.',
      );
    }

    if (kIsWeb) {
      return web;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        throw UnsupportedError(
          'Quiet Hours currently ships mobile-ready Firebase defaults only.',
        );
      case TargetPlatform.fuchsia:
        throw UnsupportedError('Fuchsia is not supported.');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCgc5RdH1p4_W_shkuCU6GsuvFBmTvZxs8',
    appId: '1:830325943224:web:6286050b9c5e9527abbd4d',
    messagingSenderId: '830325943224',
    projectId: 'quiet-hours-app',
    authDomain: 'quiet-hours-app.firebaseapp.com',
    storageBucket: 'quiet-hours-app.firebasestorage.app',
    measurementId: 'G-CTP5EC3HSY',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDFssBc1Zw6PzUQOU8Pju1hvKGXsxaIgqE',
    appId: '1:830325943224:android:1121ce36cb689cadabbd4d',
    messagingSenderId: '830325943224',
    projectId: 'quiet-hours-app',
    storageBucket: 'quiet-hours-app.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyARp0QnNhwyf19Li4W0u3jFqalrQjIAScw',
    appId: '1:830325943224:ios:0a23b319f46511aeabbd4d',
    messagingSenderId: '830325943224',
    projectId: 'quiet-hours-app',
    storageBucket: 'quiet-hours-app.firebasestorage.app',
    iosBundleId: 'com.example.quietHoursApp',
  );
}
