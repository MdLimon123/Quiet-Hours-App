import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../controllers/session_controller.dart';
import '../../routes/app_routes.dart';

class SettingsScreen extends GetView<SessionController> {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('সেটিংস')),
      body: Obx(() {
        final profile = controller.profile.value;

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
          children: <Widget>[
            Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .primaryContainer
                              .withValues(alpha: 0.85),
                          child: Icon(
                            Icons.person_rounded,
                            size: 36,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'প্রোফাইল',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.3,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                profile?.name ?? 'নাম সেট করুন',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _InfoRow(
                      icon: Icons.place_outlined,
                      text:
                          'এলাকা: ${profile?.neighborhoodLabel ?? 'Not set'}',
                    ),
                    const SizedBox(height: 8),
                    _InfoRow(
                      icon: Icons.apartment_rounded,
                      text:
                          'ফ্ল্যাট: ${profile?.apartmentLabel.isEmpty ?? true ? 'N/A' : profile!.apartmentLabel}',
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.tonal(
                        onPressed: () =>
                            Get.toNamed(AppRoutes.onboarding),
                        child: const Text('প্রোফাইল আপডেট'),
                      ),
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
                child: FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (BuildContext context, AsyncSnapshot<PackageInfo> s) {
                    final String ver = s.hasData
                        ? '${s.data!.version} (${s.data!.buildNumber})'
                        : '…';
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'অ্যাপ সম্পর্কে',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          s.data?.appName ?? 'Quiet Hours',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'সংস্করণ: $ver',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 14),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'পাড়ার জন্য টিপস',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _TipLine(
                      icon: Icons.face_rounded,
                      text:
                          'প্রোফাইলে নাম ও এলাকা ঠিক রাখলে অন্যরা চিনতে পারবে।',
                    ),
                    const SizedBox(height: 12),
                    _TipLine(
                      icon: Icons.timer_outlined,
                      text:
                          'নিরব সময়ের অনুরোধ শেষ হলে বা দরকার না থাকলে আপডেট করে জানান।',
                    ),
                    const SizedBox(height: 12),
                    _TipLine(
                      icon: Icons.volunteer_activism_outlined,
                      text:
                          'জোরেশোরে নয়—পাশের ফ্ল্যাট ও বাড়িকে সম্মান করেই এই টুল ব্যবহার করুন।',
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
                    FilledButton.icon(
                      onPressed: _showLogoutDialog,
                      icon: const Icon(Icons.logout_rounded),
                      label: const Text('লগআউট'),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFC94A4A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('লগআউট'),
        content: const Text(
          'আপনি কি লগআউট করতে চান?',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('বাতিল'),
          ),
          FilledButton(
            onPressed: () async {
              Get.back();
              await controller.logout();
              Get.offAllNamed(AppRoutes.signIn);
            },
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFC94A4A),
            ),
            child: const Text('লগআউট'),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.85),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.35),
          ),
        ),
      ],
    );
  }
}

class _TipLine extends StatelessWidget {
  const _TipLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(
          icon,
          size: 22,
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.75),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.45),
          ),
        ),
      ],
    );
  }
}
