import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables/users_table.dart';
import 'tables/vows_table.dart';
import 'tables/verifications_table.dart';
import 'tables/violations_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Users, Vows, Verifications, Violations],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          // 최초 실행 시 기본 사용자 생성
          await into(users).insert(
            const UsersCompanion(nickname: Value('사용자')),
          );
        },
      );

  // ── Users ────────────────────────────────────────────────

  Future<User?> getFirstUser() =>
      (select(users)..limit(1)).getSingleOrNull();

  Stream<User?> watchFirstUser() =>
      (select(users)..limit(1)).watchSingleOrNull();

  Future<bool> updateUser(UsersCompanion user) =>
      update(users).replace(user);

  // ── Vows ─────────────────────────────────────────────────

  Stream<List<Vow>> watchVows(int userId) {
    return (select(vows)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  Stream<List<Vow>> watchActiveVows(int userId) {
    return (select(vows)
          ..where(
            (t) =>
                t.userId.equals(userId) &
                t.status.equals('active'),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  Stream<Vow?> watchVowById(int id) {
    return (select(vows)..where((t) => t.id.equals(id)))
        .watchSingleOrNull();
  }

  Future<Vow?> getVowById(int id) =>
      (select(vows)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<int> insertVow(VowsCompanion vow) =>
      into(vows).insert(vow);

  Future<bool> updateVow(VowsCompanion vow) =>
      update(vows).replace(vow);

  Future<void> deleteVow(int id) async {
    // violations → verifications → vow 순서로 cascade 삭제
    await (delete(violations)
          ..where((v) => v.vowId.equals(id)))
        .go();
    await (delete(verifications)
          ..where((v) => v.vowId.equals(id)))
        .go();
    await (delete(vows)..where((t) => t.id.equals(id))).go();
  }

  Future<void> updateVowStatus(int id, String status) async {
    await (update(vows)..where((t) => t.id.equals(id)))
        .write(VowsCompanion(status: Value(status)));
  }

  Future<void> incrementVowStats({
    required int vowId,
    required bool passed,
    int fineAmount = 0,
  }) async {
    final vow = await getVowById(vowId);
    if (vow == null) return;
    await (update(vows)..where((t) => t.id.equals(vowId)))
        .write(VowsCompanion(
      totalVerifications:
          Value(vow.totalVerifications + 1),
      passedVerifications: Value(
        vow.passedVerifications + (passed ? 1 : 0),
      ),
      totalFinesPaid:
          Value(vow.totalFinesPaid + fineAmount),
      updatedAt: Value(DateTime.now()),
    ));
  }

  // ── Verifications ────────────────────────────────────────

  Future<Verification?> getVerificationForDate(
    int vowId,
    DateTime date,
  ) {
    final start =
        DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    return (select(verifications)
          ..where(
            (v) =>
                v.vowId.equals(vowId) &
                v.targetDate.isBiggerOrEqualValue(start) &
                v.targetDate.isSmallerThanValue(end),
          ))
        .getSingleOrNull();
  }

  Stream<List<Verification>> watchVerificationsForVow(
      int vowId) {
    return (select(verifications)
          ..where((v) => v.vowId.equals(vowId))
          ..orderBy(
              [(v) => OrderingTerm.desc(v.targetDate)]))
        .watch();
  }

  Future<int> insertVerification(
          VerificationsCompanion v) =>
      into(verifications).insert(v);

  // ── Violations ───────────────────────────────────────────

  Stream<List<Violation>> watchViolations(int vowId) {
    return (select(violations)
          ..where((v) => v.vowId.equals(vowId))
          ..orderBy(
              [(v) => OrderingTerm.desc(v.violatedAt)]))
        .watch();
  }

  Future<List<Violation>> getPendingViolations() {
    return (select(violations)
          ..where(
              (v) => v.paymentStatus.equals('pending')))
        .get();
  }

  Future<int> insertViolation(ViolationsCompanion v) =>
      into(violations).insert(v);

  Future<void> updateViolationPayment({
    required int violationId,
    required String status,
    String? kakaoTid,
    String? errorMessage,
    DateTime? paidAt,
  }) async {
    await (update(violations)
          ..where((v) => v.id.equals(violationId)))
        .write(ViolationsCompanion(
      paymentStatus: Value(status),
      kakaoTid: Value(kakaoTid),
      paymentErrorMessage: Value(errorMessage),
      paidAt: Value(paidAt),
    ));
  }

  // ── 개발용: 위반 시나리오 시딩 ──────────────────────────────
  /// 테스트용 위반 서약을 생성하고 vowId를 반환합니다.
  /// kDebugMode에서만 호출하십시오.
  Future<int> seedTestViolation() async {
    final user = await getFirstUser();
    final userId = user?.id ?? 1;
    final now = DateTime.now();

    // 서약 생성 (10일 전 시작, 오늘 기준 violated 상태)
    final vowId = await into(vows).insert(VowsCompanion(
      userId: Value(userId),
      title: const Value('유튜브 하루 1시간'),
      pledgeType: const Value('screenTime'),
      status: const Value('violated'),
      conditionJson: const Value(
          '{"type":"screenTime","targetValue":60.0,"unit":"분","operator":"lte","targetApps":["com.google.android.youtube"],"hasDurationLimit":true}'),
      penaltyAmount: const Value(10000),
      penaltyRecipient: const Value('김철수|01012345678|친구'),
      startDate: Value(now.subtract(const Duration(days: 10))),
      endDate: Value(now.add(const Duration(days: 20))),
      totalVerifications: const Value(10),
      passedVerifications: const Value(7),
      createdAt: Value(now.subtract(const Duration(days: 10))),
      updatedAt: Value(now),
    ));

    // 검증 기록 3건 (실패 포함)
    final ver1Id = await into(verifications).insert(VerificationsCompanion(
      vowId: Value(vowId),
      targetDate: Value(now.subtract(const Duration(days: 3))),
      verifiedAt: Value(now.subtract(const Duration(days: 3))),
      isPassed: const Value(false),
      measuredDataJson: const Value('{"duration_min":95}'),
    ));
    final ver2Id = await into(verifications).insert(VerificationsCompanion(
      vowId: Value(vowId),
      targetDate: Value(now.subtract(const Duration(days: 1))),
      verifiedAt: Value(now.subtract(const Duration(days: 1))),
      isPassed: const Value(false),
      measuredDataJson: const Value('{"duration_min":130}'),
    ));
    await into(verifications).insert(VerificationsCompanion(
      vowId: Value(vowId),
      targetDate: Value(now),
      verifiedAt: Value(now),
      isPassed: const Value(true),
      measuredDataJson: const Value('{"duration_min":42}'),
    ));

    // 위반 2건 — 1건 납부 완료, 1건 납부 대기
    await into(violations).insert(ViolationsCompanion(
      vowId: Value(vowId),
      verificationId: Value(ver1Id),
      violatedAt: Value(now.subtract(const Duration(days: 3))),
      penaltyAmount: const Value(10000),
      paymentStatus: const Value('completed'),
      paidAt: Value(now.subtract(const Duration(days: 2))),
    ));
    await into(violations).insert(ViolationsCompanion(
      vowId: Value(vowId),
      verificationId: Value(ver2Id),
      violatedAt: Value(now.subtract(const Duration(days: 1))),
      penaltyAmount: const Value(10000),
      paymentStatus: const Value('pending'),
    ));

    return vowId;
  }
}

// ── DB 연결 ──────────────────────────────────────────────────

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'gunda.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
