import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/quiet_hours_controller.dart';
import '../../models/quiet_reason.dart';

class RequestsScreen extends GetView<QuietHoursController> {
  const RequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('পাড়ার অনুরোধ')),
      body: Obx(() {
        final requests = controller.requests;
        if (requests.isEmpty) {
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
                      Icons.hourglass_empty_rounded,
                      size: 56,
                      color: cs.primary.withValues(alpha: 0.52),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    'এখন কোনও সক্রিয় অনুরোধ নেই',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'কারো নীরব সময় লাগলেই তাদের টিক দেখা যাবে এখানে।',
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
            final request = requests[index];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: cs.primary.withValues(alpha: 0.1),
                          child: Icon(
                            request.reason.icon,
                            color: cs.primary,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                request.requesterName,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                request.reason.label,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: const Color(0xFF5F7B90),
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Chip(
                          label: Text(
                            '${request.remainingMinutes} মিনিট',
                            style:
                                Theme.of(context).textTheme.labelLarge?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      request.note.isEmpty
                          ? 'কোনও অতিরিক্ত বার্তা নেই।'
                          : request.note,
                      style:
                          Theme.of(context).textTheme.bodyLarge?.copyWith(
                                height: 1.42,
                              ),
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemCount: requests.length,
        );
      }),
    );
  }
}
