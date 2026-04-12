import '../../shared/models/enums.dart';
import 'money.dart';

/// A single violation event — a contract was broken on this day.
///
/// Named DomainViolation to avoid collision with the Drift-generated
/// `Violation` class from the database layer.
class DomainViolation {
  final int id;
  final DateTime violatedAt;
  final Money penalty;
  final PaymentStatus paymentStatus;

  const DomainViolation({
    required this.id,
    required this.violatedAt,
    required this.penalty,
    required this.paymentStatus,
  });

  bool get isPending => paymentStatus == PaymentStatus.pending;
  bool get isProcessing => paymentStatus == PaymentStatus.processing;
  bool get isPaid => paymentStatus == PaymentStatus.completed;
  bool get isFailed => paymentStatus == PaymentStatus.failed;

  /// Korean: "납부 완료" / "납부 대기" / etc.
  String get paymentStatusLabel => switch (paymentStatus) {
        PaymentStatus.completed => '납부 완료',
        PaymentStatus.processing => '처리 중',
        PaymentStatus.failed => '납부 실패',
        PaymentStatus.pending => '납부 대기',
      };

  @override
  bool operator ==(Object other) =>
      other is DomainViolation &&
      id == other.id &&
      paymentStatus == other.paymentStatus;

  @override
  int get hashCode => Object.hash(id, paymentStatus);
}
