import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';

class HelpRow extends StatelessWidget {
  const HelpRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Need Help?', style: text12(fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _HelpBtn(
                icon: FontAwesomeIcons.phone,
                label: 'Call Admin',
                onTap: () {
                  // launch phone dialer
                },
              ),

              _HelpBtn(
                icon: FontAwesomeIcons.whatsapp,
                label: 'Whatsapp',
                iconColor: AppColors.success,
                onTap: () {
                  // open whatsapp
                },
              ),

              _HelpBtn(
                icon: FontAwesomeIcons.envelope,
                label: 'Email Support',
                onTap: () {
                  // open email
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HelpBtn extends StatelessWidget {
  final FaIconData icon;
  final String label;
  final Color? iconColor;
  final VoidCallback onTap;

  const _HelpBtn({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(icon, size: 14, color: iconColor ?? AppColors.textPrimary),
            const SizedBox(width: 6),
            Text(
              label,
              style: text10(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
