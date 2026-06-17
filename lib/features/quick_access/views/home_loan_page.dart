import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/quick_access/providers/service_provider.dart';
import 'package:gharmb_app/shared/button/custom_button.dart';

class HomeLoanPage extends ConsumerWidget {
  const HomeLoanPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loan = ref.watch(homeLoanProvider);
    final notifier = ref.read(homeLoanProvider.notifier);
    final lenders = ref.watch(lendersProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──────────────────────────────────────
              Row(
                children: [
                  CustomBackButton(),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Home loan',
                        style: text18(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Check eligibility and apply',
                        style: text12(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ── Stats Row ────────────────────────────────────
              Row(
                children: [
                  _StatChip(value: '8.50%', label: 'Best\nrate'),
                  const SizedBox(width: 10),
                  _StatChip(value: '10+', label: 'Bank\npartners'),
                  const SizedBox(width: 10),
                  _StatChip(value: '48hr', label: 'Avg\napproval'),
                ],
              ),
              const SizedBox(height: 24),

              // ── Quick Eligibility Check ──────────────────────
              Text(
                'Quick eligibility check',
                style: text14(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              _EligibilityField(
                label: 'Monthly Income: ₹${_fmt(loan.monthlyIncome.toInt())}',
                onChanged: (v) {
                  final parsed = double.tryParse(v.replaceAll(',', ''));
                  if (parsed != null) notifier.setMonthlyIncome(parsed);
                },
              ),
              const SizedBox(height: 10),
              _EligibilityField(
                label: 'Property value: ₹${_fmt(loan.propertyValue.toInt())}',
                onChanged: (v) {
                  final parsed = double.tryParse(v.replaceAll(',', ''));
                  if (parsed != null) notifier.setPropertyValue(parsed);
                },
              ),
              const SizedBox(height: 10),
              TextField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: text13(),
                decoration: InputDecoration(
                  hintText: 'Existing EMIs (if any)',
                  hintStyle: text13(color: AppColors.hintText),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 13,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.grey200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.grey200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
                onChanged: (v) {
                  final parsed = double.tryParse(v);
                  if (parsed != null) notifier.setExistingEmi(parsed);
                },
              ),
              const SizedBox(height: 20),

              // ── Eligibility Result ───────────────────────────
              Container(
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
                    Text(
                      'Your loan eligibility',
                      style: text12(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '₹${_fmtL(loan.minEligibility)} – ₹${_fmtL(loan.maxEligibility)} Lakhs',
                      style: text20(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Based on 80% LTV · 8.5% rate · 20 yr tenure',
                      style: text11(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Compare Lenders ──────────────────────────────
              Text(
                'Compare top lenders',
                style: text14(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              ...lenders.map((l) => _LenderRow(lender: l)),
              const SizedBox(height: 20),

              // ── Apply Button ─────────────────────────────────
              AppButton(title: 'Apply now', onTap: () {}),
            ],
          ),
        ),
      ),
    );
  }

  String _fmt(int v) => v.toString().replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (m) => '${m[1]},',
  );

  String _fmtL(double v) => (v / 100000).toStringAsFixed(0);
}

class _StatChip extends StatelessWidget {
  final String value;
  final String label;
  const _StatChip({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.grey200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: text14(
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            Text(label, style: text10(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

class _EligibilityField extends StatelessWidget {
  final String label;
  final ValueChanged<String> onChanged;
  const _EligibilityField({required this.label, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: text13(fontWeight: FontWeight.w600, color: AppColors.white),
      ),
    );
  }
}

class _LenderRow extends StatelessWidget {
  final LenderModel lender;
  const _LenderRow({required this.lender});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                lender.logo,
                style: text10(
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(lender.name, style: text13(fontWeight: FontWeight.w600)),
                Text(
                  lender.tagline,
                  style: text10(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                lender.rate,
                style: text13(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              if (lender.tag.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    lender.tag,
                    style: text10(
                      color: AppColors.success,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
