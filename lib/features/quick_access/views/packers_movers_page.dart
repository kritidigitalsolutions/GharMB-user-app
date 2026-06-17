import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/quick_access/providers/service_provider.dart';
import 'package:gharmb_app/shared/button/custom_button.dart';

class PackersMoversPage extends ConsumerWidget {
  const PackersMoversPage({super.key});

  static const _homeSizes = ['1 BHK', '2 BHK', '3 BHK', '4 BHK', 'Villa'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(packersMoverProvider);
    final notifier = ref.read(packersMoverProvider.notifier);
    final movers = ref.watch(moverCompaniesProvider);
    final selectedSize = ref.watch(selectedHomeSizeProvider);

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
                        'Packers & movers',
                        style: text18(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Verified · insured · on-time',
                        style: text12(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Text(
                'Get quotes in 2 minutes',
                style: text14(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),

              // ── From Location ────────────────────────────────
              _LocationField(
                hint: state.fromLocation.isEmpty
                    ? 'Enter pickup location'
                    : state.fromLocation,
                icon: Icons.my_location_rounded,
                isFilled: state.fromLocation.isNotEmpty,
                onChanged: notifier.setFrom,
              ),
              const SizedBox(height: 10),

              // ── To Location ──────────────────────────────────
              _LocationField(
                hint: state.toLocation.isEmpty
                    ? 'Move to Enter Destination'
                    : state.toLocation,
                icon: Icons.location_on_outlined,
                isFilled: false,
                onChanged: notifier.setTo,
              ),
              const SizedBox(height: 10),

              // ── Date + Home Size ──────────────────────────────
              Row(
                children: [
                  // Date picker
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                          builder: (context, child) => Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: AppColors.primary,
                              ),
                            ),
                            child: child!,
                          ),
                        );
                        if (picked != null) notifier.setDate(picked);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.grey200),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                state.moveDate == null
                                    ? 'Select date'
                                    : '${state.moveDate!.day}/${state.moveDate!.month}/${state.moveDate!.year}',
                                style: text13(
                                  color: state.moveDate == null
                                      ? AppColors.hintText
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Home size dropdown
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.grey200),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedSize,
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.textSecondary,
                          size: 18,
                        ),
                        style: text13(fontWeight: FontWeight.w600),
                        onChanged: (v) {
                          if (v != null) {
                            ref.read(selectedHomeSizeProvider.notifier).state =
                                v;
                            notifier.setHomeSize(v);
                          }
                        },
                        items: _homeSizes
                            .map(
                              (s) => DropdownMenuItem(value: s, child: Text(s)),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // ── Top Verified Movers ──────────────────────────
              Text(
                'Top verified movers',
                style: text14(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              ...movers.map((m) => _MoverCard(mover: m)),
              const SizedBox(height: 12),

              // ── Insurance Note ───────────────────────────────
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.success.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.verified_rounded,
                      color: AppColors.success,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'All movers are verified · goods insured up to ₹2L · no hidden charges',
                        style: text11(color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Get Quotes Button ────────────────────────────
              AppButton(title: "Get final quotes", onTap: () {}),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Location Field ────────────────────────────────────────────
class _LocationField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final bool isFilled;
  final ValueChanged<String> onChanged;

  const _LocationField({
    required this.hint,
    required this.icon,
    required this.isFilled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: isFilled ? AppColors.primary : AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isFilled ? AppColors.primary : AppColors.grey200,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: isFilled ? AppColors.white : AppColors.textSecondary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              style: text13(
                color: isFilled ? AppColors.white : AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: text13(
                  color: isFilled
                      ? AppColors.white.withOpacity(0.8)
                      : AppColors.hintText,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Mover Card ────────────────────────────────────────────────
class _MoverCard extends StatelessWidget {
  final MoverCompany mover;
  const _MoverCard({required this.mover});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Logo placeholder
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.local_shipping_outlined,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(mover.name, style: text13(fontWeight: FontWeight.w700)),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: AppColors.yellow,
                      size: 13,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${mover.rating}  ·  ${mover.reviews} movers',
                      style: text11(color: AppColors.textSecondary),
                    ),
                  ],
                ),
                Text(
                  mover.coverage,
                  style: text10(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                mover.price,
                style: text14(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              Text(mover.tag, style: text10(color: AppColors.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }
}
