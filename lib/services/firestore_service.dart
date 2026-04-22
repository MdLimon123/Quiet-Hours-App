import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../app/models/community_alert.dart';
import '../app/models/quiet_reason.dart';
import '../app/models/quiet_request.dart';
import '../app/models/user_profile.dart';

class FirestoreService {
  FirestoreService({required bool useDemoData}) : _useDemoData = useDemoData {
    if (_useDemoData) {
      _seedDemoData();
    }
  }

  final bool _useDemoData;
  FirebaseFirestore get _db => FirebaseFirestore.instance;

  final _demoRequests = <QuietRequest>[].obs;
  final _demoAlerts = <CommunityAlert>[].obs;
  final _demoProfiles = <String, UserProfile>{}.obs;

  bool get useDemoData => _useDemoData;

  Future<UserProfile?> fetchUserProfile(String uid) async {
    if (_useDemoData) {
      return _demoProfiles[uid];
    }

    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists || doc.data() == null) {
      return null;
    }
    return UserProfile.fromMap(doc.data()!);
  }

  Future<void> upsertUserProfile(UserProfile profile) async {
    if (_useDemoData) {
      _demoProfiles[profile.uid] = profile;
      return;
    }

    await _db
        .collection('users')
        .doc(profile.uid)
        .set(profile.toMap(), SetOptions(merge: true));
  }

  Stream<List<QuietRequest>> watchActiveRequests(String neighborhoodId) {
    if (_useDemoData) {
      return _demoRequests.stream.map(
        (items) =>
            items
                .where(
                  (request) =>
                      request.active &&
                      request.neighborhoodId == neighborhoodId,
                )
                .toList()
              ..sort((a, b) => b.createdAt.compareTo(a.createdAt)),
      );
    }

    return _db
        .collection('quiet_requests')
        .where('neighborhoodId', isEqualTo: neighborhoodId)
        .where('active', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map(QuietRequest.fromDoc).toList(growable: false),
        );
  }

  Stream<QuietRequest?> watchMyActiveRequest(String userId) {
    if (_useDemoData) {
      return _demoRequests.stream.map(
        (items) => items.cast<QuietRequest?>().firstWhereOrNull(
          (request) => request?.userId == userId && (request?.active ?? false),
        ),
      );
    }

    return _db
        .collection('quiet_requests')
        .where('userId', isEqualTo: userId)
        .where('active', isEqualTo: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) {
            return null;
          }
          return QuietRequest.fromDoc(snapshot.docs.first);
        });
  }

  Stream<List<CommunityAlert>> watchCommunityAlerts(String neighborhoodId) {
    if (_useDemoData) {
      return _demoAlerts.stream.map(
        (items) =>
            items
                .where((alert) => alert.neighborhoodId == neighborhoodId)
                .toList()
              ..sort((a, b) => b.createdAt.compareTo(a.createdAt)),
      );
    }

    return _db
        .collection('community_alerts')
        .where('neighborhoodId', isEqualTo: neighborhoodId)
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map(CommunityAlert.fromDoc).toList(growable: false),
        );
  }

  Future<void> createQuietRequest({
    required String userId,
    required String requesterName,
    required String neighborhoodId,
    required QuietReasonType reason,
    required String note,
    required int durationMinutes,
  }) async {
    final now = DateTime.now();
    final endTime = now.add(Duration(minutes: durationMinutes));

    if (_useDemoData) {
      final id = 'demo-${now.millisecondsSinceEpoch}';
      final request = QuietRequest(
        id: id,
        userId: userId,
        requesterName: requesterName,
        neighborhoodId: neighborhoodId,
        reason: reason,
        note: note.trim(),
        startTime: now,
        endTime: endTime,
        active: true,
        createdAt: now,
      );
      final alert = CommunityAlert(
        id: 'alert-$id',
        neighborhoodId: neighborhoodId,
        requestId: id,
        senderUserId: userId,
        title: 'নতুন শান্ত সময় অনুরোধ',
        body: '$requesterName ${reason.label} কারণে কিছু সময় শব্দ কমাতে বলছেন।',
        createdAt: now,
      );
      _demoRequests.insert(0, request);
      _demoAlerts.insert(0, alert);
      return;
    }

    final requestRef = _db.collection('quiet_requests').doc();
    final alertRef = _db.collection('community_alerts').doc();

    final request = QuietRequest(
      id: requestRef.id,
      userId: userId,
      requesterName: requesterName,
      neighborhoodId: neighborhoodId,
      reason: reason,
      note: note.trim(),
      startTime: now,
      endTime: endTime,
      active: true,
      createdAt: now,
    );

    final alert = CommunityAlert(
      id: alertRef.id,
      neighborhoodId: neighborhoodId,
      requestId: requestRef.id,
      senderUserId: userId,
      title: 'নতুন শান্ত সময় অনুরোধ',
      body: '$requesterName ${reason.label} কারণে কিছু সময় শব্দ কমাতে বলছেন।',
      createdAt: now,
    );

    final batch = _db.batch();
    batch.set(requestRef, request.toMap());
    batch.set(alertRef, alert.toMap());
    await batch.commit();
  }

  Future<void> endQuietRequest(String requestId) async {
    if (_useDemoData) {
      final index = _demoRequests.indexWhere(
        (request) => request.id == requestId,
      );
      if (index == -1) {
        return;
      }
      final old = _demoRequests[index];
      _demoRequests[index] = QuietRequest(
        id: old.id,
        userId: old.userId,
        requesterName: old.requesterName,
        neighborhoodId: old.neighborhoodId,
        reason: old.reason,
        note: old.note,
        startTime: old.startTime,
        endTime: old.endTime,
        active: false,
        createdAt: old.createdAt,
      );
      return;
    }

    await _db.collection('quiet_requests').doc(requestId).update(
      <String, dynamic>{'active': false},
    );
  }

  void _seedDemoData() {
    final now = DateTime.now();
    const neighborhoodId = 'banani-road-11';

    _demoProfiles['demo-neighbor-001'] = UserProfile(
      uid: 'demo-neighbor-001',
      name: 'রাইয়ান',
      neighborhoodId: neighborhoodId,
      neighborhoodLabel: 'Banani Road 11',
      apartmentLabel: 'House 22, Flat B2',
      notificationsEnabled: true,
      createdAt: now.subtract(const Duration(days: 5)),
      updatedAt: now.subtract(const Duration(hours: 1)),
    );

    _demoRequests.assignAll(<QuietRequest>[
      QuietRequest(
        id: 'seed-1',
        userId: 'neighbor-1',
        requesterName: 'তানিয়া আপা',
        neighborhoodId: neighborhoodId,
        reason: QuietReasonType.sleepingBaby,
        note: 'বাচ্চা এখনই ঘুমিয়েছে, ৩০ মিনিট শান্ত পরিবেশ চাই।',
        startTime: now.subtract(const Duration(minutes: 10)),
        endTime: now.add(const Duration(minutes: 30)),
        active: true,
        createdAt: now.subtract(const Duration(minutes: 12)),
      ),
      QuietRequest(
        id: 'seed-2',
        userId: 'neighbor-2',
        requesterName: 'মাহির',
        neighborhoodId: neighborhoodId,
        reason: QuietReasonType.study,
        note: 'মডেল টেস্ট চলছে, একটু কম শব্দে থাকলে উপকার হয়।',
        startTime: now.subtract(const Duration(minutes: 20)),
        endTime: now.add(const Duration(minutes: 40)),
        active: true,
        createdAt: now.subtract(const Duration(minutes: 22)),
      ),
    ]);

    _demoAlerts.assignAll(<CommunityAlert>[
      CommunityAlert(
        id: 'seed-alert-1',
        neighborhoodId: neighborhoodId,
        requestId: 'seed-1',
        senderUserId: 'neighbor-1',
        title: 'তানিয়া আপার সৌজন্য অনুরোধ',
        body: 'বাচ্চা ঘুমাচ্ছে, তাই করিডোরে একটু নরমভাবে চলাফেরা করুন।',
        createdAt: now.subtract(const Duration(minutes: 8)),
      ),
      CommunityAlert(
        id: 'seed-alert-2',
        neighborhoodId: neighborhoodId,
        requestId: 'seed-2',
        senderUserId: 'neighbor-2',
        title: 'মাহিরের স্টাডি আওয়ার',
        body:
            'পরীক্ষার প্রস্তুতি চলছে। ১ ঘণ্টা হালকা শব্দ রাখলে খুব সাহায্য হবে।',
        createdAt: now.subtract(const Duration(minutes: 18)),
      ),
    ]);
  }
}
