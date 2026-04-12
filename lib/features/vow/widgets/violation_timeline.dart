import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../domain/models/behavioral_insight.dart';
import '../../../domain/models/domain_violation.dart';
import '../../../domain/models/enforcer.dart';
import '../../../shared/models/enums.dart';
import '../../../shared/theme/app_theme.dart';

/// Violation event timeline with behavioral insight header.
///
/// Renders in two layers:
///   1. [_InsightHeader] — streak pressure + trend signal
///   2. [_ViolationCard] list — one card per violation event
///
/// Each layer receives only domain objects. No string parsing,
/// no raw DB access.
class ViolationTimeline extends StatelessWidget {
  final AsyncValue<List<DomainViolation>> violationsAsync;
  final AsyncValue<BehavioralInsight> insightAsync;
  final Enforcer enforcer;

  const ViolationTimeline({
    super.key,
    required this.violationsAsync,
    required this.insightAsync,
    required this.enforcer,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Behavioral insight header ──────────────────
        _InsightHeader(insightAsync: insightAsync),
        const SizedBox(height: 12),

        // ── Violation event list ───────────────────────
        violationsAsync.when(
          loading: () => const SizedBox(
            height: 60,
            child: Center(
              child: CircularProgressIndicator(
                  color: GundaColors.grey4, strokeWidth: 1.5),
            ),
          ),
          error: (e, _) => Text('오류: $e',
              style: const TextStyle(
                  color: GundaColors.grey2, fontSize: 12)),
          data: (list) => list.isEmpty
              ? const _NoViolations()
              : Column(
                  children: list
                      .map((v) => _ViolationCard(
                              violation: v, enforcer: enforcer))
                      .toList(),
                ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────
// Behavioral Insight Header
// ─────────────────────────────────────────────────────────

class _InsightHeader extends StatelessWidget {
  final AsyncValue<BehavioralInsight> insightAsync;

  const _InsightHeader({required this.insightAsync});

  @override
  Widget build(BuildContext context) {
    return insightAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (insight) => _InsightCard(insight: insight),
    );
  }
}

class _InsightCard extends StatelessWidget {
  final BehavioralInsight insight;

  const _InsightCard({required this.insight});

  @override
  Widget build(BuildContext context) {
    // Color scheme shifts to red when streak is 0 (violated today)
    final isClean = insight.currentStreakDays > 0;
    final streakColor =
        isClean ? GundaColors.green : GundaColors.red;
    final cardBg =
        isClean ? GundaColors.greenBg : GundaColors.redBg;
    final cardBorder = isClean
        ? GundaColors.green.withAlpha(60)
        : GundaColors.red.withAlpha(60);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: cardBorder),
      ),
      child: Row(
        children: [
          // Streak block
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      _streakEmoji(insight.currentStreakDays),
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      insight.streakLabel,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: streakColor,
                      ),
                    ),
                  ],
                ),
                if (insight.lastViolationLabel != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    insight.lastViolationLabel!,
                    style: const TextStyle(
                        fontSize: 11, color: GundaColors.grey3),
                  ),
                ],
              ],
            ),
          ),
          // Total violations counter
          if (insight.hasBeenViolated)
            _ViolationCount(count: insight.totalViolations),
          // Trend indicator (future-proofed)
          if (insight.trend != ViolationTrend.unknown) ...[
            const SizedBox(width: 10),
            _TrendBadge(trend: insight.trend),
          ],
        ],
      ),
    );
  }

  String _streakEmoji(int days) {
    if (days == 0) return '🚨';
    if (days < 3) return '🌱';
    if (days < 7) return '🔥';
    if (days < 30) return '⚡';
    return '💎';
  }
}

class _ViolationCount extends StatelessWidget {
  final int count;
  const _ViolationCount({required this.count});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '$count',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: GundaColors.red,
          ),
        ),
        const Text(
          '위반',
          style: TextStyle(fontSize: 10, color: GundaColors.grey3),
        ),
      ],
    );
  }
}

class _TrendBadge extends StatelessWidget {
  final ViolationTrend trend;
  const _TrendBadge({required this.trend});

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (trend) {
      ViolationTrend.increasing => (Icons.trending_up, GundaColors.red),
      ViolationTrend.decreasing =>
        (Icons.trending_down, GundaColors.green),
      ViolationTrend.stable => (Icons.trending_flat, GundaColors.grey3),
      ViolationTrend.unknown => (Icons.remove, GundaColors.grey4),
    };
    return Icon(icon, size: 18, color: color);
  }
}

// ─────────────────────────────────────────────────────────
// Empty state
// ─────────────────────────────────────────────────────────

class _NoViolations extends StatelessWidget {
  const _NoViolations();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: GundaColors.card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: GundaColors.border),
      ),
      child: const Center(
        child: Text(
          '아직 위반 기록이 없습니다.',
          style: TextStyle(fontSize: 13, color: GundaColors.grey3),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Violation event card
// ─────────────────────────────────────────────────────────

class _ViolationCard extends StatelessWidget {
  final DomainViolation violation;
  final Enforcer enforcer;

  const _ViolationCard({
    required this.violation,
    required this.enforcer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color:
            violation.isPending ? GundaColors.redBg : GundaColors.card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: violation.isPending
              ? GundaColors.red.withAlpha(80)
              : GundaColors.border,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Icon(
              violation.isPaid
                  ? Icons.check_circle_outline
                  : Icons.warning_rounded,
              size: 16,
              color: violation.isPaid
                  ? GundaColors.grey3
                  : GundaColors.red,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${violation.violatedAt.month}월 ${violation.violatedAt.day}일 — 계약 위반',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: violation.isPending
                            ? GundaColors.white
                            : GundaColors.grey2,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      violation.penalty.formatted,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: violation.isPaid
                            ? GundaColors.grey3
                            : GundaColors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                _PaymentPill(status: violation.paymentStatus),
                if (violation.isPending) ...[
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () =>
                        _launchKakaoPay(violation, enforcer),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '카카오페이로 납부',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: GundaColors.red,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward,
                            size: 12, color: GundaColors.red),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> _launchKakaoPay(
    DomainViolation violation,
    Enforcer enforcer,
  ) async {
    // Encode the violationId so the gunda://kakaopay callback
    // can identify which row to mark as 'processing'.
    final kakaoUri = Uri(
      scheme: 'kakaopay',
      host: 'send',
      queryParameters: {
        if (enforcer.hasPhone) 'receiver': enforcer.phone,
        'amount': violation.penalty.amountKrw.toString(),
        'memo': '건다서약위반',
        'redirect_url':
            'gunda://kakaopay?violationId=${violation.id}',
      },
    );

    if (await canLaunchUrl(kakaoUri)) {
      await launchUrl(kakaoUri);
    } else {
      // KakaoPay not installed — open Play Store
      await launchUrl(
        Uri.parse(
            'market://details?id=com.kakaopay.app'),
        mode: LaunchMode.externalApplication,
      );
    }
  }
}

// ─────────────────────────────────────────────────────────
// Payment status pill
// ─────────────────────────────────────────────────────────

class _PaymentPill extends StatelessWidget {
  final PaymentStatus status;

  const _PaymentPill({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      PaymentStatus.completed => ('납부 완료', GundaColors.grey3),
      PaymentStatus.processing => ('처리 중', const Color(0xFFD4A017)),
      PaymentStatus.failed => ('납부 실패', GundaColors.red),
      PaymentStatus.pending => ('납부 대기', GundaColors.red),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withAlpha(60)),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color)),
    );
  }
}
