import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/quiet_hours_controller.dart';
import '../../models/quiet_reason.dart';

class RequestsScreen extends GetView<QuietHoursController> {
  const RequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('পাড়ার Quiet Requests')),
      body: Obx(() {
        final requests = controller.requests;
        if (requests.isEmpty) {
          return const Center(child: Text('এখন কোনও active request নেই।'));
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
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
                          backgroundColor: const Color(0xFFD9EDF7),
                          child: Icon(
                            request.reason.icon,
                            color: const Color(0xFF146C94),
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
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              Text(request.reason.label),
                            ],
                          ),
                        ),
                        Chip(label: Text('${request.remainingMinutes} min')),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      request.note.isEmpty
                          ? 'কোনও অতিরিক্ত বার্তা নেই।'
                          : request.note,
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemCount: requests.length,
        );
      }),
    );
  }
}
