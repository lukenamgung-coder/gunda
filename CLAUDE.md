# 건다 (Gunda) — 프로젝트 컨텍스트

## 앱 개요
- 이름: 건다 / Gunda
- 슬로건: 돈은 말보다 무겁기에
- 목적: 스스로 설정한 행동 서약을 기기 데이터로 자동 검증하고, 위반 시 실제 돈을 지인이나 기부단체로 송금하여 제재를 실행하는 자기 규율 앱
- 플랫폼: Android 우선 (Flutter 3.x)
- 패키지명: com.gunda.app

## 브랜드
- 컬러: 흑백 미니멀 베이스. 달성 #1D9E75 (초록), 위반 #E24B4A (빨강)
- 컬러는 달성/위반 상태에만 사용. 나머지 UI는 무채색
- 타이포그래피: 한글 고딕 900 weight 중심
- Material `Colors.*` 사용 금지 — 항상 `GundaColors.*` 사용

## 서약 카테고리 (7가지)
| 카테고리 | PledgeType | 검증 방법 | 비고 |
|---------|-----------|---------|-----|
| 디지털 디톡스 | screenTime | UsageStatsManager | 앱별 시간대/한도 |
| 게임 | game | UsageStatsManager + PackageManager | 게임 앱 자동 감지 |
| 배달음식 | delivery | UsageStatsManager | 배민/쿠팡이츠/요기요 고정 |
| 걸음수 | steps | Health Connect StepsRecord | 하루 목표 걸음수 |
| 수면 | sleep | Health Connect SleepSession | 취침 시각, 최소 수면 시간 |
| 운동 | exercise | Health Connect | 운동 시간 확보 |
| 자유 입력 | custom | 없음 | 양심 전용 모드, 매일 자정 전 수동 체크, 미체크 시 위반 처리 |

## 화면 구조 (5개)

### 1. 온보딩 (4장)
- 1장: 훅 카피 + "시작하기" / "일단 둘러보기" 버튼
- 2장: "돈은 말보다 무겁습니다." + 작동 원리 3줄
- 3장: 닉네임 선택 (칩 12개 + 직접 입력)
- 4장: 프리셋 서약 선택 3개 + "직접 걸어 봅니다"
- 완료 시 `SharedPreferences['onboarding_done'] = true`

### 2. 홈
- 활성 서약 카드 목록
- 서약별 개별 스트릭 (앱 전체 통합 스트릭 없음)
- 진행률 표시: "23일 중 18일" 형식 (경과일 기준)
- 위반 카드는 앱 진입 시 fold 애니메이션으로 접힘
- 접힌 상태에서도 "위반 N건 / 서약명"은 보임
- 상단 우측 + 버튼으로 서약 만들기 진입

### 3. 서약 만들기 (5단계, 내부 step 0~4)
- step 0: 카테고리 선택 — 구현 완료 타입 상단(디지털/배달/게임), 준비 중 타입 하단(수면/걸음수/운동), 자유입력 전폭 하단
- step 1: 세부 조건 (카테고리별 분기)
  - 디지털 디톡스: 프리셋 앱 2×2 그리드 + 다른 앱 선택 + 하루 한도 칩 + 시간대 금지 (인라인 범위 피커)
  - 게임: PackageManager로 불러온 게임 목록 + 한도
  - 배달음식: 배민/쿠팡이츠/요기요 고정, 완전 금지 또는 횟수 제한
  - 걸음수/수면/운동: `_SimpleConditionChips`로 옵션 선택
  - 자유 입력: 제목 입력 + 양심 안내
- step 2: 기간 프리셋(3/7/14/30/60/90일) + 위반 1회당 제재금 프리셋
- step 3: 수취인 선택 (지인 연락처 — 기부처는 출시 예정)
- step 4: 행동서약서 전체 요약 + 동의 체크박스 + 길게 눌러 서약 체결 버튼
- 마지막 버튼 텍스트: "서약을 겁니다"
- 서약 시작 후 취소 불가 안내 필수

