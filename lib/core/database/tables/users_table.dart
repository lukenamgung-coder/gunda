import 'package:drift/drift.dart';

/// 사용자 테이블 (현재는 단일 사용자, 카카오 계정 연동 정보 보관)
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// 카카오 고유 ID (연동 전 null)
  TextColumn get kakaoId => text().nullable()();

  /// 카카오 액세스 토큰 (KakaoPay 결제에 사용)
  TextColumn get accessToken => text().nullable()();

  TextColumn get nickname =>
      text().withDefault(const Constant('사용자'))();
  TextColumn get profileImageUrl => text().nullable()();

  IntColumn get totalPledges =>
      integer().withDefault(const Constant(0))();
  IntColumn get successPledges =>
      integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
}
