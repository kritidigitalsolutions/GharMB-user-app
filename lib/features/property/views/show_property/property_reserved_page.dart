import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/routes/app_page.dart';
import 'package:go_router/go_router.dart';

// ─── Model ────────────────────────────────────────────────────────────────────

class ReservationDetails {
  final int tokenAmount;
  final String validFor;
  final String propertyId;

  const ReservationDetails({
    this.tokenAmount = 5000,
    this.validFor = '48 Hours',
    this.propertyId = 'GHARMB-28491',
  });
}

final reservationProvider = Provider<ReservationDetails>(
  (_) => const ReservationDetails(),
);

// ─── Page ─────────────────────────────────────────────────────────────────────

class PropertyReservedPage extends ConsumerWidget {
  const PropertyReservedPage({super.key});

  void _goHome(BuildContext context) {
    context.goNamed(AppPage.myHomeName);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final details = ref.watch(reservationProvider);

    return PopScope(
      // Disable back gesture/button — user must use "Go to Home"
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _goHome(context);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
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
                          color: Colors.black.withOpacity(0.07),
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
                                'Property Reserved!',
                                style: text20(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.success,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Your token has been received successfully',
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
                                label: 'Token Amount',
                                value: '₹${_formatAmount(details.tokenAmount)}',
                                valueStyle: text14(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 16),
                              _DetailRow(
                                label: 'Reservation Valid For',
                                value: details.validFor,
                                valueStyle: text14(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 16),
                              _DetailRow(
                                label: 'Property ID',
                                value: details.propertyId,
                                valueStyle: text14(
                                  fontWeight: FontWeight.bold,
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

                        // Gmail notification note
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
                                child: Center(child: _GmailIcon()),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'You will receive a confirmation on your registered mobile number and email',
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
        Text(value, style: valueStyle),
      ],
    );
  }
}

// ─── Gmail M Icon (custom painted) ───────────────────────────────────────────

class _GmailIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: const Size(22, 16), painter: _GmailPainter());
  }
}

class _GmailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Envelope background
    final bgPaint = Paint()..color = Colors.white;
    final borderPaint = Paint()
      ..color = const Color(0xFFEA4335)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, w, h),
      const Radius.circular(2),
    );
    canvas.drawRRect(rect, bgPaint);

    // Red left flap
    final leftPaint = Paint()..color = const Color(0xFFEA4335);
    final leftPath = Path()
      ..moveTo(0, 0)
      ..lineTo(w * 0.38, h * 0.5)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(leftPath, leftPaint);

    // Blue right flap
    final rightPaint = Paint()..color = const Color(0xFF4285F4);
    final rightPath = Path()
      ..moveTo(w, 0)
      ..lineTo(w * 0.62, h * 0.5)
      ..lineTo(w, h)
      ..close();
    canvas.drawPath(rightPath, rightPaint);

    // Yellow/green bottom flap
    final bottomPaint = Paint()..color = const Color(0xFF34A853);
    final bottomPath = Path()
      ..moveTo(0, h)
      ..lineTo(w * 0.38, h * 0.5)
      ..lineTo(w * 0.5, h * 0.62)
      ..lineTo(w * 0.62, h * 0.5)
      ..lineTo(w, h)
      ..close();
    canvas.drawPath(bottomPath, bottomPaint);

    // Red top M shape
    final mPaint = Paint()..color = const Color(0xFFEA4335);
    final mPath = Path()
      ..moveTo(0, 0)
      ..lineTo(w * 0.5, h * 0.52)
      ..lineTo(w, 0)
      ..close();
    canvas.drawPath(mPath, mPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}
