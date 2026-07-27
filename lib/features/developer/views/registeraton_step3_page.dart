import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/developer/providers/register_provider.dart';
import 'package:gharmb_app/features/developer/providers/register_submit_provider.dart';
import 'package:gharmb_app/shared/button/custom_button.dart';

class RegistrationStep3Page extends ConsumerWidget {
  final RegistrationType type;
  const RegistrationStep3Page({super.key, required this.type});

  bool get _isDeveloper => type == RegistrationType.developer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final submitState = ref.watch(registrationSubmitProvider(type));

    // Surface upload/registration errors as a snackbar without rebuilding
    // the whole tree for them.
    ref.listen(registrationSubmitProvider(type), (previous, next) {
      if (next.errorMessage != null &&
          next.errorMessage != previous?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              next.errorMessage!,
              style: text12(color: AppColors.white),
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _ProgressBar(step: 3, total: 3),
              const SizedBox(height: 48),
              submitState.isSuccess
                  ? _SuccessContent(isDeveloper: _isDeveloper)
                  : _ReviewAndSubmitContent(
                      type: type,
                      isDeveloper: _isDeveloper,
                      submitState: submitState,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Review + Submit (pre-submission state) ───────────────────────
class _ReviewAndSubmitContent extends ConsumerWidget {
  final RegistrationType type;
  final bool isDeveloper;
  final RegistrationSubmitState submitState;

  const _ReviewAndSubmitContent({
    required this.type,
    required this.isDeveloper,
    required this.submitState,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final step1 = isDeveloper
        ? ref.watch(developerStep1Provider)
        : ref.watch(agentStep1Provider);
    final step2 = isDeveloper
        ? ref.watch(developerStep2Provider)
        : ref.watch(agentStep2Provider);
    final pickedFiles = ref.watch(pickedFilesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ── Icon ─────────────────────────────────────────
        Container(
          width: 90,
          height: 90,
          decoration: const BoxDecoration(
            color: Color(0xFFEDE9FF),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              Icons.fact_check_outlined,
              size: 40,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: 24),

        Text(
          'Review & submit',
          style: text24(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          "Double-check your details below. Once submitted, our team\nwill verify your RERA registration and documents.",
          style: text14(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 28),

        // ── Details summary card ──────────────────────────
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
                'DETAILS',
                style: text11(
                  fontWeight: FontWeight.w700,
                  color: AppColors.grey400,
                ).copyWith(letterSpacing: 1.1),
              ),
              const SizedBox(height: 14),
              if (isDeveloper) ...[
                _SummaryRow(label: 'Company', value: step1.companyName),
                _SummaryRow(label: 'RERA number', value: step1.reraNumber),
                _SummaryRow(
                  label: 'GST number',
                  value: step1.gstNumber.isEmpty ? '—' : step1.gstNumber,
                ),
                _SummaryRow(
                  label: 'Years in business',
                  value: step1.yearsInBusiness,
                ),
                _SummaryRow(label: 'City', value: step1.cityOfOperation),
              ] else ...[
                _SummaryRow(label: 'Name', value: step1.agentName),
                _SummaryRow(label: 'Mobile', value: step1.mobile),
                _SummaryRow(label: 'RERA number', value: step1.reraNumber),
                _SummaryRow(
                  label: 'Experience',
                  value: step1.experience.isEmpty ? '—' : step1.experience,
                ),
                _SummaryRow(label: 'City', value: step1.cityOfOperation),
              ],
              const SizedBox(height: 4),
              Divider(color: AppColors.grey200, height: 24),
              Text(
                'DOCUMENTS',
                style: text11(
                  fontWeight: FontWeight.w700,
                  color: AppColors.grey400,
                ).copyWith(letterSpacing: 1.1),
              ),
              const SizedBox(height: 10),
              ...step2.documents.map(
                (doc) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(
                        pickedFiles.containsKey(doc.key)
                            ? Icons.check_circle_rounded
                            : Icons.radio_button_unchecked_rounded,
                        size: 16,
                        color: pickedFiles.containsKey(doc.key)
                            ? AppColors.success
                            : AppColors.grey300,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          doc.name,
                          style: text13(color: AppColors.textPrimary),
                        ),
                      ),
                      if (!doc.isRequired)
                        Text(
                          'optional',
                          style: text11(color: AppColors.grey400),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),

        // ── Submit button ─────────────────────────────────
        AppButton(
          title: submitState.isUploadingFiles
              ? 'Uploading documents…'
              : submitState.isSubmitting
              ? 'Submitting…'
              : 'Submit',
          onTap: submitState.isBusy
              ? () {}
              : () => ref
                    .read(registrationSubmitProvider(type).notifier)
                    .submit(),
        ),

        const SizedBox(height: 20),
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
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(label, style: text12(color: AppColors.textSecondary)),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '—' : value,
              style: text13(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Success (post-submission state) ───────────────────────────────
class _SuccessContent extends StatelessWidget {
  final bool isDeveloper;
  const _SuccessContent({required this.isDeveloper});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: const BoxDecoration(
            color: Color(0xFFEDE9FF),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Text('🎉', style: TextStyle(fontSize: 40)),
          ),
        ),
        const SizedBox(height: 24),

        Text(
          'Application submitted!',
          style: text24(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),

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
                subtitle: isDeveloper
                    ? 'Start uploading projects'
                    : 'Start listing properties',
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // "Add Project"/"Add Property" removed — nothing to add until the
        // account is actually verified. A quiet text link back to the
        // dashboard is enough here.
        // TODO: point this at your actual dashboard/home route.
        // TextButton(
        //   onPressed: () => context.go('/dashboard'),
        //   child: Text('Back to dashboard', style: text13(fontWeight: FontWeight.w600)),
        // ),
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
