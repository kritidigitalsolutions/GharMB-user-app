import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/developer/providers/project_add_provider.dart';
import 'package:gharmb_app/features/property/widget/listing_widget.dart';
import 'package:gharmb_app/routes/app_page.dart';
import 'package:gharmb_app/shared/button/custom_button.dart';
import 'package:gharmb_app/shared/widget/custom_stepprogress.dart';
import 'package:go_router/go_router.dart';

class ProjectUnitConfigPage extends ConsumerWidget {
  const ProjectUnitConfigPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(projectAddProvider);
    final notifier = ref.read(projectAddProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        toolbarHeight: 80,
        leading: GestureDetector(
          onTap: context.pop,
          child: const Icon(
            Icons.arrow_back,
            color: AppColors.primary,
            size: 18,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("BHK & pricing", style: text16(fontWeight: FontWeight.bold)),

            const SizedBox(height: 4),
            StepProgress(current: 2, total: 5),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Info banner ─────────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFDE8DC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Text(
                'Add all BHK types you\'re offering. You can add multiple configurations.',
                style: text12(
                  color: AppColors.textSecondary,
                ).copyWith(height: 1.5),
              ),
            ),
            const SizedBox(height: 20),

            // ── Project highlights ──────────────────────────────────────────
            Text(
              'PROJECT HIGHLIGHTS',
              style: text11(
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _SmallField(
                    label: 'Total units',
                    hint: '240',
                    keyboardType: TextInputType.number,
                    onChanged: notifier.setTotalUnitsOverall,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SmallField(
                    label: 'Open space %',
                    hint: '70',
                    keyboardType: TextInputType.number,
                    onChanged: notifier.setOpenSpacePercent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _SmallField(
                    label: 'Floors',
                    hint: 'G + 14',
                    onChanged: notifier.setTotalFloors,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SmallField(
                    label: 'Towers',
                    hint: '3',
                    keyboardType: TextInputType.number,
                    onChanged: notifier.setTotalTowers,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ── BHK configs ─────────────────────────────────────────────────
            ...state.bhkConfigs.asMap().entries.map((entry) {
              final index = entry.key;
              final config = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _BhkConfigCard(
                  config: config,
                  typeNumber: index + 1,
                  onUpdate: (updated) =>
                      notifier.updateBhkConfig(config.id, updated),
                  onRemove: state.bhkConfigs.length > 1
                      ? () => notifier.removeBhkConfig(config.id)
                      : null,
                ),
              );
            }),

            // ── Add BHK button ──────────────────────────────────────────────
            GestureDetector(
              onTap: notifier.addBhkConfig,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.5),
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.primary.withOpacity(0.03),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: AppColors.primary, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      'Add another BHK type',
                      style: text13(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomBar(
        onTap: () => context.pushNamed(AppPage.devProjectAmenitiesName),
      ),
    );
  }
}

// ─── BHK Config Card ──────────────────────────────────────────────────────────

class _BhkConfigCard extends StatelessWidget {
  final BhkConfig config;
  final int typeNumber;
  final ValueChanged<BhkConfig> onUpdate;
  final VoidCallback? onRemove;

  const _BhkConfigCard({
    required this.config,
    required this.typeNumber,
    required this.onUpdate,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final pricePerSqft = config.pricePerSqft;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              GestureDetector(
                onTap: () => _showBhkPicker(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    config.bhkType.isEmpty ? 'Select BHK' : config.bhkType,
                    style: text13(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.grey100,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Type $typeNumber',
                  style: text11(color: AppColors.textSecondary),
                ),
              ),
              if (onRemove != null) ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onRemove,
                  child: const Icon(
                    Icons.close,
                    size: 18,
                    color: AppColors.grey400,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),

          // Area fields
          Row(
            children: [
              Expanded(
                child: _CardField(
                  label: 'Carpet area (sqft)',
                  hint: '840',
                  value: config.carpetArea,
                  onChanged: (v) => onUpdate(config.copyWith(carpetArea: v)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _CardField(
                  label: 'Built-up (sqft)',
                  hint: '1050',
                  value: config.builtUpArea,
                  onChanged: (v) => onUpdate(config.copyWith(builtUpArea: v)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // // Super BUA (NEW)
          // _CardField(
          //   label: 'Super built-up area (sqft)',
          //   hint: '1200',
          //   value: config.superBuiltUpArea,
          //   onChanged: (v) => onUpdate(config.copyWith(superBuiltUpArea: v)),
          // ),
          const SizedBox(height: 10),

          // Price + Units
          Row(
            children: [
              Expanded(
                child: _CardField(
                  label: 'Price (₹ Lakh)',
                  hint: '42',
                  value: config.priceInLakh,
                  onChanged: (v) => onUpdate(config.copyWith(priceInLakh: v)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _CardField(
                  label: 'Total units',
                  hint: '80',
                  value: config.totalUnits,
                  onChanged: (v) => onUpdate(config.copyWith(totalUnits: v)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Booking amount (NEW)
          Row(
            children: [
              Expanded(
                child: _CardField(
                  label: 'Booking amount (₹)',
                  hint: '1,00,000',
                  value: config.bookingAmount,
                  onChanged: (v) => onUpdate(config.copyWith(bookingAmount: v)),
                ),
              ),
              const SizedBox(width: 10),
              // Price per sqft — auto calculated (NEW)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FieldLabel('Price / sqft'),
                    const SizedBox(height: 4),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 13,
                      ),
                      decoration: BoxDecoration(
                        color: pricePerSqft > 0
                            ? AppColors.primary.withOpacity(0.06)
                            : AppColors.grey50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.grey200),
                      ),
                      child: Text(
                        pricePerSqft > 0
                            ? '₹ ${pricePerSqft.toStringAsFixed(0)}'
                            : 'Auto',
                        style: text13(
                          fontWeight: FontWeight.w600,
                          color: pricePerSqft > 0
                              ? AppColors.primary
                              : AppColors.grey400,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Auto-calculated',
                      style: text10(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Facing preference (NEW)
          FieldLabel('Facing preference'),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: BhkFacing.values.map((v) {
              final sel = config.facing == v;
              return GestureDetector(
                onTap: () => onUpdate(config.copyWith(facing: v)),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: sel
                        ? AppColors.primary.withOpacity(0.08)
                        : AppColors.grey50,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: sel ? AppColors.primary : AppColors.grey200,
                    ),
                  ),
                  child: Text(
                    v.label,
                    style: text11(
                      fontWeight: FontWeight.w500,
                      color: sel ? AppColors.primary : AppColors.textSecondary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),

          // Payment plan (NEW)
          FieldLabel('Payment plan'),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: PaymentPlanType.values.map((v) {
              final sel = config.paymentPlan == v;
              return GestureDetector(
                onTap: () => onUpdate(config.copyWith(paymentPlan: v)),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: sel
                        ? AppColors.primary.withOpacity(0.08)
                        : AppColors.grey50,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: sel ? AppColors.primary : AppColors.grey200,
                    ),
                  ),
                  child: Text(
                    v.label,
                    style: text11(
                      fontWeight: FontWeight.w500,
                      color: sel ? AppColors.primary : AppColors.textSecondary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _showBhkPicker(BuildContext context) {
    final options = [
      '1 BHK',
      '2 BHK',
      '3 BHK',
      '4 BHK',
      '4+ BHK',
      'Studio',
      'Villa',
      'Plot',
    ];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select BHK type', style: text15(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: options
                  .map(
                    (o) => GestureDetector(
                      onTap: () {
                        onUpdate(config.copyWith(bhkType: o));
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: config.bhkType == o
                              ? AppColors.primary
                              : AppColors.grey50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: config.bhkType == o
                                ? AppColors.primary
                                : AppColors.grey200,
                          ),
                        ),
                        child: Text(
                          o,
                          style: text13(
                            fontWeight: FontWeight.w600,
                            color: config.bhkType == o
                                ? AppColors.white
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _CardField extends StatelessWidget {
  final String label;
  final String hint;
  final String value;
  final ValueChanged<String> onChanged;

  const _CardField({
    required this.label,
    required this.hint,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(label),
        const SizedBox(height: 4),
        TextField(
          keyboardType: TextInputType.number,
          onChanged: onChanged,
          style: text13(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: text13(color: AppColors.grey400),
            filled: true,
            fillColor: AppColors.grey50,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 11,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.grey200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.grey200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}

class _SmallField extends StatelessWidget {
  final String label;
  final String hint;
  final TextInputType keyboardType;
  final ValueChanged<String> onChanged;

  const _SmallField({
    required this.label,
    required this.hint,
    this.keyboardType = TextInputType.text,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(label),
        const SizedBox(height: 4),
        TextField(
          keyboardType: keyboardType,
          onChanged: onChanged,
          style: text13(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: text13(color: AppColors.grey400),
            filled: true,
            fillColor: AppColors.grey50,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 11,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.grey200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.grey200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}

class _BottomBar extends StatelessWidget {
  final VoidCallback onTap;
  const _BottomBar({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: AppButton(title: 'Next →', onTap: onTap),
      ),
    );
  }
}