### 4. 서약 상세 (VowDetailScreen)
- 고긴장 재무 집행 계약 대시보드 스타일
- RiskDashboard: SAFE / WARNING / DANGER + 잔여 여유량
- DDayProgress: 계약 기간 진행률
- EnforcerSection: 집행자 이름·관계·연락 버튼
- ContractTermsSection: 조건/기간/벌금 3개 조항
- ViolationTimeline: 스트릭 헤더 + 위반 이벤트 카드 (카카오페이 납부 CTA 포함)

### 5. 설정
- UsageStats 권한 상태 + 설정 이동 버튼
- Health Connect 권한 상태 + 설정 이동 버튼
- 연동된 앱 목록 확인

---

## 아키텍처 (Clean Architecture — 4 레이어)

```
lib/
├── domain/          # 순수 Dart. 프레임워크 의존 없음
│   ├── models/      # ContractVow, ContractTerms, Enforcer, Money,
│   │                  DomainViolation, BehavioralInsight, VowStats,
│   │                  ContractDateRange
│   └── risk/        # RiskLevel, RiskSnapshot, RiskEvaluator
├── application/
│   ├── repositories/   # VowRepository (인터페이스)
│   └── use_cases/      # GetVowDetail, ObserveViolations, PauseVow,
│                         ComputeBehavioralInsight, EvaluateRisk
├── infrastructure/
│   └── drift/       # DriftVowRepository (DB 어댑터)
├── features/        # 화면 + 위젯 + providers
│   ├── home/
│   ├── vow/
│   │   ├── providers/   # vow_detail_providers.dart
│   │   └── widgets/     # risk_dashboard, dday_progress, enforcer_section,
│   │                      contract_terms_section, violation_timeline, primary_cta
│   ├── onboarding/
│   ├── settings/
│   └── splash/
├── core/
│   ├── database/    # AppDatabase (Drift), 테이블 정의
│   ├── providers/   # appDatabaseProvider
│   ├── router/
│   └── services/
└── shared/
    ├── models/      # enums.dart, PledgeCondition
    └── theme/       # GundaColors, AppTheme
```

**규칙:**
- 위젯은 domain 객체만 받는다. raw DB row, JSON 파싱, 비즈니스 로직 없음
- 집행자 파싱: `Enforcer.fromStorageString(raw)` — 위젯에서 직접 `|` 분리 금지
- `Colors.*` 금지 — `GundaColors.*` 전용

---

## DB 스키마 (Drift)

### vows 테이블
| 컬럼 | 타입 | 설명 |
|------|------|------|
| id | int PK | |
| userId | int FK→users | |
| title | text(1~100) | |
| description | text? | |
| pledgeType | text | PledgeType.name |
| status | text | VowStatus.name (default: 'active') |
| conditionJson | text | PledgeCondition JSON |
| penaltyAmount | int | 위반 1회당 벌금 (원) |
| penaltyRecipient | text? | `"이름\|전화번호\|관계"` 형식 |
| startDate | datetime | |
| endDate | datetime | |
| verificationIntervalDays | int | 검증 주기 (default: 1) |
| totalVerifications | int | 누적 검증 횟수 (default: 0) |
| passedVerifications | int | 누적 달성 횟수 (default: 0) |
| totalFinesPaid | int | 누적 납부 벌금 총액 원 (default: 0) |
| createdAt | datetime | |
| updatedAt | datetime | |

> `penaltyRecipient` 파싱: `Enforcer.fromStorageString(raw)` — `parts[0]=이름, parts[1]=전화번호, parts[2]=관계`

### verifications 테이블
- id, vowId, targetDate, verifiedAt
- isPassed (bool), measuredDataJson (실측값 JSON), notes
- createdAt
- **역할**: 검증 실행 이력 전체 (달성/실패 모두). isPassed=true인 행이 달성 기록.

