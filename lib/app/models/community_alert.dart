import 'package:cloud_firestore/cloud_firestore.dart';

class CommunityAlert {
  const CommunityAlert({
    required this.id,
    required this.neighborhoodId,
    required this.requestId,
    required this.senderUserId,
    required this.title,
    required this.body,
    required this.createdAt,
  });

  final String id;
  final String neighborhoodId;
  final String requestId;
  final String senderUserId;
  final String title;
  final String body;
  final DateTime createdAt;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'neighborhoodId': neighborhoodId,
      'requestId': requestId,
      'senderUserId': senderUserId,
      'title': title,
      'body': body,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory CommunityAlert.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    final createdAt = data['createdAt'];
    return CommunityAlert(
      id: doc.id,
      neighborhoodId: data['neighborhoodId'] as String? ?? '',
      requestId: data['requestId'] as String? ?? '',
      senderUserId: data['senderUserId'] as String? ?? '',
      title: data['title'] as String? ?? '',
      body: data['body'] as String? ?? '',
      createdAt: createdAt is Timestamp ? createdAt.toDate() : DateTime.now(),
    );
  }
}
