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
}

// ── DB 연결 ──────────────────────────────────────────────────

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'gunda.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
