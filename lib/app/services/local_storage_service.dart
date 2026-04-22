import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_profile.dart';

class LocalStorageService {
  LocalStorageService(this._prefs);

  static const _profileKey = 'cached_profile';
  static const _uidKey = 'cached_uid';

  final SharedPreferences _prefs;

  UserProfile? getCachedProfile() {
    final raw = _prefs.getString(_profileKey);
    if (raw == null || raw.isEmpty) {
      return null;
    }
    return UserProfile.fromJson(raw);
  }

  Future<void> cacheProfile(UserProfile profile) {
    return _prefs.setString(_profileKey, profile.toJson());
  }

  String? getCachedUid() {
    return _prefs.getString(_uidKey);
  }

  Future<void> cacheUid(String uid) {
    return _prefs.setString(_uidKey, uid);
  }
}
