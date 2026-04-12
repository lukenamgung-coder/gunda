import 'package:drift/drift.dart';
import 'vows_table.dart';

/// 일일 검증 결과 테이블
class Verifications extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get vowId =>
      integer().references(Vows, #id)();

  /// 검증 대상 날짜 (당일 자정 기준)
  DateTimeColumn get targetDate => dateTime()();

  /// 실제 검증 수행 시각
  DateTimeColumn get verifiedAt => dateTime()();

  BoolColumn get isPassed => boolean()();

  /// 측정된 실제 값 JSON (예: {"steps": 8500, "duration_min": 0})
  TextColumn get measuredDataJson => text().nullable()();

  /// 수동 메모
  TextColumn get notes => text().nullable()();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}
