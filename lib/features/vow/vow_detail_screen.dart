import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/models/contract_vow.dart';
import '../../shared/models/enums.dart';
import '../../shared/theme/app_theme.dart';
import 'providers/vow_detail_providers.dart';
import 'widgets/contract_terms_section.dart';
import 'widgets/dday_progress.dart';
import 'widgets/enforcer_section.dart';
import 'widgets/primary_cta.dart';
import 'widgets/risk_dashboard.dart';
import 'widgets/violation_timeline.dart';

// ─────────────────────────────────────────────────────────
// Screen — pure orchestrator
//
// Responsibility: wire providers to widgets.
// Zero business logic. Zero string parsing. Zero math.
// ─────────────────────────────────────────────────────────

class VowDetailScreen extends ConsumerWidget {
  final int vowId;
  const VowDetailScreen({super.key, required this.vowId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vowAsync = ref.watch(contractVowProvider(vowId));

    return vowAsync.when(
      loading: () => const Scaffold(
        backgroundColor: GundaColors.bg,
        body: Center(
          child: CircularProgressIndicator(
              color: GundaColors.grey3, strokeWidth: 1.5),
        ),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: GundaColors.bg,
        body: Center(
          child: Text('오류: $e',
              style: const TextStyle(color: GundaColors.grey2)),
        ),
      ),
      data: (vow) {
        if (vow == null) {
          return const Scaffold(
            backgroundColor: GundaColors.bg,
            body: Center(
              child: Text('서약을 찾을 수 없습니다',
                  style: TextStyle(color: GundaColors.grey2)),
            ),
          );
        }
        return _VowDetailScaffold(vow: vow, vowId: vowId);
      },
    );
  }
}

// ─────────────────────────────────────────────────────────
// Scaffold — composes feature widgets
// ─────────────────────────────────────────────────────────

class _VowDetailScaffold extends ConsumerWidget {
  final ContractVow vow;
  final int vowId;

  const _VowDetailScaffold({required this.vow, required this.vowId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final violationsAsync =
        ref.watch(domainViolationsProvider(vowId));
    final riskAsync =
        ref.watch(riskSnapshotProvider(vow.terms));
    final insightAsync = ref.watch(
      behavioralInsightProvider(
          (vowId: vowId, period: vow.terms.period)),
    );

    return Scaffold(
      backgroundColor: GundaColors.bg,
      appBar: AppBar(
        backgroundColor: GundaColors.bg,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              size: 18, color: GundaColors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          vow.title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: GundaColors.white,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          _StatusChip(status: vow.status),
          const SizedBox(width: 4),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert,
                color: GundaColors.grey2, size: 20),
            color: GundaColors.card,
            onSelected: (action) =>
                _onMenuAction(context, ref, action),
            itemBuilder: (_) => [
              if (vow.status == VowStatus.paused)
                const PopupMenuItem(
                  value: 'resume',
                  child: Text('재개',
                      style: TextStyle(
                          color: GundaColors.white, fontSize: 14)),
                )
              else
                const PopupMenuItem(
                  value: 'pause',
                  child: Text('일시 중지',
                      style: TextStyle(
                          color: GundaColors.white, fontSize: 14)),
                ),
              const PopupMenuItem(
                value: 'delete',
                child: Text('삭제',
                    style: TextStyle(
                        color: GundaColors.red, fontSize: 14)),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        children: [
          RiskDashboard(riskAsync: riskAsync),
          const SizedBox(height: 12),
          DDayProgress(period: vow.terms.period),
          const SizedBox(height: 12),
          EnforcerSection(
              enforcer: vow.enforcer,
              penalty: vow.terms.penalty),
          const SizedBox(height: 12),
          ContractTermsSection(terms: vow.terms),
          const SizedBox(height: 20),
          const Text(
            '위반 기록',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: GundaColors.grey3,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 10),
          ViolationTimeline(
            violationsAsync: violationsAsync,
            insightAsync: insightAsync,
            enforcer: vow.enforcer,
          ),
          const SizedBox(height: 100),
        ],
      ),
      bottomNavigationBar: PrimaryCTA(status: vow.status),
    );
  }

  Future<void> _onMenuAction(
      BuildContext context, WidgetRef ref, String action) async {
    if (action == 'pause') {
      await ref.read(pauseVowProvider)(vow.id);
      if (context.mounted) context.pop();
      return;
    }
    if (action == 'resume') {
      await ref.read(resumeVowProvider)(vow.id);
      return;
    }
    if (action == 'delete') {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: GundaColors.card,
          title: const Text(
            '서약을 삭제합니다',
            style: TextStyle(
                color: GundaColors.white,
                fontWeight: FontWeight.w700),
          ),
          content: const Text(
            '위반 기록과 납부 내역을 포함한 모든 데이터가\n영구 삭제됩니다. 되돌릴 수 없습니다.',
            style: TextStyle(
                color: GundaColors.grey1, fontSize: 14, height: 1.6),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('취소',
                  style: TextStyle(color: GundaColors.grey3)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('삭제',
                  style: TextStyle(color: GundaColors.red)),
            ),
          ],
        ),
      );
      if (confirmed == true) {
        await ref.read(deleteVowProvider)(vow.id);
        if (context.mounted) context.go('/home');
      }
    }
  }
}

// ─────────────────────────────────────────────────────────
// Status chip — display only
// ─────────────────────────────────────────────────────────

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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color)),
    );
  }
}
