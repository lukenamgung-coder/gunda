import 'dart:math';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/database/app_database.dart';
import '../../core/providers/database_provider.dart';
import '../../shared/theme/app_theme.dart';

// ── 닉네임 추천 데이터 ────────────────────────────────────────
// 카테고리 구분 없이 대표 12개만 노출. 카테고리별 전체 목록은 유지.

const _kRandomPool = [
  '어차피또한다',
  '이번에도실패예정',
  '밤마다지는사람',
  '또할사람',
  '이번엔진짜끊는다',
  '어딘가에서또무너짐',
  '아직도못끊는중',
];

// 셔플용 전체 후보 풀 — featured + random + 추가
const _kAllSuggestions = [
  // featured 12
  '유튜브좀비', '야식노예', '한판만', '침대수호자',
  '의자인간', '스크롤중독', '밤샘장인', '배민홀릭',
  '랭크지옥', '새벽4시', '어차피또한다', '매번다짐',
  // random pool
  '이번에도실패예정', '밤마다지는사람', '또할사람',
  '이번엔진짜끊는다', '어딘가에서또무너짐', '아직도못끊는중',
  // 추가
  '잠깐만더', '다음엔진짜', '내일부터시작', '끊는중',
  '한번만더', '결심만해봄', '알람무시자', '새벽까지',
  '주말내내', '칼퇴후주문', '수면빚쌓이는중', '만보는꿈',
  '계단이뭐야', '의지박약', '이번엔다를줄', '손이먼저간다',
  '끊을수없다', '한타만더',
];

// ── 서약 프리셋 ───────────────────────────────────────────────

const _kPresets = [
  _PresetItem(
    label: '3일간, 23시 이후 유튜브 0분',
    amount: '₩10,000',
    tag: '가장 많이 시작한 서약',
  ),
  _PresetItem(
    label: '토·일 각각 10,000보 이상',
    amount: '₩5,000',
    tag: null,
  ),
  _PresetItem(
    label: '3일간 배달앱 실행 0회',
    amount: '₩8,000',
    tag: null,
  ),
];

class _PresetItem {
  final String label;
  final String amount;
  final String? tag;
  const _PresetItem({
    required this.label,
    required this.amount,
    this.tag,
  });

  // GoRouter로 넘길 때 쓰는 단일 문자열
  String get routeValue => '$label ($amount)';
}

// ── 온보딩 화면 ───────────────────────────────────────────────

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() =>
      _OnboardingScreenState();
}

class _OnboardingScreenState
    extends State<OnboardingScreen> {
  final _pageCtrl = PageController();
  int _page = 0;

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  void _next() {
    _pageCtrl.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _finish({
    required bool goCreate,
    String? preset,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);
    if (!mounted) return;
    if (goCreate) {
      final query = preset != null
          ? '?preset=${Uri.encodeComponent(preset)}'
          : '';
      context.go('/home/vow/create$query');
    } else {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GundaColors.bg,
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              controller: _pageCtrl,
              // 스와이프 비활성화 — CTA 버튼으로만 이동
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (p) =>
                  setState(() => _page = p),
              children: [
                _Page1(
                  onStart: _next,
                  onSkip: () => _finish(goCreate: false),
                ),
                _Page2(onNext: _next),
                _NicknameStep(onNext: _next),
                _Page4(
                  onStart: (preset) =>
                      _finish(goCreate: true, preset: preset),
                  onSkip: () => _finish(goCreate: false),
                ),
              ],
            ),

            // 점 인디케이터
            Positioned(
              left: 0,
              right: 0,
              bottom: 32,
              child: _DotsIndicator(
                  current: _page, total: 4),
            ),
          ],
        ),
      ),
    );
  }
}

// ── 점 인디케이터 ──────────────────────────────────────────

