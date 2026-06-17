import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/project/provider/project_provider.dart';

class ProjectFilterBottomSheet extends ConsumerWidget {
  const ProjectFilterBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ProjectFilterBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(projectFilterProvider);
    final notifier = ref.read(projectFilterProvider.notifier);
    final screenH = MediaQuery.of(context).size.height;

    return Container(
      height: screenH * 0.88,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // ── Handle ────────────────────────────────────────────────
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

          // ── Header ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text('Filters', style: text18(fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                if (filter.activeCount > 0)
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
                      '${filter.activeCount}',
                      style: text11(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.close,
                    color: AppColors.textSecondary,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.grey100),

          // ── Scrollable Body ────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Sort By ─────────────────────────────────────────
                  _FilterSection(
                    title: 'Sort By',
                    child: Column(
                      children: ProjectSortBy.values.map((v) {
                        final sel = filter.sortBy == v;
                        return GestureDetector(
                          onTap: () => notifier.setSortBy(v),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: sel
                                          ? AppColors.primary
                                          : AppColors.grey400,
                                      width: sel ? 5.5 : 1.5,
                                    ),
                                    color: AppColors.white,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  v.label,
                                  style: text14(
                                    fontWeight: sel
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                    color: sel
                                        ? AppColors.textPrimary
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  // ── BHK Type ────────────────────────────────────────
                  _FilterSection(
                    title: 'BHK Type',
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ProjectBHK.values.map((v) {
                        final sel = filter.bhk.contains(v);
                        return _Chip(
                          label: v.label,
                          isSelected: sel,
                          onTap: () => notifier.toggleBHK(v),
                        );
                      }).toList(),
                    ),
                  ),

                  // ── Budget Range ────────────────────────────────────
                  _FilterSection(
                    title: 'Budget Range',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatBudget(filter.budgetRange.start),
                              style: text13(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              _formatBudget(filter.budgetRange.end),
                              style: text13(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
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

                  // ── Possession ──────────────────────────────────────
                  _FilterSection(
                    title: 'Possession',
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: PossessionFilter.values.map((v) {
                        final sel = filter.possession.contains(v);
                        return _Chip(
                          label: v.label,
                          isSelected: sel,
                          onTap: () => notifier.togglePossession(v),
                        );
                      }).toList(),
                    ),
                  ),

                  // ── Special Filters ─────────────────────────────────
                  _FilterSection(
                    title: 'Special Filters',
                    showDivider: false,
                    child: Column(
                      children: [
                        _ToggleRow(
                          icon: Icons.verified_outlined,
                          iconColor: AppColors.success,
                          title: 'RERA Approved only',
                          subtitle: 'Show only government registered projects',
                          value: filter.reraOnly,
                          onChanged: notifier.setReraOnly,
                        ),
                        const SizedBox(height: 4),
                        _ToggleRow(
                          icon: Icons.home_outlined,
                          iconColor: AppColors.primary,
                          title: 'Ready to Move',
                          subtitle: 'Immediate possession available',
                          value: filter.readyToMoveOnly,
                          onChanged: notifier.setReadyToMove,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Bottom Buttons ─────────────────────────────────────────
          Container(
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
            child: Row(
              children: [
                // Clear all
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
                // Apply
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
                      filter.activeCount > 0
                          ? 'Apply (${filter.activeCount})'
                          : 'Apply Filters',
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
        ],
      ),
    );
  }

  String _formatBudget(double v) =>
      v >= 100 ? '₹${(v / 100).toStringAsFixed(1)}Cr' : '₹${v.toInt()}L';
}

// ─── Section Wrapper ──────────────────────────────────────────────────────────

class _FilterSection extends StatelessWidget {
  final String title;
  final Widget child;
  final bool showDivider;

  const _FilterSection({
    required this.title,
    required this.child,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: text14(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        child,
        if (showDivider) ...[
          const SizedBox(height: 20),
          const Divider(height: 1, color: AppColors.grey100),
          const SizedBox(height: 20),
        ],
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(8),
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

// ─── Toggle Row ───────────────────────────────────────────────────────────────

class _ToggleRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: text13(fontWeight: FontWeight.w500)),
                Text(subtitle, style: text11(color: AppColors.textSecondary)),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.white,
            activeTrackColor: AppColors.primary,
            inactiveThumbColor: AppColors.white,
            inactiveTrackColor: AppColors.grey300,
            trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
          ),
        ],
      ),
    );
  }
}
