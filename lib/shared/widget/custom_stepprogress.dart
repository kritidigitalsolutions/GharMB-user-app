import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/theme/text_style.dart';

class StepProgress extends StatelessWidget {
  final int current;
  final int total;

  const StepProgress({super.key, required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Step $current of $total',
          style: text12(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: current / total,
            minHeight: 4,
            backgroundColor: AppColors.grey200,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
