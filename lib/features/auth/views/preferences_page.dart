import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/auth/providers/onboarding_provider.dart';
import 'package:gharmb_app/routes/app_page.dart';
import 'package:gharmb_app/shared/button/custom_button.dart';
import 'package:gharmb_app/shared/widget/custom_stepprogress.dart';
import 'package:go_router/go_router.dart';

class PreferencesPage extends ConsumerWidget {
  const PreferencesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StepProgress(current: 3, total: 3),
                    const SizedBox(height: 24),
                    Text(
                      'Your preferences',
                      style: text24(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Help us show you what matters',
                      style: text14(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 28),

                    Text(
                      'Property type',
                      style: text13(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: PropertyType.values.map((type) {
                        final selected = state.propertyTypes.contains(type);
                        return _FilterChip(
                          label: type.label,
                          isSelected: selected,
                          onTap: () => notifier.togglePropertyType(type),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 28),

                    Text(
                      'Budget range',
                      style: text13(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      state.budgetLabel,
                      style: text14(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _BudgetSlider(
                      range: RangeValues(
                        state.budgetRange.start,
                        state.budgetRange.end,
                      ),
                      onChanged: (v) => notifier.setBudgetRange(v),
                    ),
                    const SizedBox(height: 28),

                    Text(
                      'Preferred city / area',
                      style: text13(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      onChanged: notifier.setCity,
                      style: text14(),
                      decoration: InputDecoration(
                        hintText: 'e.g. Noida, Gurgaon, Mumbai...',
                        hintStyle: text14(color: AppColors.hintText),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColors.grey300,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColors.grey300,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    Text(
                      'Bedrooms',
                      style: text13(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: BedroomCount.values.map((b) {
                        final selected = state.bedrooms.contains(b);
                        return _FilterChip(
                          label: b.label,
                          isSelected: selected,
                          onTap: () => notifier.toggleBedroom(b),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: AppButton(
                title: "Continue",
                onTap: () {
                  context.pushNamed(AppPage.allSetName);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// ─── Filter Chip ──────────────────────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.grey300,
            width: 1.2,
          ),
        ),
        child: Text(
          label,
          style: text13(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? AppColors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

// ─── Budget Slider ────────────────────────────────────────────────────────────

class _BudgetSlider extends StatelessWidget {
  final RangeValues range;
  final ValueChanged<RangeValues> onChanged;

  const _BudgetSlider({required this.range, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: AppColors.primary,
        inactiveTrackColor: AppColors.grey200,
        thumbColor: AppColors.white,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
        overlayColor: AppColors.primary.withOpacity(0.15),
        trackHeight: 2,
      ),
      child: RangeSlider(
        min: 0,
        max: 500,
        values: RangeValues(range.start, range.end),
        onChanged: onChanged,
        activeColor: AppColors.primary,
        inactiveColor: AppColors.grey200,
      ),
    );
  }
}
