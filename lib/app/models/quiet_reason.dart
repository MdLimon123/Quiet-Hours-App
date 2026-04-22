import 'package:flutter/material.dart';

enum QuietReasonType {
  study,
  sleepingBaby,
  migraine,
  prayer,
  workCall,
  elderRest,
}

extension QuietReasonTypeX on QuietReasonType {
  String get keyName => name;

  String get label {
    switch (this) {
      case QuietReasonType.study:
        return 'পড়াশোনা চলছে';
      case QuietReasonType.sleepingBaby:
        return 'বাচ্চা ঘুমাচ্ছে';
      case QuietReasonType.migraine:
        return 'মাথাব্যথা / অসুস্থতা';
      case QuietReasonType.prayer:
        return 'নামাজ / প্রার্থনা';
      case QuietReasonType.workCall:
        return 'গুরুত্বপূর্ণ কল';
      case QuietReasonType.elderRest:
        return 'বয়স্ক মানুষ বিশ্রামে';
    }
  }

  String get shortHint {
    switch (this) {
      case QuietReasonType.study:
        return 'পরীক্ষা বা মনোযোগের সময়';
      case QuietReasonType.sleepingBaby:
        return 'নরম শব্দে সহযোগিতা দরকার';
      case QuietReasonType.migraine:
        return 'কম শব্দে আরাম পাওয়া যাবে';
      case QuietReasonType.prayer:
        return 'শান্ত পরিবেশে ইবাদত';
      case QuietReasonType.workCall:
        return 'কিছু সময় কম শব্দে সহায়তা';
      case QuietReasonType.elderRest:
        return 'বয়স্ক সদস্য বিশ্রামে আছেন';
    }
  }

  IconData get icon {
    switch (this) {
      case QuietReasonType.study:
        return Icons.menu_book_rounded;
      case QuietReasonType.sleepingBaby:
        return Icons.bedtime_rounded;
      case QuietReasonType.migraine:
        return Icons.healing_rounded;
      case QuietReasonType.prayer:
        return Icons.volunteer_activism_rounded;
      case QuietReasonType.workCall:
        return Icons.headset_mic_rounded;
      case QuietReasonType.elderRest:
        return Icons.favorite_outline_rounded;
    }
  }

  static QuietReasonType fromKey(String value) {
    return QuietReasonType.values.firstWhere(
      (reason) => reason.name == value,
      orElse: () => QuietReasonType.study,
    );
  }
}
