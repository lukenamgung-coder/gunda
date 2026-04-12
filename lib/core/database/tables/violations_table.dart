import 'package:drift/drift.dart';
import 'vows_table.dart';
import 'verifications_table.dart';

/// 위반 및 카카오페이 납부 추적 테이블
class Violations extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get vowId =>
      integer().references(Vows, #id)();
  IntColumn get verificationId =>
      integer().references(Verifications, #id)();

  DateTimeColumn get violatedAt => dateTime()();

  /// 해당 위반의 부과 벌금 (원)
  IntColumn get penaltyAmount => integer()();

  /// PaymentStatus.name 문자열
  /// (pending | processing | completed | failed)
  TextColumn get paymentStatus =>
      text().withDefault(const Constant('pending'))();

  /// 카카오페이 거래 고유 ID (TID)
  TextColumn get kakaoTid => text().nullable()();

  /// 카카오페이 결제 승인 ID
  TextColumn get kakaoApprovalUrl => text().nullable()();

  TextColumn get paymentErrorMessage => text().nullable()();

  DateTimeColumn get paidAt => dateTime().nullable()();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}
