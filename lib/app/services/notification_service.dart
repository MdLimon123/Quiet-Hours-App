import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../firebase_options.dart';
import 'local_storage_service.dart';

class NotificationService {
  static const String _alertsChannelId = 'quiet_hours_alerts';
  static const String _alertsChannelName = 'Quiet Hours Alerts';
  static const String _alertsChannelDescription =
      'Gentle requests from nearby neighbors';

  static const AndroidNotificationChannel _alertsChannel =
      AndroidNotificationChannel(
        _alertsChannelId,
        _alertsChannelName,
        description: _alertsChannelDescription,
        importance: Importance.max,
      );

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  LocalStorageService? _localStorageService;

  void attachLocalStorage(LocalStorageService service) {
    _localStorageService = service;
  }

  Future<void> initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings();
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(settings);

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_alertsChannel);
  }

  Future<void> initializeRemoteMessaging() async {
    if (!DefaultFirebaseOptions.isConfigured) {
      return;
    }

    await requestNotificationPermission();
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );

    FirebaseMessaging.onMessage.listen((message) async {
      if (!_shouldDisplayMessage(message)) {
        return;
      }
      final notification = message.notification;
      await showLocalAlert(
        title: notification?.title ?? message.data['title'] ?? 'Quiet Hours',
        body: notification?.body ?? message.data['body'] ?? '',
      );
    });
  }

  Future<void> requestNotificationPermission() async {
    if (!DefaultFirebaseOptions.isConfigured) {
      return;
    }

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future<void> subscribeToNeighborhood(String neighborhoodId) async {
    if (!DefaultFirebaseOptions.isConfigured || neighborhoodId.isEmpty) {
      return;
    }
    await FirebaseMessaging.instance.subscribeToTopic(_topic(neighborhoodId));
  }

  Future<void> unsubscribeFromNeighborhood(String neighborhoodId) async {
    if (!DefaultFirebaseOptions.isConfigured || neighborhoodId.isEmpty) {
      return;
    }
    await FirebaseMessaging.instance.unsubscribeFromTopic(
      _topic(neighborhoodId),
    );
  }

  Future<void> showLocalAlert({
    required String title,
    required String body,
  }) async {
    if (title.trim().isEmpty && body.trim().isEmpty) {
      return;
    }
    const androidDetails = AndroidNotificationDetails(
      _alertsChannelId,
      _alertsChannelName,
      channelDescription: _alertsChannelDescription,
      importance: Importance.max,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
    );
  }

  String _topic(String neighborhoodId) {
    final sanitized = neighborhoodId.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '');
    return 'quiet_$sanitized';
  }

  @visibleForTesting
  FlutterLocalNotificationsPlugin get plugin => _localNotifications;

  bool shouldDisplayBackgroundMessage(
    RemoteMessage message, {
    required String? currentUserId,
  }) {
    final senderUserId = message.data['senderUserId'];
    return senderUserId == null || senderUserId != currentUserId;
  }

  bool _shouldDisplayMessage(RemoteMessage message) {
    final currentUserId = _localStorageService?.getCachedUid();
    return shouldDisplayBackgroundMessage(
      message,
      currentUserId: currentUserId,
    );
  }
}
