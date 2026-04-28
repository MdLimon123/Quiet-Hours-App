import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'app/services/local_storage_service.dart';
import 'app/services/notification_service.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (!DefaultFirebaseOptions.isConfigured) {
    return;
  }

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final prefs = await SharedPreferences.getInstance();
  final localStorage = LocalStorageService(prefs);
  final notificationService = NotificationService()
    ..attachLocalStorage(localStorage);
  await notificationService.initializeLocalNotifications();

  if (!notificationService.shouldDisplayBackgroundMessage(
    message,
    currentUserId: localStorage.getCachedUid(),
  )) {
    return;
  }

  // Hybrid FCM payloads: OS tray already shows notification; duplicate local would stack twice.
  if (NotificationService.shouldSkipManualShowBecausePlatformDisplayed(message)) {
    return;
  }

  final (:title, :body) = NotificationService.remoteDisplayTexts(message);
  await notificationService.showLocalAlert(title: title, body: body);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final localStorage = LocalStorageService(
    await SharedPreferences.getInstance(),
  );
  Get.put<LocalStorageService>(localStorage, permanent: true);

  final notificationService = NotificationService();
  notificationService.attachLocalStorage(localStorage);
  await notificationService.initializeLocalNotifications();
  Get.put<NotificationService>(notificationService, permanent: true);

  if (DefaultFirebaseOptions.isConfigured) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    await notificationService.initializeRemoteMessaging();
  }

  runApp(const QuietHoursApp());
}
