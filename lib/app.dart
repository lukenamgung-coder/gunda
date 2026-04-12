import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/router/deeplink_service.dart';
import 'features/vow/providers/vow_detail_providers.dart';
import 'shared/models/enums.dart';
import 'shared/theme/app_theme.dart';

class GundaApp extends ConsumerWidget {
  const GundaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    // Handle gunda:// deep-links
    ref.listen(deepLinkProvider, (_, next) {
      next.whenData((uri) {
        if (uri == null) return;
        _handleDeepLink(ref, uri);
      });
    });

    return MaterialApp.router(
      title: '건다',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }

  void _handleDeepLink(WidgetRef ref, Uri uri) {
    if (uri.host == 'kakaopay') {
      final violationIdStr = uri.queryParameters['violationId'];
      final violationId = int.tryParse(violationIdStr ?? '');
      if (violationId != null) {
        ref.read(updatePaymentStatusProvider)(
          violationId,
          PaymentStatus.completed,
        );
      }
    }
  }
}
