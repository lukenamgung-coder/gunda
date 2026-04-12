import 'package:drift/drift.dart';
import 'users_table.dart';

/// 서약(Vow) 테이블
class Vows extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();

  TextColumn get title => text().withLength(min: 1, max: 100)();
  TextColumn get description => text().nullable()();

  /// PledgeType.name 문자열 저장
  /// (screenTime | sleep | steps | exercise | custom)
  TextColumn get pledgeType => text()();

  /// PledgeStatus.name 문자열 저장
  TextColumn get status =>
      text().withDefault(const Constant('active'))();

  /// PledgeCondition JSON 문자열
  TextColumn get conditionJson => text()();

  // ── 제재 설정 ──────────────────────────────────────────
  /// 위반 1회당 벌금 (원)
  IntColumn get penaltyAmount => integer()();

  /// 기부 단체명 또는 지인 이름 (null = 미설정)
  TextColumn get penaltyRecipient => text().nullable()();

  // ── 일정 ───────────────────────────────────────────────
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();

  /// 검증 주기 (일 단위, 1 = 매일)
  IntColumn get verificationIntervalDays =>
      integer().withDefault(const Constant(1))();

  // ── 누적 통계 ──────────────────────────────────────────
  IntColumn get totalVerifications =>
      integer().withDefault(const Constant(0))();
  IntColumn get passedVerifications =>
      integer().withDefault(const Constant(0))();

  /// 누적 납부 벌금 총액 (원)
  IntColumn get totalFinesPaid =>
      integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
}
