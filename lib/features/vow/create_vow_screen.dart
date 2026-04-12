import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/database/app_database.dart';
import '../../core/providers/database_provider.dart';
import '../../core/services/usage_stats_service.dart';
import '../../shared/models/enums.dart';
import '../../shared/models/pledge_condition.dart';
import '../../shared/theme/app_theme.dart';

const _deliveryApps = [
  (package: 'com.woowa.client.android', name: '배달의민족'),
  (package: 'com.coupang.mobile.eats', name: '쿠팡이츠'),
  (package: 'kr.co.yogiyo.rokittech', name: '요기요'),
];

// 디지털 디톡스 프리셋 앱
const _kPresetScreenTimeApps = [
  (
    package: 'com.google.android.youtube',
    name: '유튜브',
    icon: Icons.play_circle_outline
  ),
  (
    package: 'com.instagram.android',
    name: '인스타그램',
    icon: Icons.camera_alt_outlined
  ),
  (
    package: 'com.zhiliaoapp.musically',
    name: '틱톡',
    icon: Icons.music_note_outlined
  ),
  (
    package: 'com.twitter.android',
    name: 'X (트위터)',
    icon: Icons.alternate_email
  ),
];

String _fmtDate(DateTime d) =>
    '${d.year}.${d.month.toString().padLeft(2, '0')}.${d.day.toString().padLeft(2, '0')}';

String _fmtHours(double h) {
  if (h == 0) return '완전 금지';
  final hrs = h.floor();
  final mins = ((h - hrs) * 60).round();
  if (hrs == 0) return '$mins분 이하';
  if (mins == 0) return '$hrs시간 이하';
  return '$hrs시간 ${mins}분 이하';
}

String _fmtMoney(int v) => '${v.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    )}원';

// ─────────────────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────────────────

class CreateVowScreen extends ConsumerStatefulWidget {
  const CreateVowScreen({super.key});

  @override
  ConsumerState<CreateVowScreen> createState() =>
      _CreateVowScreenState();
}

