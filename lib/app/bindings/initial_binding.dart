import 'package:get/get.dart';

import '../../firebase_options.dart';
import '../../services/firestore_service.dart';
import '../controllers/quiet_hours_controller.dart';
import '../controllers/session_controller.dart';
import '../controllers/shell_controller.dart';
import '../services/local_storage_service.dart';
import '../services/notification_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    final localStorage = Get.find<LocalStorageService>();
    final notifications = Get.find<NotificationService>();

    Get.put<FirestoreService>(
      FirestoreService(useDemoData: !DefaultFirebaseOptions.isConfigured),
      permanent: true,
    );

    Get.put<SessionController>(
      SessionController(
        firestoreService: Get.find<FirestoreService>(),
        localStorageService: localStorage,
        notificationService: notifications,
      ),
      permanent: true,
    );

    Get.put<QuietHoursController>(
      QuietHoursController(
        firestoreService: Get.find<FirestoreService>(),
        sessionController: Get.find<SessionController>(),
        notificationService: notifications,
      ),
      permanent: true,
    );

    Get.lazyPut<ShellController>(ShellController.new, fenix: true);
  }
}
