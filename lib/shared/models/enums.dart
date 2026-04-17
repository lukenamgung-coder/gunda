/// 서약 유형
enum VowType {
  screenTime, // 스크린 타임 제한
  sleep,      // 수면 시간 확보
  steps,      // 걸음수 달성
  exercise,   // 운동 시간 확보
  delivery,   // 배달음식 제한 (배민/쿠팡이츠/요기요)
  game,       // 게임 시간 제한
  custom,     // 직접 설정
}

/// 계약 생명주기 상태 (DB: TextColumn, stored as .name)
enum VowStatus {
  active,    // 진행 중
  paused,    // 일시 중지
  completed, // 성공 완료
  violated,  // 위반으로 종료
}

/// @deprecated Use VowStatus. Kept for backward-compatibility with
/// legacy Drift table comments referencing 'PledgeStatus'.
typedef PledgeStatus = VowStatus;

/// 검증 조건 연산자
enum ConditionOperator {
  lte, // ≤  (스크린타임: 이하)
  gte, // ≥  (수면·걸음수: 이상)
  eq,  // =
}

/// 카카오페이 납부 상태
enum PaymentStatus {
  pending,    // 납부 대기
  processing, // 처리 중
  completed,  // 납부 완료
  failed,     // 납부 실패
}
