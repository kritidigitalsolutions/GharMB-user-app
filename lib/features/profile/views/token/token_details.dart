import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/profile/provider/token_provider.dart';

import 'package:gharmb_app/routes/app_page.dart';
import 'package:gharmb_app/shared/button/custom_button.dart';
import 'package:go_router/go_router.dart';

class TokenDetailPage extends ConsumerWidget {
  const TokenDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(selectedTokenDetailProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  CustomBackButton(),
                  const SizedBox(width: 12),
                  Text(
                    'Token Details',
                    style: text18(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Scrollable Content ───────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Buyer / Tenant Details
                    Text(
                      'Buyer / Tenant Details',
                      style: text15(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 12),
                    _InfoTable(
                      rows: [
                        _InfoRow('Full Name', detail.fullName),
                        _InfoRow('Mobile Number', detail.mobile),
                        _InfoRow('Email', detail.email),
                        _InfoRow('Profession', detail.profession),
                        _InfoRow('Company', detail.company),
                        _InfoRow('Monthly Income', detail.monthlyIncome),
                        _InfoRow(
                          'Family Members',
                          detail.familyMembers.toString(),
                        ),
                        _InfoRow('Marital Status', detail.maritalStatus),
                        _InfoRow('Current Address', detail.currentAddress),
                        _InfoRow('ID Proof', detail.idProof, isVerified: true),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Booking Details
                    Text(
                      'Booking Details',
                      style: text15(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 12),
                    _InfoTable(
                      rows: [
                        _InfoRow('Property', detail.property),
                        _InfoRow('Token Amount', '₹${detail.tokenAmount}'),
                        _InfoRow('Booking Date', detail.bookingDate),
                        _InfoRow('Remarks', detail.remarks),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Documents
                    Text(
                      'Documents',
                      style: text15(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 12),
                    _DocumentRow(
                      label: 'Aadhaar Card',
                      verified: detail.aadhaarVerified,
                    ),
                    const SizedBox(height: 10),
                    _DocumentRow(
                      label: 'PAN Card',
                      verified: detail.panVerified,
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),

            // ── Bottom Button ────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: AppButton(
                title: "Next",
                onTap: () {
                  context.pushNamed(AppPage.decisionName);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Info Row Model ────────────────────────────────────────────
class _InfoRow {
  final String label;
  final String value;
  final bool isVerified;
  const _InfoRow(this.label, this.value, {this.isVerified = false});
}

// ─── Info Table ────────────────────────────────────────────────
class _InfoTable extends StatelessWidget {
  final List<_InfoRow> rows;
  const _InfoTable({required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey200),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: List.generate(rows.length, (i) {
          final row = rows[i];
          final isLast = i == rows.length - 1;
          return Container(
            decoration: BoxDecoration(
              border: isLast
                  ? null
                  : const Border(bottom: BorderSide(color: AppColors.grey200)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    row.label,
                    style: text12(color: AppColors.textSecondary),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Text(
                          row.value,
                          style: text12(fontWeight: FontWeight.w600),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      if (row.isVerified) ...[
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.success,
                          size: 14,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// ─── Document Row ──────────────────────────────────────────────
class _DocumentRow extends StatelessWidget {
  final String label;
  final bool verified;
  const _DocumentRow({required this.label, required this.verified});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey200),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: text13(fontWeight: FontWeight.w500)),
          Row(
            children: [
              Text(
                verified ? 'Verified' : 'Pending',
                style: text12(
                  color: verified ? AppColors.success : AppColors.warning,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                verified ? Icons.check_circle_rounded : Icons.pending_outlined,
                color: verified ? AppColors.success : AppColors.warning,
                size: 15,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
