import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/profile/provider/token_provider.dart';
import 'package:gharmb_app/shared/button/custom_button.dart';
import 'package:gharmb_app/shared/widget/custom_widget.dart';

class DecisionPage extends ConsumerWidget {
  const DecisionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(selectedTokenDetailProvider);
    final action = ref.watch(decisionActionProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ────────────────────────────────────
              Row(
                children: [
                  CustomBackButton(),
                  const SizedBox(width: 12),
                  Text('Decision', style: text18(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 28),

              // ── Question ──────────────────────────────────
              Center(
                child: Column(
                  children: [
                    Text(
                      'Do you want to accept\nthis token?',
                      style: text20(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'After accepting, buyer will be notified and\ntoken amount will be secured with GharMB',
                      style: text12(color: AppColors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Buyer Summary Card ────────────────────────
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.grey200),
                ),
                child: Column(
                  children: [
                    // Person info
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: AppColors.grey200,
                          backgroundImage: detail.imageUrl.isNotEmpty
                              ? NetworkImage(detail.imageUrl)
                              : null,
                          child: detail.imageUrl.isEmpty
                              ? const Icon(
                                  Icons.person,
                                  color: AppColors.grey400,
                                  size: 26,
                                )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                detail.fullName,
                                style: text14(fontWeight: FontWeight.w700),
                              ),
                              Text(
                                '${detail.profession} • Family of ${detail.familyMembers}',
                                style: text11(color: AppColors.textSecondary),
                              ),
                              Text(
                                '₹${detail.tokenAmount} Token  •  12 Jun 2026',
                                style: text11(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Divider(color: AppColors.grey200, height: 1),
                    const SizedBox(height: 14),
                    // Detail rows
                    _SummaryRow(label: 'Property', value: detail.property),
                    const SizedBox(height: 8),
                    _SummaryRow(
                      label: 'Token Amount',
                      value: '₹${detail.tokenAmount}',
                    ),
                    const SizedBox(height: 8),
                    _SummaryRow(
                      label: 'Booking Date',
                      value: detail.bookingDate,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── What Happens Next ─────────────────────────
              Text(
                'What happens next?',
                style: text13(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 10),
              _NextPoint('Buyer will be notified'),
              const SizedBox(height: 6),
              _NextPoint('Token amount will be secure with GharMB'),
              const SizedBox(height: 6),
              _NextPoint('You can start agreement discussion'),
              const SizedBox(height: 28),

              // ── Action Buttons ────────────────────────────
              AppButton(
                title: "Accept Token",
                onTap: () {
                  ref.read(decisionActionProvider.notifier).state =
                      DecisionAction.accepted;
                  _showConfirmSnack(
                    context,
                    'Token Accepted!',
                    AppColors.success,
                  );
                },
                color: AppColors.success,
              ),

              const SizedBox(height: 12),
              AppButton(
                title: "Reject Token",
                onTap: () {
                  ref.read(decisionActionProvider.notifier).state =
                      DecisionAction.rejected;
                  _showConfirmSnack(context, 'Token Rejected', AppColors.error);
                },
                color: AppColors.error,
              ),

              const SizedBox(height: 12),
              AppOutlineButton(
                title: "Need More Time",
                onTap: () {
                  ref.read(decisionActionProvider.notifier).state =
                      DecisionAction.needMoreTime;
                },
                color: AppColors.textPrimary,
              ),

              const SizedBox(height: 24),

              // ── Help Row ──────────────────────────────────
              HelpRow(),
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmSnack(BuildContext context, String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: text13(color: AppColors.white)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

// ─── Summary Row ───────────────────────────────────────────────
class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: text12(color: AppColors.textSecondary)),
        Text(value, style: text12(fontWeight: FontWeight.w600)),
      ],
    );
  }
}

// ─── Next Point ────────────────────────────────────────────────
class _NextPoint extends StatelessWidget {
  final String text;
  const _NextPoint(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.check_circle_rounded,
          color: AppColors.success,
          size: 16,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text, style: text12(color: AppColors.textSecondary)),
        ),
      ],
    );
  }
}
