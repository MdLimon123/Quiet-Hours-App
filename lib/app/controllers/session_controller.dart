import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../services/firestore_service.dart';
import '../models/user_profile.dart';
import '../services/local_storage_service.dart';
import '../services/notification_service.dart';

class SessionController extends GetxController {
  SessionController({
    required FirestoreService firestoreService,
    required LocalStorageService localStorageService,
    required NotificationService notificationService,
  }) : _firestoreService = firestoreService,
       _localStorageService = localStorageService,
       _notificationService = notificationService;

  final FirestoreService _firestoreService;
  final LocalStorageService _localStorageService;
  final NotificationService _notificationService;

  final isBootstrapping = false.obs;
  final profile = Rxn<UserProfile>();
  final firebaseModeLabel = ''.obs;
  final bootstrapError = RxnString();

  String _uid = '';
  bool _didBootstrap = false;

  String get uid => _uid;
  bool get isDemoMode => _firestoreService.useDemoData;

  /// Get current authenticated user from Firebase
  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  /// Call after successful email/password sign-in or sign-up so [_uid] is set
  /// before onboarding or the main shell (skips splash [bootstrap]).
  Future<void> syncSessionAfterFirebaseAuth() async {
    if (isDemoMode) {
      if (_uid.isEmpty) {
        _uid = 'demo-neighbor-001';
        await _localStorageService.cacheUid(_uid);
      }
      profile.value ??= _localStorageService.getCachedProfile();
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    _uid = user.uid;
    await _localStorageService.cacheUid(_uid);

    await _notificationService.requestNotificationPermission();

    try {
      profile.value = await _firestoreService.fetchUserProfile(_uid);
    } catch (_) {
      profile.value = null;
    }

    final existingProfile = profile.value;
    if (existingProfile != null) {
      try {
        await _notificationService.requestNotificationPermission();
        if (existingProfile.notificationsEnabled) {
          await _notificationService.subscribeToNeighborhood(
            existingProfile.neighborhoodId,
          );
        }
      } catch (_) {
        // uid is still valid; notifications are best-effort
      }
    }

    firebaseModeLabel.value = 'Firebase live mode';
    _didBootstrap = true;
  }

  Future<bool> bootstrap() async {
    if (_didBootstrap) {
      return profile.value != null;
    }

    _didBootstrap = true;
    isBootstrapping.value = true;
    bootstrapError.value = null;
    firebaseModeLabel.value = isDemoMode
        ? 'Demo mode active'
        : 'Firebase live mode';

    try {
      if (isDemoMode) {
        _uid = 'demo-neighbor-001';
        await _localStorageService.cacheUid(_uid);
        profile.value = _localStorageService.getCachedProfile();
      } else {
        final auth = FirebaseAuth.instance;
        final currentUser = auth.currentUser;
        
        if (currentUser == null) {
          // User is not authenticated
          bootstrapError.value = 'User not authenticated';
          return false;
        }
        
        _uid = currentUser.uid;
        await _localStorageService.cacheUid(_uid);
        await _notificationService.requestNotificationPermission();
        profile.value = await _firestoreService.fetchUserProfile(_uid);
      }

      final existingProfile = profile.value;
      if (existingProfile != null) {
        await _notificationService.requestNotificationPermission();
        if (existingProfile.notificationsEnabled) {
          await _notificationService.subscribeToNeighborhood(
            existingProfile.neighborhoodId,
          );
        }
      }
    } on FirebaseAuthException catch (error) {
      bootstrapError.value = _mapFirebaseAuthError(error);
      firebaseModeLabel.value = 'Firebase auth setup required';
      profile.value = null;
      _uid = '';
      return false;
    } catch (_) {
      bootstrapError.value =
          'Session start করা যায়নি। Firebase config আর network আবার check করুন।';
      firebaseModeLabel.value = 'Startup issue detected';
      profile.value = null;
      _uid = '';
      return false;
    } finally {
      isBootstrapping.value = false;
    }

    return profile.value != null;
  }

  Future<bool> retryBootstrap() {
    _didBootstrap = false;
    return bootstrap();
  }

  Future<void> saveProfile({
    required String name,
    required String neighborhoodLabel,
    required String apartmentLabel,
    required bool notificationsEnabled,
  }) async {
    if (_uid.isEmpty) {
      await syncSessionAfterFirebaseAuth();
    }
    if (_uid.isEmpty) {
      throw StateError('No active user id. Please sign in again.');
    }

    final now = DateTime.now();
    final neighborhoodId = _slugifyNeighborhood(neighborhoodLabel);

    final nextProfile = UserProfile(
      uid: _uid,
      name: name.trim(),
      neighborhoodId: neighborhoodId,
      neighborhoodLabel: neighborhoodLabel.trim(),
      apartmentLabel: apartmentLabel.trim(),
      notificationsEnabled: notificationsEnabled,
      createdAt: profile.value?.createdAt ?? now,
      updatedAt: now,
    );

    await _firestoreService.upsertUserProfile(nextProfile);
    await _localStorageService.cacheProfile(nextProfile);

    if (notificationsEnabled) {
      await _notificationService.requestNotificationPermission();
      await _notificationService.subscribeToNeighborhood(neighborhoodId);
    } else {
      await _notificationService.unsubscribeFromNeighborhood(neighborhoodId);
    }

    profile.value = nextProfile;
  }

  String _slugifyNeighborhood(String value) {
    final lowercase = value.trim().toLowerCase();
    final sanitized = lowercase.replaceAll(
      RegExp(r'[^a-z0-9\u0980-\u09ff]+'),
      '-',
    );
    return sanitized
        .replaceAll(RegExp(r'-+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
  }

  String _mapFirebaseAuthError(FirebaseAuthException error) {
    switch (error.code) {
      case 'admin-restricted-operation':
        return 'Anonymous sign-in এই Firebase project-এ এখনও usable নয়। Firebase Console > Authentication > Sign-in method থেকে Anonymous enable করে Save হয়েছে কিনা আবার check করুন, তারপর app full restart দিন।';
      case 'network-request-failed':
        return 'Network issue পাওয়া গেছে। ইন্টারনেট connection check করে আবার চেষ্টা করুন।';
      case 'too-many-requests':
        return 'Firebase auth সাময়িকভাবে request block করেছে। একটু পরে আবার চেষ্টা করুন।';
      default:
        return error.message ??
            'Firebase authentication start করা যায়নি। Console setup আবার check করুন।';
    }
  }

  /// Sign out the current user
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      profile.value = null;
      _uid = '';
      _didBootstrap = false;
      await _localStorageService.clearUid();
    } catch (e) {
      bootstrapError.value = 'Failed to logout: ${e.toString()}';
    }
  }
}
