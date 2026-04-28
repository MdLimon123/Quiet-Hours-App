import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/quiet_hours_controller.dart';
import '../../models/quiet_reason.dart';

class CreateRequestScreen extends StatefulWidget {
  const CreateRequestScreen({super.key});

  @override
  State<CreateRequestScreen> createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends State<CreateRequestScreen> {
  final _noteController = TextEditingController();
  late QuietReasonType _selectedReason;
  int _duration = 30;

  @override
  void initState() {
    super.initState();
    _selectedReason = Get.arguments is QuietReasonType
        ? Get.arguments as QuietReasonType
        : QuietReasonType.study;
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<QuietHoursController>();
    const durationOptions = <int>[15, 30, 45, 60, 90];

    return Scaffold(
      appBar: AppBar(title: const Text('শান্ত সময় অনুরোধ')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'কারণ নির্বাচন করুন',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: QuietReasonType.values.map((reason) {
                        final isSelected = reason == _selectedReason;
                        return ChoiceChip(
                          label: Text(reason.label),
                          avatar: Icon(reason.icon, size: 18),
                          selected: isSelected,
                          onSelected: (_) {
                            setState(() => _selectedReason = reason);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'কত সময়ের জন্য?',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: durationOptions.map((duration) {
                        return ChoiceChip(
                          label: Text('$duration মিনিট'),
                          selected: _duration == duration,
                          onSelected: (_) {
                            setState(() => _duration = duration);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      controller: _noteController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: 'ছোট একটি নোট (ঐচ্ছিক)',
                        hintText: _selectedReason.shortHint,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 0,
              surfaceTintColor: Colors.transparent,
              color: const Color(0xFFEAF7FC),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
                side: BorderSide(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.12),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Notification preview',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'একজন প্রতিবেশী ${_selectedReason.label} কারণে $_duration মিনিট শব্দ কমাতে অনুরোধ করছেন।',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Obx(
              () => FilledButton(
                onPressed: controller.isSubmitting.value
                    ? null
                    : () => controller.createRequest(
                        reason: _selectedReason,
                        durationMinutes: _duration,
                        note: _noteController.text,
                      ),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                ),
                child: Text(
                  controller.isSubmitting.value
                      ? 'পাঠানো হচ্ছে...'
                      : 'শান্ত অনুরোধ পাঠান',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