class _CreateVowScreenState
    extends ConsumerState<CreateVowScreen> {
  final _titleCtrl = TextEditingController();
  final _recipientCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  int _step = 0;
  PledgeType _type = PledgeType.screenTime;
  late PledgeCondition _condition;
  int _durationDays = 7;
  int _penalty = 10000;
  bool _saving = false;

  // ScreenTime
  List<String> _selectedScreenTimePackages = [];
  List<InstalledApp>? _installedUserApps;
  bool _loadingUserApps = false;
  bool _hasDurationLimit = true;
  bool _hasWindowLimit = false;
  int _windowStartHour = 23;
  int _windowEndHour = 7;

  // Game
  List<String> _selectedGamePackages = [];
  List<InstalledApp>? _installedGames;
  bool _loadingGames = false;

  // Delivery
  bool _deliveryFullBan = true;
  int _deliveryMaxCount = 1;

  // Step 3 – Recipient
  String _relationship = '';

  // Step 4 consent
  bool _hasConsented = false;

  static const _stepLabels = [
    '제1조. 목적',
    '제2조. 조건',
    '제3조. 패널티',
    '제4조. 집행자',
    '제5조. 서명',
  ];

  @override
  void initState() {
    super.initState();
    _condition = PledgeCondition.defaultFor(_type);
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _recipientCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _onTypeChanged(PledgeType t) {
    setState(() {
      _type = t;
      _condition = PledgeCondition.defaultFor(t);
      if (t == PledgeType.game && _installedGames == null) _loadGames();
      if (t == PledgeType.screenTime && _installedUserApps == null) {
        _loadUserApps();
      }
    });
  }

  Future<void> _loadUserApps() async {
    setState(() => _loadingUserApps = true);
    final apps = await UsageStatsService.getInstalledUserApps();
    if (mounted) {
      setState(() {
        // exclude preset packages from the "other apps" list
        final presetPkgs =
            _kPresetScreenTimeApps.map((a) => a.package).toSet();
        _installedUserApps =
            apps.where((a) => !presetPkgs.contains(a.packageName)).toList();
        _loadingUserApps = false;
      });
    }
  }

  Future<void> _loadGames() async {
    setState(() => _loadingGames = true);
    final games = await UsageStatsService.getInstalledGames();
    if (mounted) {
      setState(() {
        _installedGames = games;
        _loadingGames = false;
      });
    }
  }

  String _generateTitle() {
    switch (_type) {
      case PledgeType.screenTime:
        final pkgs = _selectedScreenTimePackages;
        final prefix = pkgs.isEmpty
            ? '스마트폰'
            : pkgs.map((pkg) {
                final preset = _kPresetScreenTimeApps
                    .where((a) => a.package == pkg)
                    .map((a) => a.name)
                    .firstOrNull;
                if (preset != null) return preset;
                return (_installedUserApps ?? [])
                    .where((a) => a.packageName == pkg)
                    .map((a) => a.appName)
                    .firstOrNull ?? pkg.split('.').last;
              }).take(2).join('·');

        final durPart = _hasDurationLimit
            ? (_condition.targetValue == 0
                ? '완전 차단'
                : _fmtHours(_condition.targetValue))
            : null;
        final winPart = _hasWindowLimit
            ? '${_windowStartHour}시~${_windowEndHour}시 금지'
            : null;

        if (durPart == '완전 차단') return '$prefix 완전 차단';
        if (durPart != null && winPart != null) {
          return '$prefix $durPart + $winPart';
        }
        if (winPart != null) return '$prefix $winPart';
        return '$prefix $durPart';

      case PledgeType.delivery:
        return _deliveryFullBan
            ? '배달음식 완전 금지'
            : '배달음식 하루 $_deliveryMaxCount회 이하';

      case PledgeType.steps:
        return '하루 ${_condition.toDisplayString()} 달성';

      case PledgeType.sleep:
        return '${_condition.toDisplayString()} 수면';

      case PledgeType.exercise:
        return '매일 ${_condition.toDisplayString()} 운동';

      case PledgeType.game:
        return _condition.targetValue == 0
            ? '게임 완전 차단'
            : '게임 하루 ${_condition.targetValue.toInt()}분 이하';

      case PledgeType.custom:
        return _titleCtrl.text.trim();
    }
  }

  bool get _isStrict {
    if (_type == PledgeType.screenTime) {
      return _hasDurationLimit && _condition.targetValue == 0;
    }
    if (_type == PledgeType.delivery) return _deliveryFullBan;
    if (_type == PledgeType.game) return _condition.targetValue == 0;
    return false;
  }

  String _buildContractSentence() {
    switch (_type) {
      case PledgeType.screenTime:
        final pkgs = _selectedScreenTimePackages;
        final target = pkgs.isEmpty
            ? '스마트폰'
            : pkgs.map((pkg) {
                final preset = _kPresetScreenTimeApps
                    .where((a) => a.package == pkg)
                    .map((a) => a.name)
                    .firstOrNull;
                if (preset != null) return preset;
                return (_installedUserApps ?? [])
                    .where((a) => a.packageName == pkg)
                    .map((a) => a.appName)
                    .firstOrNull ?? pkg.split('.').last;
              }).take(2).join('·');
        final dur = _hasDurationLimit
            ? (_condition.targetValue == 0
                ? '완전히 차단한다'
                : '하루 ${_fmtHours(_condition.targetValue)}으로 제한한다')
            : null;
        final win = _hasWindowLimit
            ? '${_windowStartHour}시~${_windowEndHour}시에 사용하지 않는다'
            : null;
        if (dur == '완전히 차단한다') return '나는 $target을\n완전히 차단한다.';
        if (dur != null && win != null) {
          return '나는 $target을\n$dur.\n또한 $win.';
        }
        if (win != null) return '나는 $target을\n$win.';
        if (dur != null) return '나는 $target을\n$dur.';
        return '나는 $target을\n제한한다.';
      case PledgeType.delivery:
        return _deliveryFullBan
            ? '나는 배달앱을\n완전히 금지한다.'
            : '나는 배달앱 주문을\n하루 $_deliveryMaxCount회로 제한한다.';
      case PledgeType.game:
        return _condition.targetValue == 0
            ? '나는 게임을\n완전히 차단한다.'
            : '나는 게임을\n하루 ${_condition.targetValue.toInt()}분 이하로 제한한다.';
      case PledgeType.sleep:
        return '나는 매일\n${_condition.targetValue.toInt()}시간 이상 수면한다.';
      case PledgeType.steps:
        final s = _condition.targetValue.toInt();
        final label = s >= 10000
            ? '${(s / 10000).toStringAsFixed(s % 10000 == 0 ? 0 : 1)}만'
            : '$s';
        return '나는 매일\n${label}보 이상 걷는다.';
      case PledgeType.exercise:
        return '나는 매일\n${_condition.targetValue.toInt()}분 이상 운동한다.';
      case PledgeType.custom:
        final t = _titleCtrl.text.trim();
        return t.isEmpty ? '서약 내용을 입력하십시오.' : '나는\n$t';
    }
  }

  PledgeCondition _buildCondition() {
    if (_type == PledgeType.screenTime) {
      return PledgeCondition(
        type: PledgeType.screenTime,
        targetValue: _hasDurationLimit ? _condition.targetValue : 0,
        unit: '시간',
        operator: ConditionOperator.lte,
        targetApps: _selectedScreenTimePackages.isEmpty
            ? null
            : List.unmodifiable(_selectedScreenTimePackages),
        hasDurationLimit: _hasDurationLimit,
        windowStartHour: _hasWindowLimit ? _windowStartHour : null,
        windowEndHour: _hasWindowLimit ? _windowEndHour : null,
      );
    }
    if (_type == PledgeType.delivery) {
      return PledgeCondition(
        type: PledgeType.delivery,
        targetValue:
            _deliveryFullBan ? 0 : _deliveryMaxCount.toDouble(),
        unit: '회',
        operator: ConditionOperator.lte,
      );
    }
    if (_type == PledgeType.game) {
      return PledgeCondition(
        type: PledgeType.game,
        targetValue: _condition.targetValue,
        unit: '분',
        operator: ConditionOperator.lte,
        targetApps: _selectedGamePackages.isEmpty
            ? null
            : List.unmodifiable(_selectedGamePackages),
      );
    }
    return _condition;
  }

  bool get _canNext => switch (_step) {
        1 => _type == PledgeType.custom
            ? _titleCtrl.text.trim().isNotEmpty
            : _type == PledgeType.screenTime
                ? _hasDurationLimit || _hasWindowLimit
                : true,
        3 => _recipientCtrl.text.trim().isNotEmpty &&
            _phoneCtrl.text.trim().isNotEmpty &&
            _relationship.isNotEmpty,
        4 => _hasConsented && !_saving,
        _ => true,
      };

  void _handleNext() {
    if (_step < 4) {
      setState(() => _step++);
    } else {
      _save();
    }
  }

  void _handleBack() {
    if (_step > 0) {
      setState(() {
        _step--;
        if (_step == 3) _hasConsented = false; // reset when leaving step 4
      });
    } else {
      context.pop();
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final db = ref.read(appDatabaseProvider);
    final start = DateTime.now();
    final end = start.add(Duration(days: _durationDays));
    final name = _recipientCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();
    await db.insertVow(VowsCompanion.insert(
      userId: 1,
      title: _generateTitle(),
      description: const Value(null),
      pledgeType: _type.name,
      conditionJson: _buildCondition().toJsonString(),
      penaltyAmount: _penalty,
      penaltyRecipient: Value('$name|$phone|$_relationship'),
      startDate: start,
      endDate: end,
    ));
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GundaColors.bg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: _handleBack,
        ),
        title: Text(_stepLabels[_step]),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: TweenAnimationBuilder<double>(
            tween: Tween(end: (_step + 1) / _stepLabels.length),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            builder: (_, v, __) => LinearProgressIndicator(
              value: v,
              minHeight: 2,
              backgroundColor: GundaColors.grey6,
              color: GundaColors.green,
            ),
          ),
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, anim) => FadeTransition(
          opacity: anim,
          child: child,
        ),
        child: KeyedSubtree(
          key: ValueKey(_step),
          child: _buildStep(),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildStep() => switch (_step) {
        0 => _StepCategory(
            selected: _type, onChanged: _onTypeChanged),
        1 => _StepCondition(
            type: _type,
            titleCtrl: _titleCtrl,
            condition: _condition,
            contractSentence: _buildContractSentence(),
            isStrict: _isStrict,
            onConditionChanged: (c) =>
                setState(() => _condition = c),
            // screenTime
            selectedScreenTimePackages: _selectedScreenTimePackages,
            installedUserApps: _installedUserApps ?? [],
            loadingUserApps: _loadingUserApps,
            onScreenTimePackagesChanged: (pkgs) =>
                setState(() => _selectedScreenTimePackages = pkgs),
            hasDurationLimit: _hasDurationLimit,
            hasWindowLimit: _hasWindowLimit,
            windowStartHour: _windowStartHour,
            windowEndHour: _windowEndHour,
            onDurationToggled: (v) =>
                setState(() => _hasDurationLimit = v),
            onWindowToggled: (v) =>
                setState(() => _hasWindowLimit = v),
            onWindowStartChanged: (v) =>
                setState(() => _windowStartHour = v),
            onWindowEndChanged: (v) =>
                setState(() => _windowEndHour = v),
            // game
            loadingGames: _loadingGames,
            installedGames: _installedGames ?? [],
            selectedGamePackages: _selectedGamePackages,
            onGameSelectionChanged: (pkgs) =>
                setState(() => _selectedGamePackages = pkgs),
            // delivery
            deliveryFullBan: _deliveryFullBan,
            deliveryMaxCount: _deliveryMaxCount,
            onDeliveryFullBanChanged: (v) =>
                setState(() => _deliveryFullBan = v),
            onDeliveryMaxCountChanged: (v) =>
                setState(() => _deliveryMaxCount = v),
          ),
        2 => _StepPeriod(
            durationDays: _durationDays,
            penalty: _penalty,
            onDurationChanged: (d) =>
                setState(() => _durationDays = d),
            onPenaltyChanged: (p) =>
                setState(() => _penalty = p),
          ),
        3 => _StepRecipient(
            recipientCtrl: _recipientCtrl,
            phoneCtrl: _phoneCtrl,
            relationship: _relationship,
            onRelationshipChanged: (v) =>
                setState(() => _relationship = v),
          ),
        _ => _StepSummary(
            type: _type,
            title: _generateTitle(),
            condition: _buildCondition(),
            durationDays: _durationDays,
            penalty: _penalty,
            recipient: _recipientCtrl.text.trim(),
            phone: _phoneCtrl.text.trim(),
            relationship: _relationship,
            hasConsented: _hasConsented,
            saving: _saving,
            onConsentChanged: (v) =>
                setState(() => _hasConsented = v),
            onSave: _save,
          ),
      };

  Widget _buildBottomBar() {
    // Step 4 uses hold-to-confirm inside _StepSummary; no bottom bar needed
    if (_step == 4) return const SizedBox.shrink();
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
        child: ListenableBuilder(
          listenable: Listenable.merge([_titleCtrl, _recipientCtrl, _phoneCtrl]),
          builder: (_, __) => FilledButton(
            onPressed: _canNext ? _handleNext : null,
            child: Text(switch (_step) {
              0 => '이것을 건다',
              1 => '이대로 한다',
              2 => '돈까지 걸었다',
              3 => '집행자를 지정한다',
              _ => '계속',
            }),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Step 0 – Category
// ─────────────────────────────────────────────────────────

const _categories = [
  (
    PledgeType.screenTime,
    '디지털 디톡스',
    Icons.phone_android_outlined,
    '앱 사용 시간 제한'
  ),
  (PledgeType.sleep, '수면', Icons.bedtime_outlined, '취침·수면 시간'),
  (
    PledgeType.steps,
    '걸음수',
    Icons.directions_walk_outlined,
    '하루 목표 걸음수'
  ),
  (
    PledgeType.exercise,
    '운동',
    Icons.fitness_center_outlined,
    '운동 시간 달성'
  ),
  (
    PledgeType.delivery,
    '배달음식',
    Icons.delivery_dining_outlined,
    '배달앱 사용 제한'
  ),
  (
    PledgeType.game,
    '게임',
    Icons.sports_esports_outlined,
    '게임 시간 제한'
  ),
];

class _StepCategory extends StatelessWidget {
  final PledgeType selected;
  final ValueChanged<PledgeType> onChanged;
  const _StepCategory(
      {required this.selected, required this.onChanged});

  static const _wip = {PledgeType.exercise, PledgeType.custom, PledgeType.steps, PledgeType.sleep};

  void _showWip(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: const Text('서비스 준비 중입니다.'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: GundaColors.grey5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
      children: [
        const Text(
          '무엇을\n서약할 것입니까?',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: GundaColors.white,
            letterSpacing: -0.4,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          '가장 지키기 어려운 것부터 시작하십시오.',
          style: TextStyle(fontSize: 14, color: GundaColors.grey2),
        ),
        const SizedBox(height: 24),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: _categories.length,
          itemBuilder: (_, i) {
            final (type, label, icon, sub) = _categories[i];
            final isOn = selected == type;
            final disabled = _wip.contains(type);
            return Opacity(
              opacity: disabled ? 0.38 : 1.0,
              child: _CategoryTile(
                icon: icon,
                label: label,
                sub: sub,
                isSelected: isOn,
                onTap: disabled
                    ? () => _showWip(context)
                    : () => onChanged(type),
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        Opacity(
          opacity: 0.38,
          child: _CategoryTileFull(
            icon: Icons.edit_outlined,
            label: '자유 입력',
            sub: '양심 모드 — 매일 직접 체크',
            isSelected: selected == PledgeType.custom,
            onTap: () => _showWip(context),
          ),
        ),
      ],
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sub;
  final bool isSelected;
  final VoidCallback onTap;
  const _CategoryTile(
      {required this.icon,
      required this.label,
      required this.sub,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color:
              isSelected ? GundaColors.greenBg : GundaColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? GundaColors.green
                : GundaColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon,
                size: 22,
                color: isSelected
                    ? GundaColors.green
                    : GundaColors.grey2),
            const Spacer(),
            Text(label,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: GundaColors.white)),
            const SizedBox(height: 2),
            Text(sub,
                style: TextStyle(
                    fontSize: 10,
                    color: isSelected
                        ? GundaColors.green
                        : GundaColors.grey3)),
          ],
        ),
      ),
    );
  }
}

class _CategoryTileFull extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sub;
  final bool isSelected;
  final VoidCallback onTap;
  const _CategoryTileFull(
      {required this.icon,
      required this.label,
      required this.sub,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color:
              isSelected ? GundaColors.greenBg : GundaColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? GundaColors.green
                : GundaColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 22,
                color: isSelected
                    ? GundaColors.green
                    : GundaColors.grey2),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: GundaColors.white)),
                Text(sub,
                    style: TextStyle(
                        fontSize: 10,
                        color: isSelected
                            ? GundaColors.green
                            : GundaColors.grey3)),
              ],
            ),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check_circle,
                  size: 16, color: GundaColors.green),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Step 1 – Condition
// ─────────────────────────────────────────────────────────

class _StepCondition extends StatelessWidget {
  final PledgeType type;
  final TextEditingController titleCtrl;
  final PledgeCondition condition;
  final String contractSentence;
  final bool isStrict;
  final ValueChanged<PledgeCondition> onConditionChanged;
  // screenTime
  final List<String> selectedScreenTimePackages;
  final List<InstalledApp> installedUserApps;
  final bool loadingUserApps;
  final ValueChanged<List<String>> onScreenTimePackagesChanged;
  final bool hasDurationLimit;
  final bool hasWindowLimit;
  final int windowStartHour;
  final int windowEndHour;
  final ValueChanged<bool> onDurationToggled;
  final ValueChanged<bool> onWindowToggled;
  final ValueChanged<int> onWindowStartChanged;
  final ValueChanged<int> onWindowEndChanged;
  // game
  final bool loadingGames;
  final List<InstalledApp> installedGames;
  final List<String> selectedGamePackages;
  final ValueChanged<List<String>> onGameSelectionChanged;
  // delivery
  final bool deliveryFullBan;
  final int deliveryMaxCount;
  final ValueChanged<bool> onDeliveryFullBanChanged;
  final ValueChanged<int> onDeliveryMaxCountChanged;

  const _StepCondition({
    required this.type,
    required this.titleCtrl,
    required this.condition,
    required this.contractSentence,
    required this.isStrict,
    required this.onConditionChanged,
    required this.selectedScreenTimePackages,
    required this.installedUserApps,
    required this.loadingUserApps,
    required this.onScreenTimePackagesChanged,
    required this.hasDurationLimit,
    required this.hasWindowLimit,
    required this.windowStartHour,
    required this.windowEndHour,
    required this.onDurationToggled,
    required this.onWindowToggled,
    required this.onWindowStartChanged,
    required this.onWindowEndChanged,
    required this.loadingGames,
    required this.installedGames,
    required this.selectedGamePackages,
    required this.onGameSelectionChanged,
    required this.deliveryFullBan,
    required this.deliveryMaxCount,
    required this.onDeliveryFullBanChanged,
    required this.onDeliveryMaxCountChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
      children: [
        const Text(
          '얼마나 독하게\n할 것입니까?',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: GundaColors.white,
            letterSpacing: -0.4,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          '느슨한 조건은 느슨한 결과를 낳습니다.',
          style: TextStyle(fontSize: 14, color: GundaColors.grey2),
        ),
        const SizedBox(height: 20),
        _ContractPreviewCard(
          sentence: contractSentence,
          isStrict: isStrict,
        ),
        const SizedBox(height: 28),
        // Title only for custom type
        if (type == PledgeType.custom) ...[
          const _SectionLabel('서약 제목'),
          const SizedBox(height: 8),
          TextFormField(
            controller: titleCtrl,
            style: const TextStyle(color: GundaColors.white),
            decoration:
                const InputDecoration(hintText: '서약 제목을 입력하세요'),
            autofocus: true,
          ),
          const SizedBox(height: 28),
        ],
        _buildConditionWidget(),
      ],
    );
  }

  Widget _buildConditionWidget() => switch (type) {
        PledgeType.screenTime => _ScreenTimeConditionWidget(
            selectedPackages: selectedScreenTimePackages,
            timeLimitHours: condition.targetValue.clamp(0, 6).toDouble(),
            otherApps: installedUserApps,
            loadingOtherApps: loadingUserApps,
            onPackagesChanged: onScreenTimePackagesChanged,
            onTimeLimitChanged: (v) => onConditionChanged(
              PledgeCondition(
                type: PledgeType.screenTime,
                targetValue: v,
                unit: '시간',
                operator: ConditionOperator.lte,
              ),
            ),
            hasDurationLimit: hasDurationLimit,
            hasWindowLimit: hasWindowLimit,
            windowStartHour: windowStartHour,
            windowEndHour: windowEndHour,
            onDurationToggled: onDurationToggled,
            onWindowToggled: onWindowToggled,
            onWindowStartChanged: onWindowStartChanged,
            onWindowEndChanged: onWindowEndChanged,
          ),
        PledgeType.delivery => _DeliveryConditionWidget(
            fullBan: deliveryFullBan,
            maxCount: deliveryMaxCount,
            onFullBanChanged: onDeliveryFullBanChanged,
            onMaxCountChanged: onDeliveryMaxCountChanged,
          ),
        PledgeType.game => _GameConditionWidget(
            loading: loadingGames,
            games: installedGames,
            selectedPackages: selectedGamePackages,
            timeLimitMinutes: condition.targetValue,
            onSelectionChanged: onGameSelectionChanged,
            onTimeLimitChanged: (v) => onConditionChanged(
              PledgeCondition(
                type: PledgeType.game,
                targetValue: v,
                unit: '분',
                operator: ConditionOperator.lte,
              ),
            ),
          ),
        _ => _SimpleConditionChips(
            condition: condition,
            onChanged: onConditionChanged,
          ),
      };
}

// ─────────────────────────────────────────────────────────
// Step 2 – Period & Penalty
// ─────────────────────────────────────────────────────────

class _StepPeriod extends StatelessWidget {
  final int durationDays;
  final int penalty;
  final ValueChanged<int> onDurationChanged;
  final ValueChanged<int> onPenaltyChanged;

  const _StepPeriod({
    required this.durationDays,
    required this.penalty,
    required this.onDurationChanged,
    required this.onPenaltyChanged,
  });

  static const _durations = [3, 7, 14, 30, 60, 90];
  static const _penalties = [5000, 10000, 30000, 50000, 100000];

  @override
  Widget build(BuildContext context) {
    final start = DateTime.now();
    final end = start.add(Duration(days: durationDays));

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
      children: [
        const Text(
          '얼마를\n걸 것입니까?',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: GundaColors.white,
            letterSpacing: -0.4,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          '금액이 클수록, 지킬 이유도 커집니다.',
          style: TextStyle(fontSize: 14, color: GundaColors.grey2),
        ),
        const SizedBox(height: 28),
        const _SectionLabel('서약 기간'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _durations.map((d) {
            final isOn = durationDays == d;
            return GestureDetector(
              onTap: () => onDurationChanged(d),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(
                    horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  color: isOn
                      ? GundaColors.white
                      : GundaColors.card,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isOn
                        ? GundaColors.white
                        : GundaColors.border,
                  ),
                ),
                child: Text('$d일',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isOn
                          ? GundaColors.bg
                          : GundaColors.grey1,
                    )),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: GundaColors.card,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: GundaColors.border),
          ),
          child: Row(
            children: [
              const Icon(Icons.calendar_today_outlined,
                  size: 13, color: GundaColors.grey3),
              const SizedBox(width: 8),
              Text(
                '${_fmtDate(start)}  →  ${_fmtDate(end)}',
                style: const TextStyle(
                    fontSize: 13, color: GundaColors.grey1),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),
        const _SectionLabel('위반 시 벌금'),
        const SizedBox(height: 4),
        const Text('1회 위반 시 수취인에게 즉시 통보됩니다.',
            style: TextStyle(
                fontSize: 12, color: GundaColors.grey3)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _penalties.map((amt) {
            final isOn = penalty == amt;
            return GestureDetector(
              onTap: () => onPenaltyChanged(amt),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(
                    horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  color: isOn
                      ? GundaColors.white
                      : GundaColors.card,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isOn
                        ? GundaColors.white
                        : GundaColors.border,
                  ),
                ),
                child: Text(_fmtMoney(amt),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isOn
                          ? GundaColors.bg
                          : GundaColors.grey1,
                    )),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────
// Step 3 – Recipient Selection
// ─────────────────────────────────────────────────────────

const _kRelationships = ['친구', '지인', '직장동료', '연인', '배우자', '가족'];

class _StepRecipient extends StatefulWidget {
  final TextEditingController recipientCtrl;
  final TextEditingController phoneCtrl;
  final String relationship;
  final ValueChanged<String> onRelationshipChanged;

  const _StepRecipient({
    required this.recipientCtrl,
    required this.phoneCtrl,
    required this.relationship,
    required this.onRelationshipChanged,
  });

  @override
  State<_StepRecipient> createState() => _StepRecipientState();
}

class _StepRecipientState extends State<_StepRecipient> {
  bool _pickingContact = false;

  Future<void> _pickContact() async {
    setState(() => _pickingContact = true);
    try {
      final contact = await FlutterContacts.openExternalPick();
      if (contact == null || !mounted) return;

      widget.recipientCtrl.text = contact.displayName;

      final granted =
          await FlutterContacts.requestPermission(readonly: true);
      if (!mounted) return;
      if (granted) {
        final full = await FlutterContacts.getContact(
          contact.id,
          withProperties: true,
        );
        if (full != null && full.phones.isNotEmpty) {
          widget.phoneCtrl.text = full.phones.first.number;
        }
      }
    } finally {
      if (mounted) setState(() => _pickingContact = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 36),
      children: [

        // ── Tension header ───────────────────────────────
        const Text(
          '누가 당신의 실패로\n이득을 봅니까?',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: GundaColors.white,
            letterSpacing: -0.5,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          '이 사람이 집행자가 됩니다.',
          style: TextStyle(fontSize: 13, color: GundaColors.grey2),
        ),

        const SizedBox(height: 28),

        // ── Recipient type row ───────────────────────────
        Row(
          children: [
            // 지인 — active
            Expanded(
              child: _OptionTile(
                label: '지인',
                sub: '연락처에서 선택',
                selected: true,
                onTap: () {},
              ),
            ),
            const SizedBox(width: 10),
            // 기부처 — disabled MVP
            Expanded(
              child: Opacity(
                opacity: 0.35,
                child: IgnorePointer(
                  child: _OptionTile(
                    label: '기부처',
                    sub: '출시 예정',
                    selected: false,
                    onTap: () {},
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // ── Name + phone ─────────────────────────────────
        Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '이름 및 연락처',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: GundaColors.white,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    '당신이 실패할 때 돈을 받는 사람',
                    style: TextStyle(
                        fontSize: 11, color: GundaColors.grey3),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: _pickingContact ? null : _pickContact,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: GundaColors.card,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: GundaColors.border),
                ),
                child: _pickingContact
                    ? const SizedBox.square(
                        dimension: 14,
                        child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: GundaColors.white))
                    : const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.contacts_outlined,
                              size: 14, color: GundaColors.grey2),
                          SizedBox(width: 6),
                          Text(
                            '연락처',
                            style: TextStyle(
                                fontSize: 12,
                                color: GundaColors.grey1,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Name input
        TextField(
          controller: widget.recipientCtrl,
          style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w500),
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: '이름',
            hintStyle: TextStyle(color: Colors.grey.shade400),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 13),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Phone input
        TextField(
          controller: widget.phoneCtrl,
          style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w500),
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: '전화번호',
            hintStyle: TextStyle(color: Colors.grey.shade400),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 13),
            prefixIcon: const Icon(Icons.phone_outlined,
                size: 18, color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),

        const SizedBox(height: 24),

        // ── Relationship chips ───────────────────────────
        const Text(
          '관계',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: GundaColors.white,
          ),
        ),
        const SizedBox(height: 10),
        _OptionChipGroup(
          labels: _kRelationships,
          selectedIndex: _kRelationships.indexOf(widget.relationship),
          onChanged: (i) => widget.onRelationshipChanged(_kRelationships[i]),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────
// Step 4 – Contract Signing
// ─────────────────────────────────────────────────────────

class _StepSummary extends StatelessWidget {
  final PledgeType type;
  final String title;
  final PledgeCondition condition;
  final int durationDays;
  final int penalty;
  final String recipient;
  final String phone;
  final String relationship;
  final bool hasConsented;
  final bool saving;
  final ValueChanged<bool> onConsentChanged;
  final VoidCallback onSave;

  const _StepSummary({
    required this.type,
    required this.title,
    required this.condition,
    required this.durationDays,
    required this.penalty,
    required this.recipient,
    required this.phone,
    required this.relationship,
    required this.hasConsented,
    required this.saving,
    required this.onConsentChanged,
    required this.onSave,
  });

  bool get _canConfirm => hasConsented && !saving;

  @override
  Widget build(BuildContext context) {
    final start = DateTime.now();
    final end = start.add(Duration(days: durationDays));
    final recipientLabel = relationship.isEmpty
        ? recipient
        : '$recipient($relationship)';

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 36),
      children: [

        // ── A. Final Warning ──────────────────────────────
        const Text(
          '이 서약,\n지킬 수 있습니까.',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: GundaColors.white,
            letterSpacing: -0.6,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          '아니라면 지금 멈추십시오.',
          style: TextStyle(fontSize: 13, color: GundaColors.grey2),
        ),

        const SizedBox(height: 28),

        // ── B. Legal Contract Document ────────────────────
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: GundaColors.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: GundaColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Document title
              Row(
                children: [
                  const Text(
                    '행동 서약서',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: GundaColors.grey3,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _fmtDate(start),
                    style: const TextStyle(
                        fontSize: 11, color: GundaColors.grey4),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: GundaColors.white,
                  letterSpacing: -0.3,
                ),
              ),

              const SizedBox(height: 18),
              const Divider(height: 1, color: GundaColors.border),
              const SizedBox(height: 18),

              // Clause 1
              _ClauseRow(
                index: '제1조',
                label: '목적',
                text: condition.toDisplayString(),
              ),
              const SizedBox(height: 12),

              // Clause 2
              _ClauseRow(
                index: '제2조',
                label: '의무 기간',
                text:
                    '${_fmtDate(start)} ~ ${_fmtDate(end)}  (${durationDays}일)',
              ),
              const SizedBox(height: 12),

              // Clause 3
              _ClauseRow(
                index: '제3조',
                label: '패널티',
                text: '위반 시 ${_fmtMoney(penalty)} 즉시 송금',
                highlight: true,
              ),
              const SizedBox(height: 12),

              // Clause 4 — Recipient
              _ClauseRow(
                index: '제4조',
                label: '집행자',
                text: '$recipientLabel\n$phone',
              ),
              const SizedBox(height: 12),

              // Clause 5
              _ClauseRow(
                index: '제5조',
                label: '집행',
                text: '앱 데이터에 의해 자동 판정됨.\n체결 후 취소 및 수정 불가.',
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Live enforcement preview//

        // ── C. Consent Gate ───────────────────────────────
        GestureDetector(
          onTap: () => onConsentChanged(!hasConsented),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: hasConsented
                  ? const Color(0xFF0E1A12)
                  : GundaColors.card,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: hasConsented
                    ? GundaColors.green
                    : GundaColors.border,
                width: hasConsented ? 1.5 : 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 18,
                  height: 18,
                  margin: const EdgeInsets.only(top: 1),
                  decoration: BoxDecoration(
                    color: hasConsented
                        ? GundaColors.green
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: hasConsented
                          ? GundaColors.green
                          : GundaColors.grey4,
                    ),
                  ),
                  child: hasConsented
                      ? const Icon(Icons.check,
                          size: 12, color: Colors.black)
                      : null,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    '나는 위 사항을 이해하며, 위반 시 지정 금액을 즉시 송금함에 동의합니다.',
                    style: TextStyle(
                      fontSize: 13,
                      color: GundaColors.grey1,
                      height: 1.55,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        // ── D. Hold-to-Confirm CTA ───────────────────────
        _HoldToConfirmButton(
          enabled: _canConfirm,
          saving: saving,
          onConfirmed: onSave,
        ),

        const SizedBox(height: 8),
        const Center(
          child: Text(
            '건투를 빕니다.',
            style: TextStyle(fontSize: 11, color: GundaColors.grey4),
          ),
        ),
      ],
    );
  }
}

// Legal clause row
class _ClauseRow extends StatelessWidget {
  final String index;
  final String label;
  final String text;
  final bool highlight;

  const _ClauseRow({
    required this.index,
    required this.label,
    required this.text,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 46,
          child: Text(
            index,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: GundaColors.grey4,
              letterSpacing: 0.3,
            ),
          ),
        ),
        SizedBox(
          width: 36,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: GundaColors.grey3,
            ),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color:
                  highlight ? GundaColors.red : GundaColors.grey1,
              fontWeight: highlight
                  ? FontWeight.w600
                  : FontWeight.w400,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────
// Hold-to-confirm button
// ─────────────────────────────────────────────────────────

class _HoldToConfirmButton extends StatefulWidget {
  final bool enabled;
  final bool saving;
  final VoidCallback onConfirmed;

  const _HoldToConfirmButton({
    required this.enabled,
    required this.saving,
    required this.onConfirmed,
  });

  @override
  State<_HoldToConfirmButton> createState() =>
      _HoldToConfirmButtonState();
}

class _HoldToConfirmButtonState extends State<_HoldToConfirmButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  bool _holding = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _ctrl.addStatusListener((s) {
      if (s == AnimationStatus.completed) {
        HapticFeedback.heavyImpact();
        widget.onConfirmed();
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _start(LongPressStartDetails _) {
    if (!widget.enabled) return;
    HapticFeedback.mediumImpact();
    setState(() => _holding = true);
    _ctrl.forward();
  }

  void _cancel() {
    if (!_holding) return;
    setState(() => _holding = false);
    _ctrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.saving) {
      return Container(
        height: 58,
        decoration: BoxDecoration(
          color: GundaColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: GundaColors.border),
        ),
        child: const Center(
          child: SizedBox.square(
            dimension: 20,
            child: CircularProgressIndicator(
                strokeWidth: 2, color: GundaColors.white),
          ),
        ),
      );
    }

    return GestureDetector(
      onLongPressStart: _start,
      onLongPressEnd: (_) => _cancel(),
      onLongPressCancel: _cancel,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) {
          final progress = _ctrl.value;
          final isActive = widget.enabled;
          return Container(
            height: 58,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: GundaColors.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isActive
                    ? (_holding
                        ? GundaColors.green
                        : GundaColors.border)
                    : GundaColors.grey6,
              ),
            ),
            child: Stack(
              children: [
                // Fill bar
                FractionallySizedBox(
                  widthFactor: progress,
                  child: Container(
                    color: const Color(0x4D1D9E75), // green 30%
                  ),
                ),
                // Label
                Center(
                  child: Text(
                    _holding
                        ? '되돌릴 수 없습니다...'
                        : isActive
                            ? '길게 눌러 서약을 체결한다'
                            : '집행자와 동의 항목을 확인하십시오',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isActive
                          ? (_holding
                              ? GundaColors.green
                              : GundaColors.white)
                          : GundaColors.grey4,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Condition widgets
// ─────────────────────────────────────────────────────────

// ── 디지털 디톡스 ──────────────────────────────────────────

class _ScreenTimeConditionWidget extends StatefulWidget {
  final List<String> selectedPackages;
  final double timeLimitHours;
  final List<InstalledApp> otherApps;
  final bool loadingOtherApps;
  final ValueChanged<List<String>> onPackagesChanged;
  final ValueChanged<double> onTimeLimitChanged;
  // duration + window
  final bool hasDurationLimit;
  final bool hasWindowLimit;
  final int windowStartHour;
  final int windowEndHour;
  final ValueChanged<bool> onDurationToggled;
  final ValueChanged<bool> onWindowToggled;
  final ValueChanged<int> onWindowStartChanged;
  final ValueChanged<int> onWindowEndChanged;

  const _ScreenTimeConditionWidget({
    required this.selectedPackages,
    required this.timeLimitHours,
    required this.otherApps,
    required this.loadingOtherApps,
    required this.onPackagesChanged,
    required this.onTimeLimitChanged,
    required this.hasDurationLimit,
    required this.hasWindowLimit,
    required this.windowStartHour,
    required this.windowEndHour,
    required this.onDurationToggled,
    required this.onWindowToggled,
    required this.onWindowStartChanged,
    required this.onWindowEndChanged,
  });

  @override
  State<_ScreenTimeConditionWidget> createState() =>
      _ScreenTimeConditionWidgetState();
}

class _ScreenTimeConditionWidgetState
    extends State<_ScreenTimeConditionWidget> {
  bool _otherAppsExpanded = false;

  void _toggle(String pkg) {
    final updated = List<String>.from(widget.selectedPackages);
    updated.contains(pkg) ? updated.remove(pkg) : updated.add(pkg);
    widget.onPackagesChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionLabel('A. 금지할 앱'),
        const SizedBox(height: 4),
        const Text(
          '선택하지 않으면 전체 스마트폰 사용에 적용됩니다.',
          style: TextStyle(fontSize: 11, color: GundaColors.grey3),
        ),
        const SizedBox(height: 12),

        // 2×2 preset grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.8,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: _kPresetScreenTimeApps.length,
          itemBuilder: (_, i) {
            final app = _kPresetScreenTimeApps[i];
            final isOn =
                widget.selectedPackages.contains(app.package);
            return GestureDetector(
              onTap: () => _toggle(app.package),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: isOn
                      ? GundaColors.greenBg
                      : GundaColors.card,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isOn
                        ? GundaColors.green
                        : GundaColors.border,
                    width: isOn ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(app.icon,
                        size: 16,
                        color: isOn
                            ? GundaColors.green
                            : GundaColors.grey2),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        app.name,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isOn
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: isOn
                              ? GundaColors.white
                              : GundaColors.grey1,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isOn)
                      const Icon(Icons.check,
                          size: 12, color: GundaColors.green),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 8),

        // "다른 앱 선택" expandable tile
        GestureDetector(
          onTap: () =>
              setState(() => _otherAppsExpanded = !_otherAppsExpanded),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: _otherAppsExpanded
                  ? GundaColors.grey6
                  : GundaColors.card,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: GundaColors.border),
            ),
            child: Row(
              children: [
                Icon(
                  _otherAppsExpanded
                      ? Icons.expand_less
                      : Icons.add,
                  size: 16,
                  color: GundaColors.grey2,
                ),
                const SizedBox(width: 10),
                const Text('다른 앱 선택',
                    style: TextStyle(
                        fontSize: 13, color: GundaColors.grey1)),
                const Spacer(),
                // show count of other-app selections
                Builder(builder: (_) {
                  final otherPkgs = widget.selectedPackages
                      .where((pkg) => !_kPresetScreenTimeApps
                          .any((a) => a.package == pkg))
                      .length;
                  if (otherPkgs > 0) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: GundaColors.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text('$otherPkgs',
                          style: const TextStyle(
                              fontSize: 11,
                              color: GundaColors.white,
                              fontWeight: FontWeight.w700)),
                    );
                  }
                  return const SizedBox.shrink();
                }),
              ],
            ),
          ),
        ),

        // Expanded other-apps list
        if (_otherAppsExpanded) ...[
          const SizedBox(height: 2),
          Container(
            constraints: const BoxConstraints(maxHeight: 260),
            decoration: BoxDecoration(
              border: Border.all(color: GundaColors.border),
              borderRadius: BorderRadius.circular(10),
            ),
            child: widget.loadingOtherApps
                ? const Center(
                    child: Padding(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator(
                            color: GundaColors.white)))
                : widget.otherApps.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('설치된 앱이 없습니다.',
                            style: TextStyle(
                                fontSize: 13,
                                color: GundaColors.grey3)),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: widget.otherApps.length,
                        itemBuilder: (_, i) {
                          final app = widget.otherApps[i];
                          final isOn = widget.selectedPackages
                              .contains(app.packageName);
                          return CheckboxListTile(
                            value: isOn,
                            onChanged: (_) =>
                                _toggle(app.packageName),
                            title: Text(app.appName,
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: GundaColors.white)),
                            dense: true,
                            controlAffinity:
                                ListTileControlAffinity.trailing,
                          );
                        },
                      ),
          ),
        ],

        const SizedBox(height: 32),

        // ── B. 하루 사용 시간 ─────────────────────────────────
        const _SectionLabel('B. 하루 사용 시간'),
        const SizedBox(height: 4),
        const Text(
          '없음을 선택하면 시간 제한이 적용되지 않습니다.',
          style: TextStyle(fontSize: 11, color: GundaColors.grey3),
        ),
        const SizedBox(height: 10),
        _OptionChipGroup(
          labels: const ['없음', '30분', '1시간', '2시간', '3시간', '완전 금지'],
          selectedIndex: _durationChipIndex,
          onChanged: _onDurationChipChanged,
          strictIndex: 5,
        ),

        const SizedBox(height: 28),

        // ── C. 시간대 금지 ────────────────────────────────────
        const _SectionLabel('C. 시간대 금지'),
        const SizedBox(height: 4),
        const Text(
          '특정 시간대에는 앱을 사용할 수 없습니다.',
          style: TextStyle(fontSize: 11, color: GundaColors.grey3),
        ),
        const SizedBox(height: 10),
        _OptionChipGroup(
          labels: const ['없음', '시간대 지정'],
          selectedIndex: widget.hasWindowLimit ? 1 : 0,
          onChanged: (i) => widget.onWindowToggled(i == 1),
        ),
        if (widget.hasWindowLimit) ...[
          const SizedBox(height: 14),
          _HourPicker(
            label: '금지 시작',
            hour: widget.windowStartHour,
            onChanged: widget.onWindowStartChanged,
          ),
          const SizedBox(height: 10),
          _HourPicker(
            label: '금지 종료',
            hour: widget.windowEndHour,
            onChanged: widget.onWindowEndChanged,
          ),
          const SizedBox(height: 8),
          const Text(
            '자정을 넘어 설정 가능 (예: 23시 → 07시)',
            style: TextStyle(fontSize: 11, color: GundaColors.grey3),
          ),
        ],
      ],
    );
  }

  // 현재 선택된 duration 칩 인덱스 (없음=0, 30분=1, 1시간=2, 2시간=3, 3시간=4, 완전금지=5)
  int get _durationChipIndex {
    if (!widget.hasDurationLimit) return 0;
    final v = widget.timeLimitHours;
    if (v == 0) return 5;
    if (v <= 0.5) return 1;
    if (v <= 1.0) return 2;
    if (v <= 2.0) return 3;
    return 4;
  }

  void _onDurationChipChanged(int i) {
    const values = [0.0, 0.5, 1.0, 2.0, 3.0, 0.0]; // 완전금지 = 0
    if (i == 0) {
      widget.onDurationToggled(false);
    } else {
      widget.onDurationToggled(true);
      widget.onTimeLimitChanged(values[i]);
    }
  }
}

// 실시간 계약 문장 미리보기 카드
class _ContractPreviewCard extends StatelessWidget {
  final String sentence;
  final bool isStrict;
  const _ContractPreviewCard(
      {required this.sentence, required this.isStrict});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isStrict
            ? const Color(0xFF1E0E0E)
            : GundaColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isStrict
              ? const Color(0xFF5A2020)
              : GundaColors.border,
          width: isStrict ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sentence,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: isStrict ? GundaColors.red : GundaColors.white,
              letterSpacing: -0.3,
              height: 1.45,
            ),
          ),
          if (isStrict) ...[
            const SizedBox(height: 10),
            const Row(
              children: [
                Icon(Icons.warning_amber_rounded,
                    size: 12, color: GundaColors.red),
                SizedBox(width: 5),
                Text(
                  '최고 강도의 제한입니다.',
                  style: TextStyle(
                      fontSize: 11,
                      color: GundaColors.red,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// 명시적 선택 칩 그룹 (슬라이더 대체)
class _OptionChipGroup extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final int? strictIndex; // 완전금지 등 강도 높은 칩 인덱스

  const _OptionChipGroup({
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
    this.strictIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(labels.length, (i) {
        final isOn = selectedIndex == i;
        final isStrict = strictIndex != null && i == strictIndex;
        return GestureDetector(
          onTap: () => onChanged(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isOn
                  ? (isStrict
                      ? const Color(0xFF2A1010)
                      : GundaColors.white)
                  : GundaColors.card,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isOn
                    ? (isStrict ? GundaColors.red : GundaColors.white)
                    : GundaColors.border,
              ),
            ),
            child: Text(
              labels[i],
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isOn
                    ? (isStrict ? GundaColors.red : GundaColors.bg)
                    : GundaColors.grey1,
              ),
            ),
          ),
        );
      }),
    );
  }
}

// 시간(0–23) 증감 피커
class _HourPicker extends StatelessWidget {
  final String label;
  final int hour;
  final ValueChanged<int> onChanged;
  const _HourPicker(
      {required this.label,
      required this.hour,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 68,
          child: Text(label,
              style: const TextStyle(
                  fontSize: 13, color: GundaColors.grey1)),
        ),
        IconButton(
          onPressed: () => onChanged((hour - 1 + 24) % 24),
          icon: const Icon(Icons.remove_circle_outline,
              color: GundaColors.grey2),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 36,
          child: Text(
            '${hour.toString().padLeft(2, '0')}시',
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: GundaColors.white),
          ),
        ),
        const SizedBox(width: 12),
        IconButton(
          onPressed: () => onChanged((hour + 1) % 24),
          icon: const Icon(Icons.add_circle_outline,
              color: GundaColors.grey2),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }
}

class _SimpleConditionChips extends StatelessWidget {
  final PledgeCondition condition;
  final ValueChanged<PledgeCondition> onChanged;
  const _SimpleConditionChips(
      {required this.condition, required this.onChanged});

  static const _sleepOptions = [
    ('5시간', 5.0),
    ('6시간', 6.0),
    ('7시간', 7.0),
    ('8시간', 8.0),
    ('9시간', 9.0),
  ];
  static const _stepsOptions = [
    ('5,000보', 5000.0),
    ('8,000보', 8000.0),
    ('10,000보', 10000.0),
    ('15,000보', 15000.0),
    ('20,000보', 20000.0),
  ];
  static const _exerciseOptions = [
    ('15분', 15.0),
    ('20분', 20.0),
    ('30분', 30.0),
    ('45분', 45.0),
    ('60분', 60.0),
  ];

  @override
  Widget build(BuildContext context) {
    final opts = switch (condition.type) {
      PledgeType.sleep => _sleepOptions,
      PledgeType.steps => _stepsOptions,
      _ => _exerciseOptions,
    };
    final sectionLabel = switch (condition.type) {
      PledgeType.sleep => '최소 수면 시간',
      PledgeType.steps => '하루 목표 걸음수',
      _ => '하루 운동 시간',
    };
    final sublabel = switch (condition.type) {
      PledgeType.sleep => '이 시간 이상 수면해야 달성으로 인정됩니다.',
      PledgeType.steps => '이 걸음수 이상 걸어야 달성으로 인정됩니다.',
      _ => '이 시간 이상 운동해야 달성으로 인정됩니다.',
    };
    final labels = opts.map((o) => o.$1).toList();
    final values = opts.map((o) => o.$2).toList();
    final idx = values.indexWhere((v) => v == condition.targetValue);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel(sectionLabel),
        const SizedBox(height: 4),
        Text(sublabel,
            style: const TextStyle(
                fontSize: 11, color: GundaColors.grey3)),
        const SizedBox(height: 10),
        _OptionChipGroup(
          labels: labels,
          selectedIndex: idx < 0 ? 2 : idx,
          onChanged: (i) => onChanged(PledgeCondition(
            type: condition.type,
            targetValue: values[i],
            unit: condition.unit,
            operator: condition.operator,
          )),
        ),
      ],
    );
  }
}

class _DeliveryConditionWidget extends StatelessWidget {
  final bool fullBan;
  final int maxCount;
  final ValueChanged<bool> onFullBanChanged;
  final ValueChanged<int> onMaxCountChanged;

  const _DeliveryConditionWidget({
    required this.fullBan,
    required this.maxCount,
    required this.onFullBanChanged,
    required this.onMaxCountChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: GundaColors.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: GundaColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('검증 대상 앱',
                  style: TextStyle(
                      fontSize: 11,
                      color: GundaColors.grey3,
                      letterSpacing: 0.1)),
              const SizedBox(height: 10),
              ..._deliveryApps.map((app) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        const Icon(
                            Icons.delivery_dining_outlined,
                            size: 14,
                            color: GundaColors.grey3),
                        const SizedBox(width: 8),
                        Text(app.name,
                            style: const TextStyle(
                                fontSize: 13,
                                color: GundaColors.grey1)),
                      ],
                    ),
                  )),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _OptionTile(
          label: '완전 금지',
          sub: '배달앱 실행 자체를 차단',
          selected: fullBan,
          onTap: () => onFullBanChanged(true),
          isStrict: true,
        ),
        const SizedBox(height: 8),
        _OptionTile(
          label: '횟수 제한',
          sub: '하루 최대 주문 횟수 설정',
          selected: !fullBan,
          onTap: () => onFullBanChanged(false),
        ),
        if (!fullBan) ...[
          const SizedBox(height: 16),
          const _SectionLabel('하루 최대 횟수'),
          const SizedBox(height: 10),
          _OptionChipGroup(
            labels: const ['1회', '2회', '3회'],
            selectedIndex: (maxCount - 1).clamp(0, 2),
            onChanged: (i) => onMaxCountChanged(i + 1),
          ),
        ],
      ],
    );
  }
}

class _GameConditionWidget extends StatelessWidget {
  final bool loading;
  final List<InstalledApp> games;
  final List<String> selectedPackages;
  final double timeLimitMinutes;
  final ValueChanged<List<String>> onSelectionChanged;
  final ValueChanged<double> onTimeLimitChanged;

  const _GameConditionWidget({
    required this.loading,
    required this.games,
    required this.selectedPackages,
    required this.timeLimitMinutes,
    required this.onSelectionChanged,
    required this.onTimeLimitChanged,
  });

  void _toggle(String pkg) {
    final updated = List<String>.from(selectedPackages);
    updated.contains(pkg) ? updated.remove(pkg) : updated.add(pkg);
    onSelectionChanged(updated);
  }

  // 칩 인덱스 → 분 값
  static const _kGameMinutes = [0.0, 30.0, 60.0, 120.0, 180.0];

  int get _chipIndex {
    if (timeLimitMinutes == 0) return 0;
    if (timeLimitMinutes <= 30) return 1;
    if (timeLimitMinutes <= 60) return 2;
    if (timeLimitMinutes <= 120) return 3;
    return 4;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionLabel('A. 하루 게임 시간'),
        const SizedBox(height: 4),
        const Text(
          '완전 금지는 게임 앱 실행 자체를 차단합니다.',
          style: TextStyle(fontSize: 11, color: GundaColors.grey3),
        ),
        const SizedBox(height: 10),
        _OptionChipGroup(
          labels: const ['완전 금지', '30분', '1시간', '2시간', '3시간'],
          selectedIndex: _chipIndex,
          onChanged: (i) => onTimeLimitChanged(_kGameMinutes[i]),
          strictIndex: 0,
        ),
        const SizedBox(height: 28),
        Row(
          children: [
            const Text('B. 제한할 게임',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: GundaColors.white)),
            if (selectedPackages.isNotEmpty) ...[
              const SizedBox(width: 8),
              Text('${selectedPackages.length}개 선택',
                  style: const TextStyle(
                      fontSize: 11, color: GundaColors.grey3)),
            ],
          ],
        ),
        const SizedBox(height: 8),
        if (loading)
          const Center(
              child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(
                      color: GundaColors.white)))
        else if (games.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: GundaColors.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: GundaColors.border),
            ),
            child: const Center(
              child: Text('설치된 게임 앱이 없습니다.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 13,
                      color: GundaColors.grey3)),
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: GundaColors.border),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: games.map((game) {
                final isOn =
                    selectedPackages.contains(game.packageName);
                return CheckboxListTile(
                  value: isOn,
                  onChanged: (_) => _toggle(game.packageName),
                  title: Text(game.appName,
                      style: const TextStyle(
                          fontSize: 14,
                          color: GundaColors.white)),
                  secondary: game.icon != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(game.icon!,
                              width: 36, height: 36))
                      : const Icon(
                          Icons.sports_esports_outlined,
                          size: 36,
                          color: GundaColors.grey2),
                  controlAffinity:
                      ListTileControlAffinity.trailing,
                );
              }).toList(),
            ),
          ),
        const SizedBox(height: 6),
        const Text('선택하지 않으면 모든 게임에 적용됩니다.',
            style: TextStyle(
                fontSize: 11, color: GundaColors.grey3)),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────
// Shared small widgets
// ─────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: GundaColors.grey3,
            letterSpacing: 0.2));
  }
}

class _OptionTile extends StatelessWidget {
  final String label;
  final String sub;
  final bool selected;
  final VoidCallback onTap;
  final bool isStrict;
  const _OptionTile({
    required this.label,
    required this.sub,
    required this.selected,
    required this.onTap,
    this.isStrict = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
            horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? (isStrict
                  ? const Color(0xFF2A1010)
                  : GundaColors.greenBg)
              : GundaColors.card,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected
                ? (isStrict ? GundaColors.red : GundaColors.green)
                : GundaColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: selected
                              ? GundaColors.white
                              : GundaColors.grey1)),
                  Text(sub,
                      style: TextStyle(
                          fontSize: 12,
                          color: selected
                              ? (isStrict
                                  ? GundaColors.red
                                  : GundaColors.green)
                              : GundaColors.grey3)),
                ],
              ),
            ),
            if (selected)
              Icon(Icons.check_circle,
                  size: 16,
                  color: isStrict
                      ? GundaColors.red
                      : GundaColors.green),
          ],
        ),
      ),
    );
  }
}
