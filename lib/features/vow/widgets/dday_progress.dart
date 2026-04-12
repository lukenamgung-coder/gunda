import 'package:flutter/material.dart';

import '../../../domain/models/date_range.dart';
import '../../../shared/theme/app_theme.dart';

/// Thin progress strip showing elapsed/remaining contract days.
///
/// All date arithmetic is delegated to [ContractDateRange].
class DDayProgress extends StatelessWidget {
  final ContractDateRange period;

  const DDayProgress({super.key, required this.period});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: GundaColors.card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: GundaColors.border),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_fmt(period.start),
                  style: const TextStyle(
                      fontSize: 11, color: GundaColors.grey3)),
              Text('D-${period.daysLeft}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: GundaColors.white,
                  )),
              Text(_fmt(period.end),
                  style: const TextStyle(
                      fontSize: 11, color: GundaColors.grey3)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: period.progressRatio,
              minHeight: 3,
              backgroundColor: GundaColors.grey6,
              color: GundaColors.green,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${period.elapsedDays}일 경과 / 총 ${period.totalDays}일',
            style: const TextStyle(
                fontSize: 11, color: GundaColors.grey3),
          ),
        ],
      ),
    );
  }

  static String _fmt(DateTime d) =>
      '${d.year}.${d.month.toString().padLeft(2, '0')}.${d.day.toString().padLeft(2, '0')}';
}
