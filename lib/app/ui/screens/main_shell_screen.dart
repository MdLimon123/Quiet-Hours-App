import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../home_screen.dart';
import '../../controllers/shell_controller.dart';
import '../../routes/app_routes.dart';
import 'alerts_screen.dart';
import 'requests_screen.dart';
import 'settings_screen.dart';

class MainShellScreen extends GetView<ShellController> {
  const MainShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const screens = <Widget>[
      HomeScreen(),
      RequestsScreen(),
      AlertsScreen(),
      SettingsScreen(),
    ];

    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: screens,
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Get.toNamed(AppRoutes.createRequest),
          label: const Text('Quiet Now'),
          icon: const Icon(Icons.notifications_paused_rounded),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: controller.currentIndex.value,
          onDestinationSelected: controller.changeIndex,
          destinations: const <NavigationDestination>[
            NavigationDestination(
              icon: Icon(Icons.dashboard_customize_outlined),
              selectedIcon: Icon(Icons.dashboard_customize_rounded),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.graphic_eq_outlined),
              selectedIcon: Icon(Icons.graphic_eq_rounded),
              label: 'Requests',
            ),
            NavigationDestination(
              icon: Icon(Icons.notifications_none_rounded),
              selectedIcon: Icon(Icons.notifications_active_rounded),
              label: 'Alerts',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings_rounded),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
