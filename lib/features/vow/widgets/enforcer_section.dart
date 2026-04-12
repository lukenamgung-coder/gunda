import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../domain/models/enforcer.dart';
import '../../../domain/models/money.dart';
import '../../../shared/theme/app_theme.dart';

/// Displays the enforcer (집행자) with psychological emphasis.
///
/// The enforcer is the person who benefits from the user's failure.
/// This card uses dark red tones and italic copy to make that real.
class EnforcerSection extends StatelessWidget {
  final Enforcer enforcer;
  final Money penalty;

  const EnforcerSection({
    super.key,
    required this.enforcer,
    required this.penalty,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A0E0E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF4A2020)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '집행자',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: GundaColors.grey3,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: enforcer.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: GundaColors.white,
                            ),
                          ),
                          if (enforcer.relationship.isNotEmpty)
                            TextSpan(
                              text: '  (${enforcer.relationship})',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: GundaColors.grey2,
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (enforcer.hasPhone) ...[
                      const SizedBox(height: 3),
                      Text(enforcer.phone,
                          style: const TextStyle(
                              fontSize: 12, color: GundaColors.grey3)),
                    ],
                  ],
                ),
              ),
              if (enforcer.hasPhone) _CallButton(phone: enforcer.phone),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '당신이 실패하면 이 사람이 ${penalty.formatted}을 받습니다.',
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xB3E24B4A), // red ~70%
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class _CallButton extends StatelessWidget {
  final String phone;

  const _CallButton({required this.phone});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => launchUrl(
        Uri.parse('tel:${phone.replaceAll(RegExp(r'[\s\-]'), '')}'),
        mode: LaunchMode.externalApplication,
      ),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF2A1515),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF5A2525)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.phone_outlined, size: 13, color: GundaColors.red),
            SizedBox(width: 5),
            Text('연락하기',
                style: TextStyle(
                  fontSize: 12,
                  color: GundaColors.red,
                  fontWeight: FontWeight.w600,
                )),
          ],
        ),
      ),
    );
  }
}
