import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/home/providers/filter_provider.dart';
import 'package:gharmb_app/features/home/widget/custom_widget.dart';

class FilterBottomSheet extends ConsumerWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(filterProvider);
    final notifier = ref.read(filterProvider.notifier);
    final screenH = MediaQuery.of(context).size.height;

    return Container(
      height: screenH * 0.92,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.grey300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text('Filters', style: text18(fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${filter.activeFilterCount}',
                    style: text11(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.grey200),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Looking For ──────────────────────────────────────
                  _FilterSection(
                    title: 'Looking for',
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: LookingFor.values.map((v) {
                        final sel = filter.lookingFor.contains(v);
                        return _Chip(
                          label: v.label,
                          isSelected: sel,
                          onTap: () => notifier.toggleLookingFor(v),
                        );
                      }).toList(),
                    ),
                  ),

                  // ── Property Type ────────────────────────────────────
                  _FilterSection(
                    title: 'Property type',
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: PropertyType.values.map((v) {
                        final sel = filter.propertyTypes.contains(v);
                        return _Chip(
                          label: v.label,
                          isSelected: sel,
                          onTap: () => notifier.togglePropertyType(v),
                        );
                      }).toList(),
                    ),
                  ),

                  // ── Budget ───────────────────────────────────────────
                  _FilterSection(
                    title: 'Budget range',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '₹${filter.budgetRange.start.toInt()}L',
                              style: text12(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '₹${filter.budgetRange.end.toInt()}Cr',
                              style: text12(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: AppColors.primary,
                            inactiveTrackColor: AppColors.grey200,
                            thumbColor: AppColors.white,
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 10,
                            ),
                            overlayColor: AppColors.primary.withOpacity(0.15),
                            trackHeight: 4,
                          ),
                          child: RangeSlider(
                            min: 10,
                            max: 500,
                            values: filter.budgetRange,
                            onChanged: notifier.setBudget,
                            activeColor: AppColors.primary,
                            inactiveColor: AppColors.grey200,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Min ₹10L',
                              style: text11(color: AppColors.textSecondary),
                            ),
                            Text(
                              'Max ₹5Cr',
                              style: text11(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // ── Bedrooms ─────────────────────────────────────────
                  _FilterSection(
                    title: 'Bedrooms',
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: BedroomFilter.values.map((v) {
                        final sel = filter.bedrooms.contains(v);
                        return _Chip(
                          label: v.label,
                          isSelected: sel,
                          onTap: () => notifier.toggleBedroom(v),
                        );
                      }).toList(),
                    ),
                  ),

                  // ── Furnishing ───────────────────────────────────────
                  _FilterSection(
                    title: 'Furnishing',
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: Furnishing.values.map((v) {
                        final sel = filter.furnishing.contains(v);
                        return _Chip(
                          label: v.label,
                          isSelected: sel,
                          onTap: () => notifier.toggleFurnishing(v),
                        );
                      }).toList(),
                    ),
                  ),

                  // ── Area ─────────────────────────────────────────────
                  _FilterSection(
                    title: 'Area (sq ft)',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${filter.areaRange.start.toInt()} sq ft',
                              style: text12(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${filter.areaRange.end.toInt()} sq ft',
                              style: text12(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: AppColors.primary,
                            inactiveTrackColor: AppColors.grey200,
                            thumbColor: AppColors.white,
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 10,
                            ),
                            overlayColor: AppColors.primary.withOpacity(0.15),
                            trackHeight: 4,
                          ),
                          child: RangeSlider(
                            min: 0,
                            max: 5000,
                            values: filter.areaRange,
                            onChanged: notifier.setArea,
                            activeColor: AppColors.primary,
                            inactiveColor: AppColors.grey200,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Min 0 sq ft',
                              style: text11(color: AppColors.textSecondary),
                            ),
                            Text(
                              'Max 1400 sq ft',
                              style: text11(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // ── Posted By ────────────────────────────────────────
                  _FilterSection(
                    title: 'Posted by',
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: PostedBy.values.map((v) {
                        final sel = filter.postedBy == v;
                        return _Chip(
                          label: v.label,
                          isSelected: sel,
                          onTap: () => notifier.setPostedBy(v),
                        );
                      }).toList(),
                    ),
                  ),

                  // ── Special Filters ──────────────────────────────────
                  _FilterSection(
                    title: 'Special filters',
                    child: Column(
                      children: [
                        ToggleRow(
                          title: 'Verified properties only',
                          subtitle: 'Only show verified listings',
                          value: filter.verifiedOnly,
                          onChanged: notifier.toggleVerified,
                        ),
                        ToggleRow(
                          title: 'Ready to move in',
                          subtitle: 'Skip under-construction listings',
                          value: filter.readyToMoveIn,
                          onChanged: notifier.toggleReadyToMove,
                        ),
                        ToggleRow(
                          title: 'With Photo only',
                          subtitle: "Skip unverified listings",
                          value: filter.withPhotoOnly,
                          onChanged: notifier.togglePhotoOnly,
                        ),
                        ToggleRow(
                          title: 'Vastu compliant',
                          subtitle: 'Vastu-certified homes only',
                          value: filter.vastuCompliant,
                          onChanged: notifier.toggleVastu,
                        ),
                        ToggleRow(
                          title: 'Near metro / school',
                          subtitle: 'Nearby amenities preferred',
                          value: filter.nearMetroSchool,
                          onChanged: notifier.toggleNearMetro,
                          showDivider: false,
                        ),
                      ],
                    ),
                  ),

                  // ── Amenities ────────────────────────────────────────
                  _FilterSection(
                    title: 'Amenities',
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: Amenity.values.map((v) {
                        final sel = filter.amenities.contains(v);
                        return _AmenityChip(
                          amenity: v,
                          isSelected: sel,
                          onTap: () => notifier.toggleAmenity(v),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Showing results for 231 properties',
                      style: text12(color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // ── Bottom Buttons ───────────────────────────────────────────
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => notifier.clearAll(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.grey300),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Clear all',
                        style: text14(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Apply filters',
                        style: text14(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Filter Section Wrapper ───────────────────────────────────────────────────

class _FilterSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _FilterSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: text13(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        child,
        const SizedBox(height: 20),
        const Divider(height: 1, color: AppColors.grey100),
        const SizedBox(height: 20),
      ],
    );
  }
}

// ─── Chip ─────────────────────────────────────────────────────────────────────

class _Chip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _Chip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
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

// ─── Amenity Chip (with icon) ─────────────────────────────────────────────────

class _AmenityChip extends StatelessWidget {
  final Amenity amenity;
  final bool isSelected;
  final VoidCallback onTap;

  const _AmenityChip({
    required this.amenity,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : AppColors.grey50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.grey200,
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              amenity.icon,
              size: 15,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              amenity.label,
              style: text12(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Toggle Row ───────────────────────────────────────────────────────────────
