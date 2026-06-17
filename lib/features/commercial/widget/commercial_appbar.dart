import 'package:flutter/material.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/shared/button/custom_button.dart';

class CommercialAppBar extends StatelessWidget {
  final String title;
  final String subtitle;

  const CommercialAppBar({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          CustomBackButton(),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: text18(fontWeight: FontWeight.bold)),
                Text(subtitle, style: text12(color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
