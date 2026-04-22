import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  const UserProfile({
    required this.uid,
    required this.name,
    required this.neighborhoodId,
    required this.neighborhoodLabel,
    required this.apartmentLabel,
    required this.notificationsEnabled,
    required this.createdAt,
    required this.updatedAt,
  });

  final String uid;
  final String name;
  final String neighborhoodId;
  final String neighborhoodLabel;
  final String apartmentLabel;
  final bool notificationsEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile copyWith({
    String? uid,
    String? name,
    String? neighborhoodId,
    String? neighborhoodLabel,
    String? apartmentLabel,
    bool? notificationsEnabled,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      neighborhoodId: neighborhoodId ?? this.neighborhoodId,
      neighborhoodLabel: neighborhoodLabel ?? this.neighborhoodLabel,
      apartmentLabel: apartmentLabel ?? this.apartmentLabel,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'neighborhoodId': neighborhoodId,
      'neighborhoodLabel': neighborhoodLabel,
      'apartmentLabel': apartmentLabel,
      'notificationsEnabled': notificationsEnabled,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    DateTime parseDate(dynamic value) {
      if (value is Timestamp) {
        return value.toDate();
      }
      if (value is DateTime) {
        return value;
      }
      return DateTime.now();
    }

    return UserProfile(
      uid: map['uid'] as String? ?? '',
      name: map['name'] as String? ?? '',
      neighborhoodId: map['neighborhoodId'] as String? ?? '',
      neighborhoodLabel: map['neighborhoodLabel'] as String? ?? '',
      apartmentLabel: map['apartmentLabel'] as String? ?? '',
      notificationsEnabled: map['notificationsEnabled'] as bool? ?? true,
      createdAt: parseDate(map['createdAt']),
      updatedAt: parseDate(map['updatedAt']),
    );
  }

  String toJson() => jsonEncode(
    toMap()
      ..update('createdAt', (_) => createdAt.toIso8601String())
      ..update('updatedAt', (_) => updatedAt.toIso8601String()),
  );

  factory UserProfile.fromJson(String source) {
    final decoded = jsonDecode(source) as Map<String, dynamic>;
    decoded['createdAt'] = DateTime.tryParse(
      decoded['createdAt'] as String? ?? '',
    );
    decoded['updatedAt'] = DateTime.tryParse(
      decoded['updatedAt'] as String? ?? '',
    );
    return UserProfile.fromMap(decoded);
  }
}
