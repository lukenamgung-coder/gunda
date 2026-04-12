import 'package:flutter/material.dart';

import '../../../domain/models/contract_terms.dart';
import '../../../shared/theme/app_theme.dart';

/// Three-clause legal summary of the contract.
///
/// Receives [ContractTerms] — no raw DB fields, no string parsing.
class ContractTermsSection extends StatelessWidget {
  final ContractTerms terms;

  const ContractTermsSection({super.key, required this.terms});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GundaColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: GundaColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '계약 조항',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: GundaColors.grey3,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: GundaColors.border),
          const SizedBox(height: 14),
          _ClauseRow(
            index: '제1조',
            label: '조건',
            text: terms.condition.toDisplayString(),
          ),
          const SizedBox(height: 12),
          _ClauseRow(
            index: '제2조',
            label: '기간',
            text: terms.period.summaryLabel,
          ),
          const SizedBox(height: 12),
          _ClauseRow(
            index: '제3조',
            label: '벌금',
            text: '위반 시 ${terms.penalty.formatted} 즉시 송금',
            highlight: true,
          ),
        ],
      ),
    );
  }
}

class _ClauseRow extends StatelessWidget {
  final String index;
  final String label;
  final String text;
  final bool highlight;

  const _ClauseRow({
    required this.index,
    required this.label,
    required this.text,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 46,
          child: Text(index,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: GundaColors.grey4,
                letterSpacing: 0.3,
              )),
        ),
        SizedBox(
          width: 32,
          child: Text(label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: GundaColors.grey3,
              )),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: highlight ? GundaColors.red : GundaColors.grey1,
              fontWeight:
                  highlight ? FontWeight.w600 : FontWeight.w400,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
