import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/user_provider.dart';
import '../../domain/models/contract_vow.dart';
import '../../features/vow/providers/vow_detail_providers.dart';
import '../../shared/theme/app_theme.dart';
import 'widgets/vow_card.dart';

final homeVowsProvider = StreamProvider<List<ContractVow>>((ref) {
  return ref.watch(vowRepositoryProvider).watchAllVows(1);
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vowsAsync = ref.watch(homeVowsProvider);
    final user = ref.watch(currentUserProvider).value;
    final showNick = user != null && user.nickname != '사용자';

    return Scaffold(
      backgroundColor: GundaColors.bg,
      appBar: AppBar(
        backgroundColor: GundaColors.bg,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '건다',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: GundaColors.white,
                letterSpacing: -0.5,
              ),
            ),
            if (showNick)
              Text(
                user.nickname,
                style: const TextStyle(
                  fontSize: 11,
                  color: GundaColors.grey3,
                  fontWeight: FontWeight.w400,
                ),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined,
                color: GundaColors.grey3, size: 20),
            onPressed: () => context.push('/home/settings'),
          ),
        ],
      ),
      body: vowsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(
              color: GundaColors.grey4, strokeWidth: 1.5),
        ),
        error: (e, _) => Center(
          child: Text('오류: $e',
              style: const TextStyle(color: GundaColors.grey2)),
        ),
        data: (list) => list.isEmpty
            ? _EmptyState(
                onTap: () => context.push('/home/vow/create'))
            : _VowList(vows: list),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/home/vow/create'),
        backgroundColor: GundaColors.white,
        foregroundColor: GundaColors.bg,
        icon: const Icon(Icons.add, size: 18),
        label: const Text(
          '서약 만들기',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Empty state
// ─────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final VoidCallback onTap;
  const _EmptyState({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.handshake_outlined,
                size: 64, color: GundaColors.grey4),
            const SizedBox(height: 20),
            const Text(
              '첫 번째 서약을 만들어보세요',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: GundaColors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '스크린 타임 · 수면 · 걸음수 목표를\n설정하고 스스로와 약속하세요.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: GundaColors.grey3),
            ),
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: onTap,
              icon: const Icon(Icons.add, size: 16),
              label: const Text('서약 만들기'),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Vow list — sorted by section
// ─────────────────────────────────────────────────────────

class _VowList extends StatelessWidget {
  final List<ContractVow> vows;
  const _VowList({required this.vows});

  @override
  Widget build(BuildContext context) {
    final active =
        vows.where((v) => v.isActive).toList();
    final violated =
        vows.where((v) => v.isViolated).toList();
    final paused =
        vows.where((v) => v.isPaused).toList();
    final completed =
        vows.where((v) => v.isCompleted).toList();

    return CustomScrollView(
      slivers: [
        if (active.isNotEmpty) ...[
          _sectionHeader('진행 중인 서약 (${active.length})'),
          _vowSliver(active),
        ],
        if (violated.isNotEmpty) ...[
          _sectionHeader('위반'),
          _vowSliver(violated),
        ],
        if (paused.isNotEmpty) ...[
          _sectionHeader('일시 중지'),
          _vowSliver(paused),
        ],
        if (completed.isNotEmpty) ...[
          _sectionHeader('완료'),
          _vowSliver(completed),
        ],
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  SliverToBoxAdapter _sectionHeader(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: GundaColors.grey3,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }

  SliverPadding _vowSliver(List<ContractVow> list) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList.separated(
        itemCount: list.length,
        itemBuilder: (_, i) => VowCard(vow: list[i]),
        separatorBuilder: (_, _) => const SizedBox(height: 10),
      ),
    );
  }
}
