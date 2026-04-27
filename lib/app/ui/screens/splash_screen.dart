import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/session_controller.dart';
import '../../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _bootstrapAndRoute();
    });
  }

  Future<void> _bootstrapAndRoute() async {
    final session = Get.find<SessionController>();
    
    // Check if user is already authenticated
    final user = session.getCurrentUser();
    
    if (user == null) {
      // No authenticated user, go to sign in
      Get.offAllNamed(AppRoutes.signIn);
      return;
    }
    
    // User is authenticated, bootstrap session
    final hasProfile = await session.bootstrap();
    if (!mounted || session.bootstrapError.value != null) {
      return;
    }
    Get.offAllNamed(hasProfile ? AppRoutes.shell : AppRoutes.onboarding);
  }

  @override
  Widget build(BuildContext context) {
    final session = Get.find<SessionController>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              Color(0xFF0B2B40),
              Color(0xFF146C94),
              Color(0xFFD9EDF7),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Obx(
            () => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    height: 88,
                    width: 88,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .14),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.nights_stay_rounded,
                      color: Colors.white,
                      size: 42,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Quiet Hours',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'শান্ত সময়, সৌজন্যের সাথে',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white.withValues(alpha: .84),
                    ),
                  ),
                  const SizedBox(height: 28),
                  if (session.bootstrapError.value == null) ...<Widget>[
                    const CircularProgressIndicator(color: Colors.white),
                    const SizedBox(height: 12),
                    Text(
                      session.firebaseModeLabel.value.isEmpty
                          ? 'Session তৈরি হচ্ছে...'
                          : session.firebaseModeLabel.value,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: .82),
                      ),
                    ),
                  ] else ...<Widget>[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .14),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Firebase sign-in শুরু হয়নি',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            session.bootstrapError.value!,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Colors.white.withValues(alpha: .9),
                                ),
                          ),
                          const SizedBox(height: 16),
                          FilledButton(
                            onPressed: () async {
                              final hasProfile = await session.retryBootstrap();
                              if (!mounted ||
                                  session.bootstrapError.value != null) {
                                return;
                              }
                              Get.offAllNamed(
                                hasProfile
                                    ? AppRoutes.shell
                                    : AppRoutes.onboarding,
                              );
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF123247),
                            ),
                            child: const Text('আবার চেষ্টা করুন'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
