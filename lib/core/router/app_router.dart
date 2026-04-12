import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/splash/splash_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/vow/create_vow_screen.dart';
import '../../features/vow/vow_detail_screen.dart';
import '../../features/settings/settings_screen.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (_, _) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (_, _) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (_, _) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'vow/create',
            name: 'vow-create',
            builder: (_, _) => const CreateVowScreen(),
          ),
          GoRoute(
            path: 'vow/:id',
            name: 'vow-detail',
            builder: (context, state) {
              final id =
                  int.parse(state.pathParameters['id']!);
              return VowDetailScreen(vowId: id);
            },
          ),
          GoRoute(
            path: 'settings',
            name: 'settings',
            builder: (_, _) => const SettingsScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('페이지를 찾을 수 없습니다: ${state.uri}'),
      ),
    ),
  );
}
