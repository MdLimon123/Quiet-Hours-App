import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/session_controller.dart';
import '../../routes/app_routes.dart';

class SettingsScreen extends GetView<SessionController> {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings & Permissions')),
      body: Obx(() {
        final profile = controller.profile.value;

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
          children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'প্রোফাইল',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text('নাম: ${profile?.name ?? 'Not set'}'),
                    Text('এলাকা: ${profile?.neighborhoodLabel ?? 'Not set'}'),
                    Text(
                      'ফ্ল্যাট: ${profile?.apartmentLabel.isEmpty ?? true ? 'N/A' : profile!.apartmentLabel}',
                    ),
                    const SizedBox(height: 14),
                    OutlinedButton(
                      onPressed: () => Get.toNamed(AppRoutes.onboarding),
                      child: const Text('প্রোফাইল আপডেট'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            Card(
              color: const Color(0xFF123247),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Firebase status',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      controller.firebaseModeLabel.value,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Live mode এ Firestore + Firebase Auth + FCM চলবে। Demo mode এ app preview data দিয়ে চলবে।',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[
                    Text(
                      'Permissions used',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text('1. Notifications: quiet request alerts পাওয়ার জন্য'),
                    Text('2. Internet: Firebase sync এর জন্য'),
                    Text(
                      '3. Background remote notification (iOS): app বন্ধ থাকলেও push পাওয়ার জন্য',
                    ),
                    Text(
                      '4. Optional location: future auto-neighborhood detect feature এর জন্য, current build-এ বাধ্যতামূলক নয়',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    ElevatedButton.icon(
                      onPressed: _showLogoutDialog,
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              await controller.logout();
              Get.offAllNamed(AppRoutes.signIn);
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