class _DotsIndicator extends StatelessWidget {
  final int current;
  final int total;
  const _DotsIndicator(
      {required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
        final isOn = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          width: isOn ? 16 : 4,
          height: 4,
          margin: const EdgeInsets.only(right: 5),
          decoration: BoxDecoration(
            color: isOn
                ? GundaColors.white
                : GundaColors.grey5,
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }
}

// ── 공통 레이아웃 ──────────────────────────────────────────

class _OnboardingLayout extends StatelessWidget {
  final String tag;
  final Widget title;
  final Widget? body;
  final Widget? extra;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final String? ghostLabel;
  final VoidCallback? onGhost;

  const _OnboardingLayout({
    required this.tag,
    required this.title,
    this.body,
    this.extra,
    required this.primaryLabel,
    required this.onPrimary,
    this.ghostLabel,
    this.onGhost,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 48, 28, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tag,
            style: const TextStyle(
              fontSize: 11,
              color: GundaColors.grey4,
              letterSpacing: 0.12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          title,
          if (body != null) ...[
            const SizedBox(height: 20),
            body!,
          ],
          if (extra != null) ...[
            const SizedBox(height: 24),
            extra!,
          ],
          const Spacer(),
          FilledButton(
            onPressed: onPrimary,
            child: Text(primaryLabel),
          ),
          if (ghostLabel != null && onGhost != null) ...[
            const SizedBox(height: 4),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: onGhost,
                child: Text(ghostLabel!),
              ),
            ),
          ],
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// ── 1장: 훅 ───────────────────────────────────────────────
// 변경: body를 한 호흡으로 통합. 스킵 레이블 명확화.

class _Page1 extends StatelessWidget {
  final VoidCallback onStart;
  final VoidCallback onSkip;
  const _Page1({required this.onStart, required this.onSkip});

  @override
  Widget build(BuildContext context) {
    return _OnboardingLayout(
      tag: '01 / 04',
      title: const Text(
        '지키지 못한 말은\n기억되지 않습니다.',
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w900,
          color: GundaColors.white,
          height: 1.35,
          letterSpacing: -0.5,
        ),
      ),
      body: const Text(
        '그래서 계속 반복됩니다.',
        style: TextStyle(
          fontSize: 16,
          color: GundaColors.grey1,
          height: 1.65,
        ),
      ),
      primaryLabel: '시작하기',
      onPrimary: onStart,
      // "계정 없이"는 계정 개념이 없는 앱에서 혼란을 줌 → 제거
      ghostLabel: '일단 둘러보기',
      onGhost: onSkip,
    );
  }
}

// ── 2장: 철학 ──────────────────────────────────────────────
// 변경: CTA 레이블 강화. "위반 감지" 에 한 줄 신뢰 문구 추가.

class _Page2 extends StatelessWidget {
  final VoidCallback onNext;
  const _Page2({required this.onNext});

  @override
  Widget build(BuildContext context) {
    return _OnboardingLayout(
      tag: '02 / 04',
      title: const Text(
        '돈은 말보다\n무겁습니다.',
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w900,
          color: GundaColors.white,
          height: 1.35,
          letterSpacing: -0.5,
        ),
      ),
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _BulletItem('약속이 기록으로 남습니다.'),
          SizedBox(height: 14),
          // 감지 방식에 대한 한 줄 신뢰 문구 추가
          _BulletItem('기기 데이터를 활용, 위반은 자동으로 감지됩니다.'),
          SizedBox(height: 14),
          _BulletItem('어기면, 돈이 이동합니다.'),
        ],
      ),
      // "다음" → 감정적 흐름을 끊지 않는 능동형 레이블
      primaryLabel: '납득했습니다',
      onPrimary: onNext,
    );
  }
}

class _BulletItem extends StatelessWidget {
  final String text;
  const _BulletItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Container(
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: GundaColors.green,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              color: GundaColors.grey1,
              height: 1.65,
            ),
          ),
        ),
      ],
    );
  }
}

// ── 3장: 닉네임 ────────────────────────────────────────────
// 변경: 3-sub-step → 단일 뷰 (칩 + 텍스트필드 항상 표시).
//       "이걸로 하시겠습니까?" 등 설문체 제거.
//       칩 선택 즉시 필드 채움 + 토스트 유지.
//       기본 CTA를 FilledButton으로 격상.

