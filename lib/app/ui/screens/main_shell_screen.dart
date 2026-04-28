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
        extendBody: true,
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: screens,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: FloatingActionButton.extended(
            onPressed: () => Get.toNamed(AppRoutes.createRequest),
            icon: const Icon(Icons.notifications_paused_rounded, size: 22),
            label: const Text('শান্ত সময়'),
          ),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: controller.currentIndex.value,
          onDestinationSelected: controller.changeIndex,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const <NavigationDestination>[
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'হোম',
            ),
            NavigationDestination(
              icon: Icon(Icons.graphic_eq_outlined),
              selectedIcon: Icon(Icons.graphic_eq_rounded),
              label: 'অনুরোধ',
            ),
            NavigationDestination(
              icon: Icon(Icons.notifications_none_rounded),
              selectedIcon: Icon(Icons.notifications_active_rounded),
              label: 'অ্যালার্ট',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings_rounded),
              label: 'সেটিংস',
            ),
          ],
        ),
      ),
    );
  }
}
