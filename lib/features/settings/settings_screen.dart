import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/database/app_database.dart';
import '../../core/providers/database_provider.dart';
import '../../core/providers/user_provider.dart';
import '../../core/services/health_service.dart';
import '../../core/services/usage_stats_service.dart';
import '../../shared/theme/app_theme.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState
    extends ConsumerState<SettingsScreen> {
  bool? _usageStatsGranted;
  bool? _healthGranted;
  bool? _notificationGranted;

  @override
  void initState() {
    super.initState();
    _loadPermissions();
  }

  Future<void> _loadPermissions() async {
    final usage = await UsageStatsService.checkPermission();
    final health = await HealthService.hasStepsPermission();
    final notif =
        await Permission.notification.isGranted;
    if (mounted) {
      setState(() {
        _usageStatsGranted = usage;
        _healthGranted = health;
        _notificationGranted = notif;
      });
    }
  }

  Future<void> _showNicknameDialog(
      BuildContext context, String current) async {
    final ctrl = TextEditingController(text: current);
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: GundaColors.card,
        title: const Text('닉네임 변경',
            style: TextStyle(
                color: GundaColors.white,
                fontWeight: FontWeight.w700)),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          style:
              const TextStyle(color: GundaColors.white),
          cursorColor: GundaColors.green,
          decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: GundaColors.border),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: GundaColors.green),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('취소',
                style: TextStyle(
                    color: GundaColors.grey3)),
          ),
          TextButton(
            onPressed: () async {
              final db = ref.read(appDatabaseProvider);
              final user = await db.getFirstUser();
              if (user != null) {
                final nick = ctrl.text.trim().isEmpty
                    ? '사용자'
                    : ctrl.text.trim();
                await db.updateUser(UsersCompanion(
                  id: Value(user.id),
                  nickname: Value(nick),
                  updatedAt: Value(DateTime.now()),
                ));
              }
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('저장',
                style: TextStyle(
                    color: GundaColors.green,
                    fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
    ctrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider).value;

    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
      body: RefreshIndicator(
        onRefresh: _loadPermissions,
        child: ListView(
          children: [
            // ── 프로필 ─────────────────────────────────────
            const _SectionHeader('프로필'),
            ListTile(
              title: const Text('닉네임'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    user?.nickname ?? '사용자',
                    style: const TextStyle(
                        color: GundaColors.grey3,
                        fontSize: 14),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.edit_outlined,
                      size: 14, color: GundaColors.grey4),
                ],
              ),
              onTap: () => _showNicknameDialog(
                  context, user?.nickname ?? ''),
            ),

            // ── 카카오 계정 ────────────────────────────────
            const _SectionHeader('카카오 계정'),
            ListTile(
              leading: const _KakaoIcon(),
              title: const Text('카카오 로그인'),
              subtitle: const Text(
                  '카카오페이 결제를 위해 로그인이 필요합니다'),
              trailing: const Icon(
                  Icons.arrow_forward_ios, size: 14),
              onTap: () {
                // TODO: KakaoLogin (Sprint 3)
              },
            ),

            // ── 데이터 권한 ────────────────────────────────
            const _SectionHeader('데이터 접근 권한'),
            ListTile(
              leading:
                  const Icon(Icons.phone_android_outlined),
              title: const Text('앱 사용 시간 (UsageStats)'),
              subtitle: const Text('스크린 타임 · 배달 · 게임 서약 검증에 사용'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _PermissionDot(_usageStatsGranted),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_ios,
                      size: 14),
                ],
              ),
              onTap: () async {
                await UsageStatsService
                    .openUsageAccessSettings();
                await Future.delayed(
                    const Duration(milliseconds: 500));
                await _loadPermissions();
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.monitor_heart_outlined),
              title: const Text('Health Connect'),
              subtitle:
                  const Text('수면 · 걸음수 서약 검증에 사용'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _PermissionDot(_healthGranted),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_ios,
                      size: 14),
                ],
              ),
              onTap: () async {
                await HealthService.requestPermissions();
                await _loadPermissions();
              },
            ),
            ListTile(
              leading: const Icon(
                  Icons.notifications_outlined),
              title: const Text('알림 권한'),
              subtitle:
                  const Text('검증 결과 및 위반 알림에 사용'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _PermissionDot(_notificationGranted),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_ios,
                      size: 14),
                ],
              ),
              onTap: () async {
                final status =
                    await Permission.notification.request();
                if (status.isPermanentlyDenied) {
                  await openAppSettings();
                }
                await _loadPermissions();
              },
            ),

            // ── 앱 정보 ────────────────────────────────────
            const _SectionHeader('앱 정보'),
            const ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('버전'),
              trailing: Text('1.0.0',
                  style: TextStyle(color: Colors.grey)),
            ),
            ListTile(
              leading:
                  const Icon(Icons.privacy_tip_outlined),
              title: const Text('개인정보처리방침'),
              trailing: const Icon(
                  Icons.arrow_forward_ios, size: 14),
              onTap: () {},
            ),
            ListTile(
              leading:
                  const Icon(Icons.description_outlined),
              title: const Text('이용약관'),
              trailing: const Icon(
                  Icons.arrow_forward_ios, size: 14),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

// ── 권한 상태 인디케이터 ───────────────────────────────────

class _PermissionDot extends StatelessWidget {
  final bool? granted;
  const _PermissionDot(this.granted);

  @override
  Widget build(BuildContext context) {
    if (granted == null) {
      return const SizedBox(
        width: 10,
        height: 10,
        child: CircularProgressIndicator(strokeWidth: 1.5),
      );
    }
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: granted!
            ? const Color(0xFF1D9E75)
            : const Color(0xFFE24B4A),
      ),
    );
  }
}

// ── 섹션 헤더 ──────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.fromLTRB(16, 20, 16, 6),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _KakaoIcon extends StatelessWidget {
  const _KakaoIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFFFE812),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: Text(
          'K',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF3C1E1E),
          ),
        ),
      ),
    );
  }
}
