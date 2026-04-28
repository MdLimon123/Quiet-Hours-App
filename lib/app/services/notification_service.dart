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

    await _localNotifications.initialize(
      settings: settings,
    );

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
      final (:title, :body) = remoteDisplayTexts(message);
      await showLocalAlert(title: title, body: body);
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
    try {
      await FirebaseMessaging.instance.subscribeToTopic(
        _topic(neighborhoodId),
      );
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('FCM subscribe failed for topic ${_topic(neighborhoodId)}: $e');
        debugPrint('$st');
      }
    }
  }

  Future<void> unsubscribeFromNeighborhood(String neighborhoodId) async {
    if (!DefaultFirebaseOptions.isConfigured || neighborhoodId.isEmpty) {
      return;
    }
    try {
      await FirebaseMessaging.instance.unsubscribeFromTopic(
        _topic(neighborhoodId),
      );
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint(
          'FCM unsubscribe failed for topic ${_topic(neighborhoodId)}: $e',
        );
        debugPrint('$st');
      }
    }
  }

  /// Strips zero-width / invisible chars that can break Android notification text.
  static String sanitizeNotificationText(String? value) {
    if (value == null || value.isEmpty) {
      return '';
    }
    return value
        .replaceAll(RegExp(r'[\u200B-\u200F\u2060-\u206F\uFEFF]'), '')
        .replaceAll('\u00a0', ' ')
        .trim();
  }

  /// Merges notification + data payloads ([functions/index.js] may send titles in [RemoteMessage.data] only).
  static ({String title, String body}) remoteDisplayTexts(RemoteMessage message) {
    final d = message.data;
    final n = message.notification;

    String fromData(String key) {
      final v = d[key];
      return sanitizeNotificationText(v == null ? '' : v.toString());
    }

    var title = sanitizeNotificationText(n?.title);
    if (title.isEmpty) {
      title = fromData('title');
    }
    if (title.isEmpty) {
      title = fromData('alert');
    }

    var body = sanitizeNotificationText(n?.body);
    if (body.isEmpty) {
      body = fromData('body');
    }
    if (body.isEmpty) {
      body = fromData('message');
    }

    if (title.isEmpty && body.isEmpty) {
      return (title: '', body: '');
    }
    final displayTitle =
        title.isEmpty ? 'Quiet Hours' : title;
    return (title: displayTitle, body: body);
  }

  Future<void> showLocalAlert({
    required String title,
    required String body,
  }) async {
    final rawTitle = sanitizeNotificationText(title);
    final rawBody = sanitizeNotificationText(body);
    if (rawTitle.isEmpty && rawBody.isEmpty) {
      return;
    }

    final safeTitle = rawTitle.isEmpty ? 'Quiet Hours' : rawTitle;
    final safeBody = rawBody;

    final bigText =
        safeBody.isNotEmpty ? safeBody : safeTitle;

    final androidDetails = AndroidNotificationDetails(
      _alertsChannelId,
      _alertsChannelName,
      channelDescription: _alertsChannelDescription,
      importance: Importance.max,
      priority: Priority.high,
      visibility: NotificationVisibility.public,
      channelShowBadge: true,
      styleInformation: BigTextStyleInformation(
        bigText,
        htmlFormatBigText: false,
        contentTitle: safeTitle,
        htmlFormatContentTitle: false,
      ),
    );
    const iosDetails = DarwinNotificationDetails();
    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: safeTitle,
      body: safeBody.isNotEmpty ? safeBody : safeTitle,
      notificationDetails: details,
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
    final senderUserId =
        message.data['senderUserId']?.toString();
    return senderUserId == null || senderUserId != currentUserId;
  }

  /// If [RemoteMessage.notification] is present, OS usually shows tray + background isolate;
  /// then skip [showLocalAlert] so the same ping is not duplicated.
  static bool shouldSkipManualShowBecausePlatformDisplayed(
    RemoteMessage message,
  ) =>
      message.notification != null;

  bool _shouldDisplayMessage(RemoteMessage message) {
    final currentUserId = _localStorageService?.getCachedUid();
    return shouldDisplayBackgroundMessage(
      message,
      currentUserId: currentUserId,
    );
  }
}
