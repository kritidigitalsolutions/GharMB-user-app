import 'package:flutter/material.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/property/models/token_booking_model.dart';
import 'package:gharmb_app/routes/app_page.dart';
import 'package:go_router/go_router.dart';

class PropertyReservedPage extends StatelessWidget {
  final TokenRequestItem? tokenRequest;
  final int? tokenAmount;
  final String? propertyId;
  final String? propertyTitle;

  const PropertyReservedPage({
    super.key,
    this.tokenRequest,
    this.tokenAmount,
    this.propertyId,
    this.propertyTitle,
  });

  void _goHome(BuildContext context) {
    context.goNamed(AppPage.myHomeName);
  }

  @override
  Widget build(BuildContext context) {
    final displayAmount = tokenRequest?.tokenAmount ?? tokenAmount ?? 2000;
    final displayRequestId =
        tokenRequest?.tokenRequestId ?? '#TKN-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    final displayPropId = tokenRequest?.propertyId.isNotEmpty == true
        ? tokenRequest!.propertyId
        : (propertyId?.isNotEmpty == true ? propertyId! : 'GHARMB-RESERVED');
    final escrowStatus = tokenRequest?.escrowStatus ?? 'Escrow Held';

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _goHome(context);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ── Success Icon ─────────────────────────────────────
                  _SuccessIcon(),
                  const SizedBox(height: 24),

                  // ── Card ─────────────────────────────────────────────
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Title block
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
                          child: Column(
                            children: [
                              Text(
                                'Property Reserved in Escrow!',
                                style: text20(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.success,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Your token has been secured. Pending owner confirmation.',
                                style: text13(color: AppColors.textSecondary),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),

                        // Divider
                        const Divider(height: 1, color: AppColors.grey100),

                        // Details rows
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                          child: Column(
                            children: [
                              _DetailRow(
                                label: 'Booking Request ID',
                                value: displayRequestId,
                                valueStyle: text14(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _DetailRow(
                                label: 'Token Amount',
                                value: '₹${_formatAmount(displayAmount)}',
                                valueStyle: text14(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 16),
                              _DetailRow(
                                label: 'Escrow Status',
                                value: escrowStatus,
                                valueStyle: text13(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.success,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _DetailRow(
                                label: 'Property ID',
                                value: displayPropId,
                                valueStyle: text13(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Divider
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                          child: const Divider(
                            height: 1,
                            color: AppColors.grey100,
                          ),
                        ),

                        // Notification note
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: AppColors.grey50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.mark_email_read_outlined,
                                    color: AppColors.primary,
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'A confirmation has been sent to your registered mobile and email address.',
                                  style: text12(
                                    color: AppColors.textSecondary,
                                  ).copyWith(height: 1.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Go to Home Button ─────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () => _goHome(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.home_outlined,
                            color: AppColors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Go to Home',
                            style: text16(
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatAmount(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
  }
}

// ─── Success Icon ─────────────────────────────────────────────────────────────

class _SuccessIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.success,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withOpacity(0.30),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Icon(Icons.check_rounded, color: AppColors.white, size: 44),
    );
  }
}

// ─── Detail Row ───────────────────────────────────────────────────────────────

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle valueStyle;

  const _DetailRow({
    required this.label,
    required this.value,
    required this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: text13(color: AppColors.textSecondary)),
        Flexible(
          child: Text(
            value,
            style: valueStyle,
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
