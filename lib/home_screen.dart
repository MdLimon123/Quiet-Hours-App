import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'app/controllers/quiet_hours_controller.dart';
import 'app/controllers/session_controller.dart';
import 'app/models/quiet_reason.dart';
import 'app/routes/app_routes.dart';
import 'app/theme/quiet_decorations.dart';

class HomeScreen extends GetView<QuietHoursController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Get.find<SessionController>();
    return Obx(() {
      final profile = session.profile.value;
      final activeRequest = controller.myActiveRequest.value;

      return SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 108),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: QuietDecorations.cardShadow(context),
                  gradient: const LinearGradient(
                    colors: <Color>[Color(0xFF0B2F45), Color(0xFF146C94)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'শান্ত সময়',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      profile == null
                          ? 'আপনার পাড়া সেটআপ হলেই আশেপাশের মানুষদের সাথে নরম, মানবিক সিগনাল শেয়ার করা যাবে।'
                          : '${profile.neighborhoodLabel} এলাকায় এখন ${controller.activeNeighborCount} টি নীরবতার অনুরোধ চলছে।',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withValues(alpha: .88),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _StatPill(
                      label: 'Community',
                      value: profile?.neighborhoodLabel ?? 'Not set',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (activeRequest != null)
                _ActiveRequestCard(
                  reasonLabel: activeRequest.reason.label,
                  note: activeRequest.note,
                  timeLabel:
                      'শেষ হবে ${DateFormat('h:mm a').format(activeRequest.endTime)}',
                  onEnd: controller.endActiveRequest,
                )
              else
                _QuickStartCard(
                  onCreate: () => Get.toNamed(AppRoutes.createRequest),
                ),
              const SizedBox(height: 28),
              const _SectionHeader(
                icon: Icons.bolt_rounded,
                title: 'দ্রুত অনুরোধ পাঠান',
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 132,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final reason = controller.quickReasons[index];
                    return _ReasonCard(reason: reason);
                  },
                  separatorBuilder: (context, _) => const SizedBox(width: 12),
                  itemCount: controller.quickReasons.length,
                ),
              ),
              const SizedBox(height: 28),
              const _SectionHeader(
                icon: Icons.people_outline_rounded,
                title: 'আশেপাশের লাইভ অনুরোধ',
              ),
              const SizedBox(height: 14),
              ...controller.requests
                  .take(4)
                  .map(
                    (request) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _NeighborRequestTile(
                        name: request.requesterName,
                        reason: request.reason.label,
                        note: request.note,
                        remaining: '${request.remainingMinutes} মিনিট বাকি',
                      ),
                    ),
                  ),
            ],
          ),
        ),
      );
    });
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final primary = cs.primary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(icon, size: 26, color: primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 3,
                width: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(99),
                  gradient: LinearGradient(
                    colors: <Color>[
                      primary,
                      primary.withValues(alpha: 0.35),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Colors.white.withValues(alpha: .72),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickStartCard extends StatelessWidget {
  const _QuickStartCard({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: <Widget>[
            Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: <Color>[
                    const Color(0xFFD8EFF7),
                    Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Icon(
                Icons.notifications_active_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'এখন কি শান্ত পরিবেশ দরকার?',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'একটি ভদ্র অনুরোধ পাঠালে আপনার পাড়ার মানুষ একটি gentle alert পাবেন।',
                  ),
                ],
              ),
            ),
            FilledButton.tonal(
              onPressed: onCreate,
              child: const Text('সংকেত দিন'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActiveRequestCard extends StatelessWidget {
  const _ActiveRequestCard({
    required this.reasonLabel,
    required this.note,
    required this.timeLabel,
    required this.onEnd,
  });

  final String reasonLabel;
  final String note;
  final String timeLabel;
  final VoidCallback onEnd;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFFFF7E6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: const BorderSide(color: Color(0xFFF0D099)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                const Icon(Icons.volume_off_rounded, color: Color(0xFF9A6500)),
                const SizedBox(width: 10),
                Text(
                  'আপনার শান্ত সময় চলছে',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(reasonLabel),
            const SizedBox(height: 6),
            Text(note.isEmpty ? 'কোনও অতিরিক্ত নোট নেই' : note),
            const SizedBox(height: 6),
            Text(timeLabel, style: const TextStyle(color: Color(0xFF9A6500))),
            const SizedBox(height: 16),
            OutlinedButton(onPressed: onEnd, child: const Text('সমাপ্ত করুন')),
          ],
        ),
      ),
    );
  }
}

class _ReasonCard extends StatelessWidget {
  const _ReasonCard({required this.reason});

  final QuietReasonType reason;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(22);
    final tint = Theme.of(context).colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Get.toNamed(
          AppRoutes.createRequest,
          arguments: reason,
        ),
        borderRadius: radius,
        child: Ink(
          width: 180,
          height: 132,
          decoration: QuietDecorations.softCard(context).copyWith(
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant.withValues(
                    alpha: 0.35,
                  ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: tint.withValues(alpha: 0.09),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(reason.icon, color: tint, size: 26),
                ),
                const Spacer(),
                Text(
                  reason.label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  reason.shortHint,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.black.withValues(alpha: 0.68),
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NeighborRequestTile extends StatelessWidget {
  const _NeighborRequestTile({
    required this.name,
    required this.reason,
    required this.note,
    required this.remaining,
  });

  final String name;
  final String reason;
  final String note;
  final String remaining;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              width: 5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    primary,
                    primary.withValues(alpha: 0.55),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 46,
                      width: 46,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: <Color>[
                            const Color(0xFFE5F3F8),
                            primary.withValues(alpha: 0.06),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Icon(Icons.waves_rounded, color: primary),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '$name • $reason',
                            style:
                                Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            note.isEmpty
                                ? 'ভদ্রভাবে কিছু সময় শান্ত পরিবেশ চাওয়া হয়েছে।'
                                : note,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            remaining,
                            style: TextStyle(
                              color: primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
