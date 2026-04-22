import 'package:cloud_firestore/cloud_firestore.dart';

import 'quiet_reason.dart';

class QuietRequest {
  const QuietRequest({
    required this.id,
    required this.userId,
    required this.requesterName,
    required this.neighborhoodId,
    required this.reason,
    required this.note,
    required this.startTime,
    required this.endTime,
    required this.active,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final String requesterName;
  final String neighborhoodId;
  final QuietReasonType reason;
  final String note;
  final DateTime startTime;
  final DateTime endTime;
  final bool active;
  final DateTime createdAt;

  int get remainingMinutes {
    final diff = endTime.difference(DateTime.now()).inMinutes;
    return diff < 0 ? 0 : diff;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'requesterName': requesterName,
      'neighborhoodId': neighborhoodId,
      'reason': reason.keyName,
      'note': note,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
      'active': active,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory QuietRequest.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return QuietRequest.fromMap(doc.id, data);
  }

  factory QuietRequest.fromMap(String id, Map<String, dynamic> map) {
    DateTime parseDate(dynamic value) {
      if (value is Timestamp) {
        return value.toDate();
      }
      if (value is DateTime) {
        return value;
      }
      return DateTime.now();
    }

    return QuietRequest(
      id: id,
      userId: map['userId'] as String? ?? '',
      requesterName: map['requesterName'] as String? ?? 'প্রতিবেশী',
      neighborhoodId: map['neighborhoodId'] as String? ?? '',
      reason: QuietReasonTypeX.fromKey(map['reason'] as String? ?? ''),
      note: map['note'] as String? ?? '',
      startTime: parseDate(map['startTime']),
      endTime: parseDate(map['endTime']),
      active: map['active'] as bool? ?? false,
      createdAt: parseDate(map['createdAt']),
    );
  }
}
