import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import 'app.dart';
import 'core/services/notification_service.dart';
import 'core/services/verification_schedule_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 세로 방향 고정
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // 상태바 투명 처리
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // 알림 채널 초기화
  await NotificationService.instance.init();

  // 서약별 검증 알람 등록 (활성 서약마다 개별 알람)
  await VerificationScheduleService.scheduleAllVows();

  // Kakao SDK 초기화
  // TODO: Kakao Developers에서 발급받은 앱 키로 교체하세요
  // https://developers.kakao.com → 내 애플리케이션 → 앱 키
  KakaoSdk.init(
    nativeAppKey: 'YOUR_KAKAO_NATIVE_APP_KEY',
    javaScriptAppKey: 'YOUR_KAKAO_JS_APP_KEY',
  );

  runApp(
    const ProviderScope(
      child: GundaApp(),
    ),
  );
}
