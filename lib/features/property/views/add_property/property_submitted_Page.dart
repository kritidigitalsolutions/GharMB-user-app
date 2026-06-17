import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/property/providers/property_add_provider.dart';
import 'package:gharmb_app/routes/app_page.dart';
import 'package:gharmb_app/shared/button/custom_button.dart';
import 'package:go_router/go_router.dart';

class PropertySubmittedPage extends ConsumerWidget {
  const PropertySubmittedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final submissionId = ref.watch(submissionIdProvider);
    final currentStep = ref.watch(currentStepProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              _SuccessIcon(),
              const SizedBox(height: 20),
              Text(
                'Listing submitted!',
                style: text20(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Your property is now under admin\nreview. We\'ll notify you at each step.',
                style: text13(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'What happens next',
                  style: text16(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 20),
              _StepsList(currentStep: currentStep),
              const SizedBox(height: 28),
              _SubmissionIdCard(submissionId: submissionId),
              const SizedBox(height: 28),
              _ActionButtons(),
              const SizedBox(height: 20),
              _HelpRow(),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Success Icon ──────────────────────────────────────────────
class _SuccessIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.check_circle_rounded,
        color: AppColors.success,
        size: 48,
      ),
    );
  }
}

// ─── Steps ────────────────────────────────────────────────────
class _StepsList extends StatelessWidget {
  final int currentStep;
  const _StepsList({required this.currentStep});

  static const _steps = [
    _StepData(
      icon: Icons.check_circle_outline,
      title: 'Submitted',
      subtitle: 'Your listing has been received today',
      activeColor: AppColors.success,
    ),

    _StepData(
      icon: Icons.remove_red_eye_outlined,
      title: 'Property Verification',
      subtitle: 'Our team will verify property, photos & location',
      activeColor: AppColors.primary,
    ),
    _StepData(
      icon: Icons.send_outlined,
      title: 'Go Live',
      subtitle: 'Your property will be live on GharMB',
      activeColor: AppColors.info,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(_steps.length, (i) {
        final step = _steps[i];
        final isActive = i <= currentStep;
        final isLast = i == _steps.length - 1;
        return _StepItem(data: step, isActive: isActive, isLast: isLast);
      }),
    );
  }
}

class _StepData {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color activeColor;

  const _StepData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.activeColor,
  });
}

class _StepItem extends StatelessWidget {
  final _StepData data;
  final bool isActive;
  final bool isLast;

  const _StepItem({
    required this.data,
    required this.isActive,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? data.activeColor : AppColors.grey300;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon + connector line
          Column(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(data.icon, color: color, size: 20),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isActive
                        ? color.withOpacity(0.25)
                        : AppColors.grey200,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          // Text
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  Text(
                    data.title,
                    style: text14(
                      fontWeight: FontWeight.w600,
                      color: isActive
                          ? AppColors.textPrimary
                          : AppColors.grey400,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    data.subtitle,
                    style: text12(
                      color: isActive
                          ? AppColors.textSecondary
                          : AppColors.grey400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Submission ID Card ────────────────────────────────────────
class _SubmissionIdCard extends StatelessWidget {
  final String submissionId;
  const _SubmissionIdCard({required this.submissionId});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Submission ID', style: text12(color: AppColors.textSecondary)),
          const SizedBox(height: 6),
          Text(
            submissionId,
            style: text15(
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'You will receive SMS & email updates',
            style: text11(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

// ─── Action Buttons ────────────────────────────────────────────
class _ActionButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 45,
            child: OutlinedButton.icon(
              onPressed: () {
                context.goNamed(AppPage.myHomeName, extra: 2);
              },
              icon: const Icon(Icons.add, color: AppColors.primary, size: 18),
              label: Text(
                'Add another',
                style: text14(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AppButton(
            title: "My Dashboard",
            onTap: () {
              context.pushNamed(AppPage.dashboardName);
            },
          ),
        ),
      ],
    );
  }
}

// ─── Help Row ──────────────────────────────────────────────────
class _HelpRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Need Help?',
          style: text12(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _HelpChip(icon: Icons.call_outlined, label: 'Call Admin'),
            _HelpChip(icon: Icons.chat_bubble_outline, label: 'Whatsapp'),
            _HelpChip(icon: Icons.email_outlined, label: 'Email Support'),
          ],
        ),
      ],
    );
  }
}

class _HelpChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _HelpChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(label, style: text11(color: AppColors.textSecondary)),
      ],
    );
  }
}
