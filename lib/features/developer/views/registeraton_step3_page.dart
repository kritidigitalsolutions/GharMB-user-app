import 'package:flutter/material.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/developer/providers/register_provider.dart';
import 'package:gharmb_app/routes/app_page.dart';
import 'package:gharmb_app/shared/button/custom_button.dart';
import 'package:go_router/go_router.dart';

class RegistrationStep3Page extends StatelessWidget {
  final RegistrationType type;
  const RegistrationStep3Page({super.key, required this.type});

  bool get _isDeveloper => type == RegistrationType.developer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Progress bar (full) ──────────────────────
              _ProgressBar(step: 3, total: 3),
              const SizedBox(height: 48),

              // ── Party popper ─────────────────────────────
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE9FF),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text('🎉', style: TextStyle(fontSize: 40)),
                ),
              ),
              const SizedBox(height: 24),

              // ── Title ────────────────────────────────────
              Text(
                'Application submitted!',
                style: text24(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // ── Body ─────────────────────────────────────
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text:
                      'Our team will verify your RERA registration\n'
                      'and documents within ',
                  style: text14(color: AppColors.textSecondary),
                  children: [
                    TextSpan(
                      text: '24–48 hours',
                      style: text14(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    TextSpan(
                      text: ". You'll get\nan SMS & email once approved.",
                      style: text14(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // ── What Happens Next ────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.grey200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'WHAT HAPPENS NEXT',
                      style: text11(
                        fontWeight: FontWeight.w700,
                        color: AppColors.grey400,
                      ).copyWith(letterSpacing: 1.1),
                    ),
                    const SizedBox(height: 16),
                    _NextStep(
                      dot: AppColors.success,
                      title: 'Documents received',
                      subtitle: 'Just now',
                    ),
                    const SizedBox(height: 14),
                    _NextStep(
                      dot: AppColors.primary,
                      title: 'Admin verification',
                      subtitle: 'Within 24–48 hrs',
                      highlightWord: 'Admin',
                    ),
                    const SizedBox(height: 14),
                    _NextStep(
                      dot: AppColors.warning,
                      title: 'Account activated',
                      subtitle: _isDeveloper
                          ? 'Start uploading projects'
                          : 'Start listing properties',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // ── Go to Dashboard ──────────────────────────
              AppButton(
                title: _isDeveloper ? "Add Project" : "Add Property",
                onTap: () {
                  if (_isDeveloper) {
                    context.pushNamed(AppPage.devProjectBasicInfoName);
                  } else {
                    context.pushNamed(AppPage.basicDetailsName);
                  }
                },
              ),

              const SizedBox(height: 20),

              // ── Help line ────────────────────────────────
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Need help? WhatsApp us at ',
                  style: text13(color: AppColors.textSecondary),
                  children: [
                    TextSpan(
                      text: '+91 98765 43210',
                      style: text13(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Next Step Row ─────────────────────────────────────────────
class _NextStep extends StatelessWidget {
  final Color dot;
  final String title;
  final String subtitle;
  final String? highlightWord;

  const _NextStep({
    required this.dot,
    required this.title,
    required this.subtitle,
    this.highlightWord,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            highlightWord != null
                ? RichText(
                    text: TextSpan(
                      children: _buildHighlightedText(
                        title,
                        highlightWord!,
                        dot,
                      ),
                    ),
                  )
                : Text(title, style: text13(fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text(subtitle, style: text12(color: AppColors.textSecondary)),
          ],
        ),
      ],
    );
  }

  List<TextSpan> _buildHighlightedText(
    String text,
    String highlight,
    Color color,
  ) {
    final idx = text.indexOf(highlight);
    if (idx == -1) {
      return [
        TextSpan(
          text: text,
          style: appTextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ];
    }
    return [
      if (idx > 0)
        TextSpan(
          text: text.substring(0, idx),
          style: appTextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      TextSpan(
        text: highlight,
        style: appTextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
      if (idx + highlight.length < text.length)
        TextSpan(
          text: text.substring(idx + highlight.length),
          style: appTextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
    ];
  }
}

// ─── Progress Bar ──────────────────────────────────────────────
class _ProgressBar extends StatelessWidget {
  final int step;
  final int total;
  const _ProgressBar({required this.step, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (i) {
        final filled = i < step;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: i < total - 1 ? 6 : 0),
            height: 4,
            decoration: BoxDecoration(
              color: filled ? AppColors.primary : AppColors.grey200,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }),
    );
  }
}
