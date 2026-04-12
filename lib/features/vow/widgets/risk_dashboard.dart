import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/risk/risk_level.dart';
import '../../../shared/theme/app_theme.dart';

/// Top-of-screen risk card — the psychological core of the detail screen.
///
/// Receives AsyncValue<RiskSnapshot> because it owns the loading/error
/// skeleton. All color/label logic is derived from [RiskSnapshot].
class RiskDashboard extends StatelessWidget {
  final AsyncValue<RiskSnapshot> riskAsync;

  const RiskDashboard({super.key, required this.riskAsync});

  @override
  Widget build(BuildContext context) {
    return riskAsync.when(
      loading: () => _Shell(
        level: RiskLevel.safe,
        child: const SizedBox(
          height: 60,
          child: Center(
            child: CircularProgressIndicator(
                color: GundaColors.grey4, strokeWidth: 1.5),
          ),
        ),
      ),
      error: (_, __) => _Shell(
        level: RiskLevel.safe,
        child: const Text('리스크 데이터 없음',
            style: TextStyle(color: GundaColors.grey3, fontSize: 13)),
      ),
      data: (snap) => _Shell(
        level: snap.level,
        child: _Content(snap: snap),
      ),
    );
  }
}

class _Shell extends StatelessWidget {
  final RiskLevel level;
  final Widget child;

  const _Shell({required this.level, required this.child});

  @override
  Widget build(BuildContext context) {
    final (bg, border) = switch (level) {
      RiskLevel.safe => (GundaColors.greenBg, GundaColors.green),
      RiskLevel.warning => (
          const Color(0xFF2A2200),
          const Color(0xFFB8860B),
        ),
      RiskLevel.danger => (GundaColors.redBg, GundaColors.red),
    };
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border, width: 1.5),
      ),
      child: child,
    );
  }
}

class _Content extends StatelessWidget {
  final RiskSnapshot snap;

  const _Content({required this.snap});

  Color get _levelColor => switch (snap.level) {
        RiskLevel.safe => GundaColors.green,
        RiskLevel.warning => const Color(0xFFD4A017),
        RiskLevel.danger => GundaColors.red,
      };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _StatusBadge(level: snap.level, label: snap.statusLabel),
            const Spacer(),
            if (snap.remainingLabel != null)
              Text(
                snap.remainingLabel!,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: _levelColor,
                  letterSpacing: -0.3,
                ),
              )
            else
              Text(
                snap.hasLiveData ? '데이터 확인 중' : '검증 데이터 없음',
                style: const TextStyle(
                    fontSize: 13, color: GundaColors.grey3),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.arrow_forward,
                size: 11, color: GundaColors.red),
            const SizedBox(width: 6),
            Text(
              snap.consequenceLabel,
              style: const TextStyle(
                fontSize: 12,
                color: GundaColors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        if (!snap.hasLiveData) ...[
          const SizedBox(height: 8),
          const Text(
            '이 서약 유형은 실시간 감지가 지원되지 않습니다.',
            style: TextStyle(fontSize: 11, color: GundaColors.grey4),
          ),
        ],
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final RiskLevel level;
  final String label;

  const _StatusBadge({required this.level, required this.label});

  @override
  Widget build(BuildContext context) {
    final color = switch (level) {
      RiskLevel.safe => GundaColors.green,
      RiskLevel.warning => const Color(0xFFD4A017),
      RiskLevel.danger => GundaColors.red,
    };
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: color,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