class _NicknameStep extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  const _NicknameStep({required this.onNext});

  @override
  ConsumerState<_NicknameStep> createState() =>
      _NicknameStepState();
}

class _NicknameStepState
    extends ConsumerState<_NicknameStep> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  late List<String> _displayedChips;
  int _chipPage = 0;

  @override
  void initState() {
    super.initState();
    final pool = List<String>.from(_kAllSuggestions)..shuffle();
    _displayedChips = pool.take(12).toList();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _shuffleChips() {
    final current = _controller.text;
    final pool = List<String>.from(_kAllSuggestions)..shuffle();
    final next = pool.where((s) => s != current).take(12).toList();
    setState(() {
      _displayedChips = next;
      _chipPage++;
    });
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: GundaColors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          duration: const Duration(milliseconds: 1500),
          margin: EdgeInsets.only(
            left: 40,
            right: 40,
            bottom: 264 + MediaQuery.of(context).padding.bottom,
          ),
          elevation: 0,
        ),
      );
  }

  void _pickSuggestion(String name) {
    _controller.text = name;
    _focusNode.unfocus();
    setState(() {});
    _showToast('웬지 그럴것 같았습니다.');
  }

  void _pickRandom() {
    final name =
        _kRandomPool[Random().nextInt(_kRandomPool.length)];
    _controller.text = name;
    _focusNode.unfocus();
    setState(() {});
  }

  Future<void> _saveAndNext() async {
    final db = ref.read(appDatabaseProvider);
    final user = await db.getFirstUser();
    // user가 null이어도 onNext는 호출 — 조용히 실패하지 않음
    if (user != null) {
      final nick = _controller.text.trim().isEmpty
          ? '사용자'
          : _controller.text.trim();
      await db.updateUser(UsersCompanion(
        id: Value(user.id),
        nickname: Value(nick),
        updatedAt: Value(DateTime.now()),
      ));
    }
    if (!mounted) return;
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    final hasInput = _controller.text.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 48, 28, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '03 / 04',
            style: TextStyle(
              fontSize: 11,
              color: GundaColors.grey4,
              letterSpacing: 0.12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),

          // 헤드라인 — 단호하게 한 줄
          const Text(
            '이름을 하나 붙입니다.',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: GundaColors.white,
              height: 1.35,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            '성공도, 실패도 이 이름으로 쌓입니다.',
            style: TextStyle(
              fontSize: 15,
              color: GundaColors.grey3,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 28),

          // 칩 목록 — 셔플 가능
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            transitionBuilder: (child, anim) =>
                FadeTransition(opacity: anim, child: child),
            child: Wrap(
              key: ValueKey(_chipPage),
              spacing: 10,
              runSpacing: 10,
              children: _displayedChips
                  .map((s) => _NickChip(
                        label: s,
                        selected: _controller.text == s,
                        onTap: () => _pickSuggestion(s),
                      ))
                  .toList(),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _shuffleChips,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                '다른 이름 보기 →',
                style: TextStyle(
                  fontSize: 12,
                  color: GundaColors.grey4,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 텍스트필드 — 항상 표시
          TextField(
            controller: _controller,
            focusNode: _focusNode,
            onChanged: (_) => setState(() {}),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: GundaColors.white,
            ),
            cursorColor: GundaColors.green,
            decoration: InputDecoration(
              hintText: '직접 입력',
              hintStyle: const TextStyle(
                color: GundaColors.grey5,
                fontWeight: FontWeight.w400,
                fontSize: 22,
              ),
              filled: false,
              enabledBorder: const UnderlineInputBorder(
                borderSide:
                    BorderSide(color: GundaColors.border),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide:
                    BorderSide(color: GundaColors.green),
              ),
              // 입력된 경우 지우기 버튼
              suffixIcon: hasInput
                  ? GestureDetector(
                      onTap: () {
                        _controller.clear();
                        setState(() {});
                      },
                      child: const Icon(
                        Icons.close,
                        size: 18,
                        color: GundaColors.grey4,
                      ),
                    )
                  : null,
            ),
          ),

          const Spacer(),

          // CTA — 입력 여부에 따라 레이블만 변경, 항상 FilledButton
          FilledButton(
            onPressed: _saveAndNext,
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
            ),
            child: Text(
              hasInput ? '이 이름으로 갑니다' : '아무거나 인정하고 갑니다',
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: _pickRandom,
              child: const Text(
                '아무거나 찍기',
                style: TextStyle(color: GundaColors.grey4),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// 닉네임 칩 — 선택 상태 반영
class _NickChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NickChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(
            horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? GundaColors.greenBg : GundaColors.card,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected
                ? GundaColors.green
                : GundaColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: selected
                ? GundaColors.white
                : GundaColors.grey1,
            fontWeight: selected
                ? FontWeight.w700
                : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// ── 4장: CTA ───────────────────────────────────────────────
// 변경: 대표 프리셋에 "가장 많이 시작한 서약" 태그 추가.
//       금액이 어디로 가는지 한 줄 신뢰 문구 추가.
//       body 카피 교체 ("이런건 한번에" → 직접적 행동 촉구).

class _Page4 extends StatefulWidget {
  final void Function(String? presetLabel) onStart;
  final VoidCallback onSkip;
  const _Page4({required this.onStart, required this.onSkip});

  @override
  State<_Page4> createState() => _Page4State();
}

class _Page4State extends State<_Page4> {
  int? _selected;

  @override
  Widget build(BuildContext context) {
    return _OnboardingLayout(
      tag: '04 / 04',
      title: const Text(
        '그럼 바로,\n하나 걸겠습니다.',
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w900,
          color: GundaColors.white,
          height: 1.3,
          letterSpacing: -0.5,
        ),
      ),
      body: const Text(
        '어기면 당신의 돈은 지인이나 자선단체로 이동합니다.',
        style: TextStyle(
          fontSize: 16,
          color: GundaColors.grey1,
          height: 1.65,
        ),
      ),
      extra: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '지금 바로 시작할 수 있는 서약',
            style: TextStyle(
              fontSize: 12,
              color: GundaColors.grey3,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.1,
            ),
          ),
          const SizedBox(height: 10),
          ...List.generate(_kPresets.length, (i) {
            final isSelected = _selected == i;
            final preset = _kPresets[i];
            return GestureDetector(
              onTap: () => setState(
                  () => _selected = isSelected ? null : i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: isSelected
                      ? GundaColors.greenBg
                      : GundaColors.card,
                  borderRadius: BorderRadius.circular(10),
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
                    // 대표 서약에 태그 표시
                    if (preset.tag != null) ...[
                      Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: GundaColors.green
                              .withValues(alpha: 0.15),
                          borderRadius:
                              BorderRadius.circular(4),
                        ),
                        child: Text(
                          preset.tag!,
                          style: const TextStyle(
                            fontSize: 11,
                            color: GundaColors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            preset.label,
                            style: TextStyle(
                              fontSize: 14,
                              color: isSelected
                                  ? GundaColors.white
                                  : GundaColors.grey1,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          preset.amount,
                          style: TextStyle(
                            fontSize: 13,
                            color: isSelected
                                ? GundaColors.green
                                : GundaColors.grey3,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (isSelected) ...[
                          const SizedBox(width: 6),
                          const Icon(Icons.check_circle,
                              size: 16,
                              color: GundaColors.green),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
      primaryLabel: _selected == null
          ? '직접 걸어 봅니다'
          : '이걸로 겁니다',
      onPrimary: () => widget.onStart(
          _selected != null
              ? _kPresets[_selected!].routeValue
              : null),
      ghostLabel: '일단 넘어가기',
      onGhost: widget.onSkip,
    );
  }
}