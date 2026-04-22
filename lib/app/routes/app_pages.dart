import 'package:get/get.dart';

import '../../home_screen.dart';
import '../ui/screens/alerts_screen.dart';
import '../ui/screens/create_request_screen.dart';
import '../ui/screens/main_shell_screen.dart';
import '../ui/screens/onboarding_screen.dart';
import '../ui/screens/settings_screen.dart';
import '../ui/screens/splash_screen.dart';
import '../ui/screens/requests_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = <GetPage<dynamic>>[
    GetPage<dynamic>(name: AppRoutes.splash, page: SplashScreen.new),
    GetPage<dynamic>(name: AppRoutes.onboarding, page: OnboardingScreen.new),
    GetPage<dynamic>(name: AppRoutes.shell, page: MainShellScreen.new),
    GetPage<dynamic>(
      name: AppRoutes.createRequest,
      page: CreateRequestScreen.new,
    ),
    GetPage<dynamic>(name: '/tab-home', page: HomeScreen.new),
    GetPage<dynamic>(name: '/tab-requests', page: RequestsScreen.new),
    GetPage<dynamic>(name: '/tab-alerts', page: AlertsScreen.new),
    GetPage<dynamic>(name: '/tab-settings', page: SettingsScreen.new),
  ];
}
