import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/models/behavioral_insight.dart';
import '../../../domain/models/contract_vow.dart';
import '../../../domain/models/date_range.dart';
import '../../../features/vow/providers/vow_detail_providers.dart';
import '../../../shared/models/enums.dart';
import '../../../shared/theme/app_theme.dart';

// ─────────────────────────────────────────────────────────
// Entry point — dispatches to card variant by status
// ─────────────────────────────────────────────────────────

class VowCard extends StatelessWidget {
  final ContractVow vow;
  const VowCard({super.key, required this.vow});

  @override
  Widget build(BuildContext context) {
    return switch (vow.status) {
      VowStatus.active => _ActiveCard(vow: vow),
      VowStatus.violated => _ViolatedCard(vow: vow),
      VowStatus.paused ||
      VowStatus.completed =>
        _DoneCard(vow: vow),
    };
  }
}

// ─────────────────────────────────────────────────────────
// Active vow card
// ─────────────────────────────────────────────────────────

class _ActiveCard extends ConsumerWidget {
  final ContractVow vow;
  const _ActiveCard({required this.vow});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final period = vow.terms.period;
    final insightAsync = ref.watch(
      behavioralInsightProvider(
          (vowId: vow.id, period: period)),
    );

    return GestureDetector(
      onTap: () => context.push('/home/vow/${vow.id}'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: GundaColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: GundaColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Row 1: icon + title/streak + status/dday ──
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TypeIcon(type: vow.terms.condition.type),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vow.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: GundaColors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      if (insightAsync.value != null)
                        Text(
                          insightAsync.value!.streakLabel,
                          style: const TextStyle(
                            fontSize: 11,
                            color: GundaColors.grey3,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _StatusChip(status: vow.status),
                    const SizedBox(height: 4),
                    Text(
                      'D-${period.daysLeft}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: GundaColors.grey2,
                      ),
                    ),
                  ],
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert,
                      color: GundaColors.grey4, size: 18),
                  color: GundaColors.card,
                  padding: EdgeInsets.zero,
                  onSelected: (action) async {
                    if (action == 'pause') {
                      await ref.read(pauseVowProvider)(vow.id);
                    } else if (action == 'detail') {
                      if (context.mounted) {
                        context.push('/home/vow/${vow.id}');
                      }
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                      value: 'pause',
                      child: Text('일시 중지',
                          style: TextStyle(
                              color: GundaColors.white, fontSize: 14)),
                    ),
                    PopupMenuItem(
                      value: 'detail',
                      child: Text('상세 보기',
                          style: TextStyle(
                              color: GundaColors.white, fontSize: 14)),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ── Row 2: progress bar + day count ───────────
            _ProgressRow(period: period),

            const SizedBox(height: 10),

            // ── Row 3: penalty + enforcer ─────────────────
            Row(
              children: [
                Text(
                  vow.terms.penalty.consequenceLabel,
                  style: const TextStyle(
                    fontSize: 11,
                    color: GundaColors.grey3,
                  ),
                ),
                if (!vow.enforcer.isUnknown) ...[
                  const Spacer(),
                  Text(
                    vow.enforcer.displayName,
                    style: const TextStyle(
                      fontSize: 11,
                      color: GundaColors.grey3,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Violated vow card (fold animation)
// ─────────────────────────────────────────────────────────

class _ViolatedCard extends ConsumerStatefulWidget {
  final ContractVow vow;
  const _ViolatedCard({required this.vow});

  @override
  ConsumerState<_ViolatedCard> createState() => _ViolatedCardState();
}

class _ViolatedCardState extends ConsumerState<_ViolatedCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final vow = widget.vow;
    final insightAsync = ref.watch(
      behavioralInsightProvider(
          (vowId: vow.id, period: vow.terms.period)),
    );
    final violationCount = vow.stats.violationCount;

    final borderColor = _expanded
        ? GundaColors.red.withAlpha(80)
        : GundaColors.border;
    final bgColor = _expanded ? GundaColors.redBg : GundaColors.card;

    return GestureDetector(
      onTap: _expanded
          ? () => context.push('/home/vow/${vow.id}')
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: _expanded
              ? _ExpandedViolated(
                  vow: vow,
                  violationCount: violationCount,
                  insightAsync: insightAsync,
                  onCollapse: () => setState(() => _expanded = false),
                )
              : _CollapsedViolated(
                  vow: vow,
                  violationCount: violationCount,
                  onExpand: () => setState(() => _expanded = true),
                ),
        ),
      ),
    );
  }
}

class _CollapsedViolated extends StatelessWidget {
  final ContractVow vow;
  final int violationCount;
  final VoidCallback onExpand;

  const _CollapsedViolated({
    required this.vow,
    required this.violationCount,
    required this.onExpand,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.warning_rounded,
            size: 15, color: GundaColors.red),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            '${vow.title}  ·  위반 $violationCount건',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: GundaColors.grey2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        IconButton(
          onPressed: onExpand,
          icon: const Icon(Icons.keyboard_arrow_down,
              size: 18, color: GundaColors.grey3),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }
}

class _ExpandedViolated extends StatelessWidget {
  final ContractVow vow;
  final int violationCount;
  final AsyncValue<BehavioralInsight> insightAsync;
  final VoidCallback onCollapse;

  const _ExpandedViolated({
    required this.vow,
    required this.violationCount,
    required this.insightAsync,
    required this.onCollapse,
  });

  @override
  Widget build(BuildContext context) {
    final lastViolationLabel = insightAsync.value?.lastViolationLabel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row
        Row(
          children: [
            _TypeIcon(type: vow.terms.condition.type),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                vow.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: GundaColors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            _StatusChip(status: vow.status),
          ],
        ),
        const SizedBox(height: 10),
        Divider(color: GundaColors.red.withAlpha(60), height: 1),
        const SizedBox(height: 10),

        // Violation summary
        Text(
          [
            lastViolationLabel,
            '총 $violationCount건',
          ].nonNulls.join('  ·  '),
          style: const TextStyle(
            fontSize: 12,
            color: GundaColors.grey3,
          ),
        ),
        const SizedBox(height: 10),

        // Footer row
        Row(
          children: [
            Text(
              vow.terms.penalty.consequenceLabel,
              style: const TextStyle(
                  fontSize: 11, color: GundaColors.grey3),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () => context.push('/home/vow/${vow.id}'),
              child: const Text(
                '상세 보기',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: GundaColors.red,
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: onCollapse,
              child: const Icon(Icons.keyboard_arrow_up,
                  size: 18, color: GundaColors.grey3),
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────
// Completed / Paused card (compact single row)
// ─────────────────────────────────────────────────────────

class _DoneCard extends StatelessWidget {
  final ContractVow vow;
  const _DoneCard({required this.vow});

  @override
  Widget build(BuildContext context) {
    final period = vow.terms.period;
    final isPaused = vow.isPaused;

    return GestureDetector(
      onTap: () => context.push('/home/vow/${vow.id}'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isPaused ? GundaColors.grey5 : GundaColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: GundaColors.border),
        ),
        child: Row(
          children: [
            _TypeIcon(type: vow.terms.condition.type, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                vow.title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: GundaColors.grey2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            _StatusChip(status: vow.status),
            const SizedBox(width: 8),
            Text(
              '${period.elapsedDays}/${period.totalDays}일',
              style: const TextStyle(
                fontSize: 11,
                color: GundaColors.grey4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Shared sub-widgets
// ─────────────────────────────────────────────────────────

class _TypeIcon extends StatelessWidget {
  final PledgeType type;
  final double size;
  const _TypeIcon({required this.type, this.size = 40});

  @override
  Widget build(BuildContext context) {
    final icon = switch (type) {
      PledgeType.screenTime => Icons.phone_android,
      PledgeType.sleep => Icons.bedtime_outlined,
      PledgeType.steps => Icons.directions_walk,
      PledgeType.exercise => Icons.fitness_center,
      PledgeType.delivery => Icons.delivery_dining,
      PledgeType.game => Icons.sports_esports_outlined,
      PledgeType.custom => Icons.edit_outlined,
    };
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: GundaColors.grey5,
        borderRadius: BorderRadius.circular(size * 0.28),
      ),
      child: Icon(icon, color: GundaColors.grey2, size: size * 0.5),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final VowStatus status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      VowStatus.active => ('진행 중', GundaColors.green),
      VowStatus.completed => ('완료', GundaColors.green),
      VowStatus.violated => ('위반', GundaColors.red),
      VowStatus.paused => ('일시 중지', GundaColors.grey3),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  final ContractDateRange period;
  const _ProgressRow({required this.period});

  @override
  Widget build(BuildContext context) {
    final ratio = period.progressRatio.clamp(0.0, 1.0);

    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: Stack(
              children: [
                Container(
                    height: 5, color: GundaColors.grey5),
                FractionallySizedBox(
                  widthFactor: ratio,
                  child: Container(
                      height: 5, color: GundaColors.green),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          '${period.elapsedDays}/${period.totalDays}일',
          style: const TextStyle(
            fontSize: 11,
            color: GundaColors.grey3,
          ),
        ),
      ],
    );
  }
}
