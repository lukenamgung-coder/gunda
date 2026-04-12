import 'package:flutter/material.dart';

import '../../../shared/models/enums.dart';
import '../../../shared/theme/app_theme.dart';

/// Bottom action bar — communicates the verification state honestly.
///
/// Shows a disabled "검증 준비 중" when verification is not yet
/// implemented, rather than a fake working button.
class PrimaryCTA extends StatelessWidget {
  final VowStatus status;

  const PrimaryCTA({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    if (status != VowStatus.active) return const SizedBox.shrink();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '검증 기능이 곧 준비됩니다',
              style: TextStyle(fontSize: 11, color: GundaColors.grey4),
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(
                onPressed: null,
                style: FilledButton.styleFrom(
                  disabledBackgroundColor: GundaColors.grey6,
                  disabledForegroundColor: GundaColors.grey3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.verified_outlined, size: 18),
                label: const Text('검증 준비 중',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
