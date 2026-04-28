import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/quiet_hours_controller.dart';

class AlertsScreen extends GetView<QuietHoursController> {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('জেন্টেল অ্যালার্ট')),
      body: Obx(() {
        final alerts = controller.alerts;
        if (alerts.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(26),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: cs.primary.withValues(alpha: 0.06),
                      border: Border.all(
                        color: cs.outlineVariant.withValues(alpha: 0.35),
                      ),
                    ),
                    child: Icon(
                      Icons.notifications_off_rounded,
                      size: 56,
                      color: cs.primary.withValues(alpha: 0.52),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    'এখনও কোনও অ্যালার্ট নেই',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'পাড়ায় নতুন নীরবতার খবর এলেই আপনি এখানে দেখতে পারবেন।',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: const Color(0xFF5F7B90),
                          height: 1.45,
                        ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
          itemBuilder: (context, index) {
            final alert = alerts[index];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          height: 46,
                          width: 46,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              colors: <Color>[
                                const Color(0xFFFFF3D9),
                                const Color(0xFFFFEDD0),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Icon(
                            Icons.notifications_active_rounded,
                            color: cs.primary.withValues(alpha: 0.85),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            alert.title,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      alert.body,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            height: 1.4,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      DateFormat('dd MMM, h:mm a').format(alert.createdAt),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF5F7B90),
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemCount: alerts.length,
        );
      }),
    );
  }
}