> achievements 테이블 없음 — `verifications WHERE isPassed=true`로 달성 일수 집계.

### violations 테이블
- id, vowId, verificationId
- violatedAt, penaltyAmount
- paymentStatus: `PaymentStatus.name` (pending/processing/completed/failed)
- kakaoTid, kakaoApprovalUrl, paymentErrorMessage, paidAt
- createdAt

---

## 핵심 도메인 모델

| 클래스 | 역할 |
|--------|------|
| `ContractVow` | 서약 aggregate root |
| `ContractTerms` | 조건(PledgeCondition) + 기간(ContractDateRange) + 벌금(Money) |
| `Enforcer` | 집행자 값 객체. `fromStorageString()`으로 파싱, `toStorageString()`으로 저장 |
| `Money` | 금액 값 객체. `formatted` → "10,000원" |
| `ContractDateRange` | 날짜 범위. `elapsedDays`, `daysLeft`, `progressRatio`, `summaryLabel` |
| `DomainViolation` | 위반 이벤트. `isPending`, `isPaid` |
| `BehavioralInsight` | 스트릭 + 트렌드. `streakLabel`, `lastViolationLabel` |
| `RiskSnapshot` | 리스크 스냅샷. `RiskLevel` (safe/warning/danger), `hasLiveData` |
| `PledgeCondition` | 서약 조건 JSON 모델. `type`, `targetValue`, `targetApps`, `windowStartHour/EndHour` |

---

## 기술 결정사항

### UsageStatsManager
- `app_usage: ^4.1.0` 패키지 사용
- 세밀한 제어 필요 시 MethodChannel 직접 구현
- getAppUsageToday(packageName) → 오늘 사용 시간(분)
- getLastUsedTime(packageName) → 마지막 사용 시각
- checkPermission() → 권한 허용 여부

### PackageManager (게임 감지)
- MethodChannel로 구현
- CATEGORY_GAME 또는 FLAG_IS_GAME 필터링
- 결과: [{packageName, appName}] 반환

### Health Connect
- `health: ^13.3.1` 패키지
- Android 14 미만 별도 앱 설치 필요 → 온보딩 안내 필수
- StepsRecord: 오늘 걸음수
- SleepSessionRecord: 어젯밤 총 수면 시간(분)

### 카카오페이 제재
- `kakao_flutter_sdk_user: ^2.0.0+1`, `webview_flutter: ^4.10.0`, `app_links: ^7.0.0`
- `url_launcher: ^6.3.0`으로 딥링크 실행
- 송금 완료 여부 수신 불가 → "링크 열림 = 이행 의사"로 처리
- 위반 감지 시 카카오톡으로 수취인에게 먼저 알림 발송
- 알림 내용: "OO님이 서약을 어겨 N원을 보낼 예정입니다."

#### 카카오 SDK 현황
- **main.dart**: `KakaoSdk.init()` 호출 시 `'YOUR_KAKAO_NATIVE_APP_KEY'` 플레이스홀더 → 반드시 교체
- **AndroidManifest.xml**: `KAKAO_NATIVE_APP_KEY` 플레이스홀더 → 반드시 교체
- 딥링크 콜백 핸들러(`gunda://kakaopay?violationId=X`) 구현 완료
- 실제 결제 요청 UI (WebView/SDK 호출) 미구현

### 백그라운드 검증
- AlarmManager.setExact() + ForegroundService (WorkManager 아님) 로 자정 실행
- `PledgeMonitorService.kt` — 원시 SQLite 직접 접근 (Drift는 background isolate 불가)
- `VerificationAlarmReceiver.kt` — BroadcastReceiver, 서비스 시작
- `BootReceiver.kt` — 재부팅 후 알람 재등록
- 카테고리별 검증 로직 분기

