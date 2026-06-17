import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/profile/provider/tools_provider.dart';
import 'package:gharmb_app/shared/button/custom_button.dart';

class UnitConverterPage extends ConsumerWidget {
  const UnitConverterPage({super.key});

  static const _categoryLabels = {
    UnitCategory.area: 'Area',
    UnitCategory.length: 'Length',
    UnitCategory.volume: 'Volume',
    UnitCategory.weight: 'Weight',
  };

  static const _quickConversions = [
    _QuickItem('1 BHK Carpet Area (Sq Ft)', '~ 450 – 550'),
    _QuickItem('2 BHK Carpet Area (Sq Ft)', '~ 650 – 800'),
    _QuickItem('3 BHK Carpet Area (Sq Ft)', '~ 650 – 800'),
    _QuickItem('1 Acre', '43,560 Sq Ft'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(unitConverterProvider);
    final notifier = ref.read(unitConverterProvider.notifier);

    final categoryKey = state.category.name;
    final options = unitOptions[categoryKey] ?? [];
    final results = _convert(state);
    final primaryResult = results.entries.isNotEmpty
        ? results.entries.first
        : null;

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
                    'Unit\nconverter',
                    style: text18(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Divider(),
              const SizedBox(height: 12),

              // ── Category Tabs ────────────────────────────────
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: UnitCategory.values.map((cat) {
                    final isSelected = state.category == cat;
                    return GestureDetector(
                      onTap: () => notifier.setCategory(cat),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.grey300,
                          ),
                        ),
                        child: Text(
                          _categoryLabels[cat]!,
                          style: text13(
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? AppColors.white
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),

              // ── Input Row ────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.grey200),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.grey200),
                      ),
                      child: Row(
                        children: [
                          // Number input
                          Expanded(
                            child: TextField(
                              controller:
                                  TextEditingController(
                                      text: state.inputValue.toInt().toString(),
                                    )
                                    ..selection = TextSelection.collapsed(
                                      offset: state.inputValue
                                          .toInt()
                                          .toString()
                                          .length,
                                    ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              style: text20(fontWeight: FontWeight.w600),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                              ),
                              onChanged: (v) {
                                final parsed = double.tryParse(v);
                                if (parsed != null) {
                                  notifier.setInputValue(parsed);
                                }
                              },
                            ),
                          ),
                          // Unit dropdown
                          Container(
                            margin: const EdgeInsets.only(right: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: AppColors.card,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.grey200),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: state.inputUnit,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: AppColors.textSecondary,
                                ),
                                style: text13(fontWeight: FontWeight.w600),
                                onChanged: (v) {
                                  if (v != null) notifier.setInputUnit(v);
                                },
                                items: options
                                    .map(
                                      (u) => DropdownMenuItem(
                                        value: u,
                                        child: Text(u),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Primary Result ───────────────────────────────
                    if (primaryResult != null) ...[
                      Center(
                        child: Column(
                          children: [
                            Text(
                              _formatResult(primaryResult.value),
                              style: text30(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            Text(
                              primaryResult.key,
                              style: text12(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // ── Result Grid ──────────────────────────────────
                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: results.entries.map((e) {
                        return Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.grey200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _formatResult(e.value),
                                style: text16(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                e.key,
                                style: text11(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Quick Conversions ────────────────────────────
              if (state.category == UnitCategory.area) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.grey200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quick Conversions',
                        style: text14(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 12),
                      ..._quickConversions.map(
                        (item) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          margin: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: AppColors.grey300),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item.label,
                                  style: text12(color: AppColors.textSecondary),
                                ),
                                Text(
                                  item.value,
                                  style: text12(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Divider(color: AppColors.grey200),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.info_outline,
                            size: 13,
                            color: AppColors.grey400,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'All conversions are approximate',
                            style: text11(color: AppColors.grey400),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Map<String, double> _convert(UnitConverterState state) {
    switch (state.category) {
      case UnitCategory.area:
        return convertArea(state.inputValue, state.inputUnit);
      case UnitCategory.length:
        return convertLength(state.inputValue, state.inputUnit);
      case UnitCategory.volume:
        return convertVolume(state.inputValue, state.inputUnit);
      case UnitCategory.weight:
        return convertWeight(state.inputValue, state.inputUnit);
    }
  }

  String _formatResult(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(2)}M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(2)}K';
    return v.toStringAsFixed(2);
  }
}

class _QuickItem {
  final String label;
  final String value;
  const _QuickItem(this.label, this.value);
}
