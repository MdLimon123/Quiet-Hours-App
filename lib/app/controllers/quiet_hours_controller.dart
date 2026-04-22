import 'dart:async';

import 'package:get/get.dart';

import '../../services/firestore_service.dart';
import '../models/community_alert.dart';
import '../models/quiet_reason.dart';
import '../models/quiet_request.dart';
import '../services/notification_service.dart';
import 'session_controller.dart';

class QuietHoursController extends GetxController {
  QuietHoursController({
    required FirestoreService firestoreService,
    required SessionController sessionController,
    required NotificationService notificationService,
  }) : _firestoreService = firestoreService,
       _sessionController = sessionController,
       _notificationService = notificationService;

  final FirestoreService _firestoreService;
  final SessionController _sessionController;
  final NotificationService _notificationService;

  final requests = <QuietRequest>[].obs;
  final alerts = <CommunityAlert>[].obs;
  final myActiveRequest = Rxn<QuietRequest>();
  final isSubmitting = false.obs;

  StreamSubscription<List<QuietRequest>>? _requestsSub;
  StreamSubscription<QuietRequest?>? _myRequestSub;
  StreamSubscription<List<CommunityAlert>>? _alertsSub;
  final Set<String> _seenAlertIds = <String>{};

  @override
  void onInit() {
    super.onInit();
    ever<dynamic>(_sessionController.profile, (_) {
      _bindStreams();
    });
  }

  void _bindStreams() {
    _requestsSub?.cancel();
    _myRequestSub?.cancel();
    _alertsSub?.cancel();

    final profile = _sessionController.profile.value;
    if (profile == null) {
      requests.clear();
      alerts.clear();
      myActiveRequest.value = null;
      return;
    }

    _requestsSub = _firestoreService
        .watchActiveRequests(profile.neighborhoodId)
        .listen(requests.assignAll);

    _myRequestSub = _firestoreService
        .watchMyActiveRequest(_sessionController.uid)
        .listen((request) {
          myActiveRequest.value = request;
        });

    _alertsSub = _firestoreService
        .watchCommunityAlerts(profile.neighborhoodId)
        .listen((incomingAlerts) async {
          final isFirstLoad = _seenAlertIds.isEmpty;
          alerts.assignAll(incomingAlerts);

          if (isFirstLoad) {
            _seenAlertIds.addAll(incomingAlerts.map((alert) => alert.id));
            return;
          }

          for (final alert in incomingAlerts) {
            if (_seenAlertIds.contains(alert.id)) {
              continue;
            }
            _seenAlertIds.add(alert.id);
            if (alert.senderUserId == _sessionController.uid) {
              continue;
            }
            await _notificationService.showLocalAlert(
              title: alert.title,
              body: alert.body,
            );
          }
        });
  }

  Future<void> createRequest({
    required QuietReasonType reason,
    required int durationMinutes,
    required String note,
  }) async {
    final profile = _sessionController.profile.value;
    if (profile == null) {
      Get.snackbar(
        'প্রোফাইল অসম্পূর্ণ',
        'আগে আপনার পাড়া ও নাম সেটআপ করুন।',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isSubmitting.value = true;
    try {
      await _firestoreService.createQuietRequest(
        userId: _sessionController.uid,
        requesterName: profile.name,
        neighborhoodId: profile.neighborhoodId,
        reason: reason,
        note: note,
        durationMinutes: durationMinutes,
      );
      Get.back<void>();
      Get.snackbar(
        'সংকেত পাঠানো হয়েছে',
        'আশেপাশের মানুষদের নরমভাবে অনুরোধ পাঠানো হয়েছে।',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> endActiveRequest() async {
    final activeRequest = myActiveRequest.value;
    if (activeRequest == null) {
      return;
    }
    await _firestoreService.endQuietRequest(activeRequest.id);
    Get.snackbar(
      'শান্ত সময় শেষ',
      'আপনার প্রতিবেশীদের ধন্যবাদ জানানোর সময় এসেছে।',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  int get activeNeighborCount {
    final myUid = _sessionController.uid;
    return requests.where((request) => request.userId != myUid).length;
  }

  List<QuietReasonType> get quickReasons => QuietReasonType.values;

  @override
  void onClose() {
    _requestsSub?.cancel();
    _myRequestSub?.cancel();
    _alertsSub?.cancel();
    super.onClose();
  }
}