#### 검증 구현 현황
| 타입 | 상태 | 비고 |
|------|------|------|
| screenTime | ✅ 구현 완료 | 하루 한도 검증 |
| game | ✅ 구현 완료 | 하루 한도 검증 |
| delivery | ✅ 구현 완료 | 배민/쿠팡이츠/요기요 3개 고정 |
| steps | ❌ 미구현 | else→true (자동 통과), Health Connect 미연결 |
| sleep | ❌ 미구현 | else→true (자동 통과), Health Connect 미연결 |
| exercise | ❌ 미구현 | else→true (자동 통과), Health Connect 미연결 |
| custom | ⚠️ 자동 위반 | 항상 false 반환, 수동 체크 UI 미구현 |

**알려진 버그**: `checkWindowOnly()` 함수는 항상 `true`를 반환 (레트로액티브 UsageEvents 조회 불가 문제). 시간대 제한 조건은 현재 집행되지 않음.

### 리스크 평가
- `EvaluateRisk(RiskEvaluator)` use case
- screenTime/game: 실시간 사용량 기반 SAFE/WARNING/DANGER 계산
- 나머지 타입: `hasLiveData=false`로 "검증 데이터 없음" 표시
- `riskSnapshotProvider`: `FutureProvider.family<RiskSnapshot, ContractTerms>`

---

## 의존성 (pubspec.yaml)

| 패키지 | 버전 | 용도 |
|--------|------|------|
| flutter_riverpod | ^3.1.0 | 상태관리 |
| riverpod_annotation | ^4.0.0 | 코드젠 |
| go_router | ^17.2.0 | 라우팅 |
| drift | ^2.22.1 | 로컬 DB |
| sqlite3_flutter_libs | ^0.5.0 | SQLite |
| app_usage | ^4.1.0 | UsageStats |
| health | ^13.3.1 | Health Connect |
| kakao_flutter_sdk_user | ^2.0.0+1 | 카카오 로그인 |
| app_links | ^7.0.0 | KakaoPay 딥링크 콜백 |
| webview_flutter | ^4.10.0 | KakaoPay 결제창 |
| flutter_local_notifications | ^18.0.1 | 로컬 알림 |
| url_launcher | ^6.3.0 | tel: 딥링크, KakaoPay |
| flutter_contacts | ^1.1.9+2 | 연락처 선택 |
| shared_preferences | ^2.3.0 | 간단한 설정 저장 |
| permission_handler | ^12.0.0+1 | Android 권한 |
| intl | ^0.20.2 | 날짜/숫자 포맷 |
| uuid | ^4.5.1 | UUID 생성 |
| freezed_annotation | ^3.1.0 | 코드젠 |
| json_annotation | ^4.9.0 | JSON 코드젠 |

---

## 수익 모델
- 서약 생성 시 소액 수수료
- 수취인(지인/기부처) 선택 가능
- 기부처는 사전 제휴처 목록에서 선택

## 개발 스프린트
- Sprint 1 (완료): 프로젝트 셋업, MethodChannel, Health Connect, DB 스키마, Clean Architecture 레이어 분리
- Sprint 2 (완료): 서약 상세 화면 (고긴장 대시보드), 위반 타임라인, 리스크 평가, BehavioralInsight, 서약 만들기 4단계
- Sprint 3 (완료): 백그라운드 검증 엔진(screenTime/game/delivery), 위반 감지 로직, 푸시 알림, 카카오페이 딥링크 콜백, 온보딩 UI
- Sprint 4 (진행 중): UX QA, Play Store 내부 테스트 배포 준비

## 디버그 도구
- 설정 화면 하단 **"개발자 도구"** 섹션 (`kDebugMode`에서만 표시)
- **위반 시나리오 시딩**: 테스트용 위반 서약 생성 후 상세 화면으로 직접 이동
  - `AppDatabase.seedTestViolation()` — 서약 + 검증 이력 + 위반 2건(완료/대기) 삽입
  - conditionJson 필수 필드: `type`, `targetValue`, `unit`, `operator` 모두 포함 필수
