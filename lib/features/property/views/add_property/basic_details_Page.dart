import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/property/providers/property_add_provider.dart';
import 'package:gharmb_app/features/property/widget/listing_widget.dart';
import 'package:gharmb_app/routes/app_page.dart';
import 'package:gharmb_app/shared/button/custom_button.dart';
import 'package:gharmb_app/shared/widget/custom_stepprogress.dart';
import 'package:go_router/go_router.dart';

class BasicDetailsPage extends ConsumerWidget {
  const BasicDetailsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(listPropertyProvider);
    final notifier = ref.read(listPropertyProvider.notifier);

    final isComm = state.isCommercial;

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
            Text('Basic details', style: text16(fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            StepProgress(current: 1, total: 5),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 1. Property Category Toggle ──────────────────────────────
            _CategoryToggle(
              selected: state.category,
              onChanged: notifier.setCategory,
            ),
            const SizedBox(height: 20),

            // ── 2. Listing For ───────────────────────────────────────────
            // Commercial hides PG
            const FieldLabel('Listing for'),
            Wrap(
              spacing: 8,
              children: ListingFor.values
                  .where((v) => !(isComm && v == ListingFor.pg))
                  .map((v) {
                    final sel = state.listingFor.contains(v);
                    return SelectorChip(
                      label: v.label,
                      isSelected: sel,
                      onTap: () => notifier.toggleListingFor(v),
                    );
                  })
                  .toList(),
            ),
            const SizedBox(height: 18),

            // ── 3A. RESIDENTIAL: Property type ──────────────────────────
            if (!isComm) ...[
              const FieldLabel('Property type'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: PropertyTypeList.values.map((v) {
                  final sel = state.propertyType == v;
                  return SelectorChip(
                    label: v.label,
                    isSelected: sel,
                    onTap: () => notifier.setPropertyType(v),
                  );
                }).toList(),
              ),
              const SizedBox(height: 18),
            ],

            // ── 3B. COMMERCIAL: Property sub-type grid ───────────────────
            if (isComm) ...[
              const FieldLabel('Commercial type'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: CommercialType.values.map((v) {
                  final sel = state.commercialType == v;
                  return SelectorChip(
                    label: v.label,
                    isSelected: sel,
                    onTap: () => notifier.setCommercialType(v),
                  );
                }).toList(),
              ),
              const SizedBox(height: 18),
            ],

            // ── 4. Property Title ────────────────────────────────────────
            const FieldLabel('Property title'),
            ListingTextField(
              hint: isComm
                  ? 'e.g. Ground floor retail shop, Sector 18'
                  : '3 BHK Apartment, Sector 62 Noida',
              onChanged: notifier.setPropertyTitle,
            ),
            const SizedBox(height: 18),

            // ── 5. City + Locality ───────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const FieldLabel('City'),
                      ListingTextField(
                        hint: 'Noida',
                        onChanged: notifier.setCity,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const FieldLabel('Locality / area'),
                      ListingTextField(
                        hint: 'Sector 18',
                        onChanged: notifier.setLocality,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // ── 6. Full Address ──────────────────────────────────────────
            const FieldLabel('Full address'),
            ListingTextField(
              hint: isComm
                  ? 'Shop no, complex name, street…'
                  : 'A-304, Skyline Heights, Sector 62…',
              onChanged: notifier.setFullAddress,
            ),
            const SizedBox(height: 18),

            // ── 7. Pincode ───────────────────────────────────────────────
            const FieldLabel('Pincode'),
            ListingTextField(
              hint: '282203',
              keyboardType: TextInputType.number,
              onChanged: notifier.setPincode,
            ),
            const SizedBox(height: 18),

            // ── 8. RESIDENTIAL RENT-ONLY: PG fields ─────────────────────
            if (state.showPgFields) ...[
              _InfoBanner(
                color: const Color(0xFFFFF3E0),
                borderColor: const Color(0xFFFFCC80),
                icon: '🏠',
                text:
                    'PG listing — mention rules like no smoking, vegetarian only etc. in description.',
              ),
              const SizedBox(height: 14),
            ],

            // ── 9. Context banner based on category + listing type ───────
            _ListingContextBanner(state: state),
            const SizedBox(height: 18),

            // ── 10. Description ──────────────────────────────────────────
            const FieldLabel('Description'),
            ListingTextField(
              hint: isComm
                  ? 'High footfall area, near metro gate 2, ground floor corner shop…'
                  : 'Describe the property — views, condition, unique features…',
              maxLines: 4,
              onChanged: notifier.setDescription,
            ),
            const SizedBox(height: 28),

            // ── Next ─────────────────────────────────────────────────────
            SafeArea(
              child: AppButton(
                title: 'Next',
                onTap: () => context.pushNamed(AppPage.propertySpecsName),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Category Toggle (Residential / Commercial)
// ─────────────────────────────────────────────────────────────────────────────

class _CategoryToggle extends StatelessWidget {
  final PropertyCategory selected;
  final ValueChanged<PropertyCategory> onChanged;

  const _CategoryToggle({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: PropertyCategory.values.map((cat) {
          final isSelected = cat == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 11),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      cat == PropertyCategory.residential ? '🏠' : '🏪',
                      style: const TextStyle(fontSize: 15),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      cat.label,
                      style: text13(
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? AppColors.white
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Context Banner — shows relevant info based on category + listing type
// ─────────────────────────────────────────────────────────────────────────────

class _ListingContextBanner extends StatelessWidget {
  final ListPropertyState state;
  const _ListingContextBanner({required this.state});

  @override
  Widget build(BuildContext context) {
    // Determine what to show
    if (state.isCommercial && state.isSale) {
      return _InfoBanner(
        color: const Color(0xFFE1F5EE),
        borderColor: const Color(0xFF1D9E75),
        icon: '🏪',
        text:
            'Commercial sale — include price, carpet area & legal clearance status in description for faster verification.',
      );
    }
    if (state.isCommercial && (state.isRent || state.isLease)) {
      return _InfoBanner(
        color: const Color(0xFFE1F5EE),
        borderColor: const Color(0xFF1D9E75),
        icon: '📋',
        text:
            'Commercial rent / lease — mention lock-in period, CAM charges, and escalation clause in description.',
      );
    }
    if (state.isResidential && state.isSale) {
      return _InfoBanner(
        color: const Color(0xFFFDE8DC),
        borderColor: AppColors.primary,
        icon: '✅',
        text:
            'Sale listing — our admin will verify your identity and property documents before going live. Genuine buyers only.',
      );
    }
    if (state.isResidential && state.isRent) {
      return _InfoBanner(
        color: const Color(0xFFFDE8DC),
        borderColor: AppColors.primary,
        icon: '🔑',
        text:
            'Rent listing — mention preferred tenant type (family / bachelor / any), pet policy and notice period.',
      );
    }
    if (state.isResidential && state.isLease) {
      return _InfoBanner(
        color: const Color(0xFFFDE8DC),
        borderColor: AppColors.primary,
        icon: '📜',
        text:
            'Lease listing — mention lease duration, lock-in period and refundable deposit amount.',
      );
    }
    // Default
    return _InfoBanner(
      color: const Color(0xFFFDE8DC),
      borderColor: AppColors.primary,
      icon: '✅',
      text:
          'Our admin will verify your identity and property documents before your listing goes live. Genuine buyers only.',
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reusable Info Banner
// ─────────────────────────────────────────────────────────────────────────────

class _InfoBanner extends StatelessWidget {
  final Color color;
  final Color borderColor;
  final String icon;
  final String text;

  const _InfoBanner({
    required this.color,
    required this.borderColor,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: Container(
        key: ValueKey(text),
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor.withOpacity(0.5)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(icon, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: text12(
                  color: AppColors.textSecondary,
                ).copyWith(height: 1.55),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
