import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'dart:math';

import 'package:gharmb_app/features/profile/provider/tools_provider.dart';
import 'package:gharmb_app/shared/button/custom_button.dart';

class LoanCalculatorPage extends ConsumerWidget {
  const LoanCalculatorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loan = ref.watch(loanProvider);
    final notifier = ref.read(loanProvider.notifier);

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
                  Text(
                    'Loan\ncalculator',
                    style: text18(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Divider(),
              const SizedBox(height: 12),

              // ── EMI Card ─────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      '₹${_formatNum(loan.monthlyEMI)}',
                      style: text30(
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Monthly EMI',
                      style: text13(color: AppColors.white.withOpacity(0.85)),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            loan.isAffordable ? 'Affordable' : 'High EMI',
                            style: text11(
                              color: loan.isAffordable
                                  ? AppColors.success
                                  : AppColors.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            loan.isAffordable
                                ? Icons.check_circle_rounded
                                : Icons.warning_rounded,
                            size: 12,
                            color: loan.isAffordable
                                ? AppColors.success
                                : AppColors.error,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // ── Total Stats Row ───────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: _StatBox(
                      label: 'Total payable',
                      value: '₹${_formatLakh(loan.totalPayable)}',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatBox(
                      label: 'Total interest',
                      value: '₹${_formatLakh(loan.totalInterest)}',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // ── Sliders ──────────────────────────────────────
              _SliderRow(
                label: 'Loan amount',
                value: '₹${loan.loanAmount.toInt()}L',
                sliderValue: loan.loanAmount,
                min: 5,
                max: 200,
                divisions: 195,
                onChanged: (v) => notifier.setLoanAmount(v),
              ),
              const SizedBox(height: 20),
              _SliderRow(
                label: 'Interest rate',
                value: '${loan.interestRate.toStringAsFixed(1)}%',
                sliderValue: loan.interestRate,
                min: 5,
                max: 20,
                divisions: 150,
                onChanged: (v) => notifier.setInterestRate(
                  double.parse(v.toStringAsFixed(1)),
                ),
              ),
              const SizedBox(height: 20),
              _SliderRow(
                label: 'Tenure',
                value: '${loan.tenure.toInt()} yr',
                sliderValue: loan.tenure,
                min: 1,
                max: 30,
                divisions: 29,
                onChanged: (v) => notifier.setTenure(v),
              ),
              const SizedBox(height: 28),

              // ── EMI Breakdown ────────────────────────────────
              _EMIBreakdown(loan: loan),
            ],
          ),
        ),
      ),
    );
  }

  String _formatNum(double v) {
    if (v >= 100000) return '${(v / 100000).toStringAsFixed(1)}L';
    return v
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        );
  }

  String _formatLakh(double v) {
    return '${(v / 100000).toStringAsFixed(1)}L';
  }
}

// ─── Stat Box ──────────────────────────────────────────────────
class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF3D1A00),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: text16(fontWeight: FontWeight.w700, color: AppColors.white),
          ),
          const SizedBox(height: 3),
          Text(label, style: text11(color: AppColors.white.withOpacity(0.7))),
        ],
      ),
    );
  }
}

// ─── Slider Row ────────────────────────────────────────────────
class _SliderRow extends StatelessWidget {
  final String label;
  final String value;
  final double sliderValue;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;

  const _SliderRow({
    required this.label,
    required this.value,
    required this.sliderValue,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: text13(color: AppColors.textSecondary)),
            Text(value, style: text13(fontWeight: FontWeight.w600)),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: AppColors.grey200,
            thumbColor: AppColors.primary,
            overlayColor: AppColors.primary.withOpacity(0.15),
            trackHeight: 3,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
          ),
          child: Slider(
            value: sliderValue.clamp(min, max),
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

// ─── EMI Breakdown ─────────────────────────────────────────────
class _EMIBreakdown extends StatelessWidget {
  final LoanState loan;
  const _EMIBreakdown({required this.loan});

  @override
  Widget build(BuildContext context) {
    final principal = loan.loanAmount * 100000;
    final interest = loan.totalInterest;
    final processing = loan.processingFees;
    final other = loan.otherCharges;
    final total = principal + interest + processing + other;

    final segments = [
      _DonutSegment(
        label: 'Principal Amount',
        value: principal,
        color: AppColors.primary,
      ),
      _DonutSegment(
        label: 'Total Interest',
        value: interest,
        color: const Color(0xFF6B7AFF),
      ),
      _DonutSegment(
        label: 'Processing Fees',
        value: processing,
        color: const Color(0xFF9B59B6),
      ),
      _DonutSegment(
        label: 'Other Charges',
        value: other,
        color: const Color(0xFFBDC3C7),
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('EMI Breakdown', style: text14(fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          Row(
            children: [
              // Donut Chart
              SizedBox(
                width: 110,
                height: 110,
                child: CustomPaint(
                  painter: _DonutPainter(segments: segments, total: total),
                ),
              ),
              const SizedBox(width: 20),
              // Legend
              Expanded(
                child: Column(
                  children: segments
                      .map(
                        (s) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: s.color,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  s.label,
                                  style: text11(color: AppColors.textSecondary),
                                ),
                              ),
                              Text(
                                '₹${(s.value / 100000).toStringAsFixed(1)}L',
                                style: text11(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DonutSegment {
  final String label;
  final double value;
  final Color color;
  const _DonutSegment({
    required this.label,
    required this.value,
    required this.color,
  });
}

class _DonutPainter extends CustomPainter {
  final List<_DonutSegment> segments;
  final double total;

  _DonutPainter({required this.segments, required this.total});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 20.0;
    final rect = Rect.fromCircle(
      center: center,
      radius: radius - strokeWidth / 2,
    );

    double startAngle = -pi / 2;
    for (final seg in segments) {
      final sweep = (seg.value / total) * 2 * pi;
      final paint = Paint()
        ..color = seg.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(rect, startAngle, sweep - 0.04, false, paint);
      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(_DonutPainter old) => true;
}
