import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/property/providers/property_add_provider.dart';
import 'package:gharmb_app/features/property/widget/listing_widget.dart';
import 'package:gharmb_app/routes/app_page.dart';
import 'package:gharmb_app/shared/button/custom_button.dart';
import 'package:gharmb_app/shared/widget/custom_stepprogress.dart';
import 'package:gharmb_app/shared/widget/custom_switch_widget.dart';
import 'package:go_router/go_router.dart';

class PropertySpecsPage extends ConsumerWidget {
  const PropertySpecsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(listPropertyProvider);
    final notifier = ref.read(listPropertyProvider.notifier);

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
            Text(
              state.isCommercial ? 'Commercial specs' : 'Property specs',
              style: text16(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            StepProgress(current: 2, total: 5),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: state.isCommercial
            ? _CommercialSpecs(state: state, notifier: notifier)
            : _ResidentialSpecs(state: state, notifier: notifier),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// RESIDENTIAL SPECS
// ═════════════════════════════════════════════════════════════════════════════

class _ResidentialSpecs extends StatelessWidget {
  final ListPropertyState state;
  final ListPropertyNotifier notifier;

  const _ResidentialSpecs({required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    final isSale = state.isSale;
    final isRent = state.isRent || state.isLease;
    final isPg = state.isPg;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Bedrooms + Bathrooms ─────────────────────────────────────────
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FieldLabel('Bedrooms (BHK)'),
                  NumberSelectorRow(
                    options: ['1', '2', '3', '4+'],
                    selected: state.bedrooms > 3 ? '4+' : '${state.bedrooms}',
                    onSelect: (v) =>
                        notifier.setBedrooms(v == '4+' ? 4 : int.parse(v)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FieldLabel('Bathrooms'),
                  NumberSelectorRow(
                    options: ['1', '2', '3', '4+'],
                    selected: state.bathrooms > 3 ? '4+' : '${state.bathrooms}',
                    onSelect: (v) =>
                        notifier.setBathrooms(v == '4+' ? 4 : int.parse(v)),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),

        // ── Carpet + Built-up ────────────────────────────────────────────
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FieldLabel('Carpet area (sqft)'),
                  ListingTextField(
                    hint: '1,450',
                    keyboardType: TextInputType.number,
                    onChanged: notifier.setCarpetArea,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FieldLabel('Built-up area (sqft)'),
                  ListingTextField(
                    hint: '1,680',
                    keyboardType: TextInputType.number,
                    onChanged: notifier.setBuiltUpArea,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),

        // ── Floor + Total floors ─────────────────────────────────────────
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FieldLabel('Floor no'),
                  ListingTextField(
                    hint: '8',
                    keyboardType: TextInputType.number,
                    onChanged: notifier.setFloorNo,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FieldLabel('Total floors'),
                  ListingTextField(
                    hint: '18',
                    keyboardType: TextInputType.number,
                    onChanged: notifier.setTotalFloors,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),

        // ── Age of property ──────────────────────────────────────────────
        const FieldLabel('Age of property'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AgeOfProperty.values.map((v) {
            final sel = state.ageOfProperty == v;
            return SelectorChip(
              label: v.label,
              isSelected: sel,
              onTap: () => notifier.setAge(v),
            );
          }).toList(),
        ),
        const SizedBox(height: 18),

        // ── Furnishing ───────────────────────────────────────────────────
        const FieldLabel('Furnishing'),
        Wrap(
          spacing: 8,
          children: Furnishing.values.map((v) {
            final sel = state.furnishing == v;
            return SelectorChip(
              label: v.label,
              isSelected: sel,
              onTap: () => notifier.setFurnishing(v),
            );
          }).toList(),
        ),
        const SizedBox(height: 18),

        // ── Facing ───────────────────────────────────────────────────────
        const FieldLabel('Facing direction'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: FacingDirection.values.map((v) {
            final sel = state.facing.contains(v);
            return SelectorChip(
              label: v.label,
              isSelected: sel,
              onTap: () => notifier.toggleFacing(v),
            );
          }).toList(),
        ),
        const SizedBox(height: 18),

        // ── Parking ──────────────────────────────────────────────────────
        const FieldLabel('Parking'),
        Wrap(
          spacing: 8,
          children: ParkingType.values.map((v) {
            final sel = state.parking == v;
            return SelectorChip(
              label: v.label,
              isSelected: sel,
              onTap: () => notifier.setParking(v),
            );
          }).toList(),
        ),
        const SizedBox(height: 18),

        // ── Amenities ────────────────────────────────────────────────────
        const FieldLabel('Amenities available'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AmenityList.values.map((v) {
            final sel = state.amenities.contains(v);
            return SelectorChip(
              label: v.label,
              isSelected: sel,
              onTap: () => notifier.toggleAmenity(v),
            );
          }).toList(),
        ),
        const SizedBox(height: 18),

        // ── RENT / LEASE / PG specific ───────────────────────────────────
        // ── RENT / LEASE / PG specific ───────────────────────────────────
        if (isRent || isPg) ...[
          const _SectionDivider(title: 'Rental details'),

          // ── Preferred tenants ────────────────────────────────────────
          const FieldLabel('Preferred tenants'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['Family', 'Bachelors', 'Working professionals', 'Any']
                .map(
                  (t) => SelectorChip(
                    label: t,
                    isSelected: state.preferredTenant == t,
                    onTap: () => notifier.setPreferredTenant(t),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 14),

          // ── No pets / No smoking toggles ─────────────────────────────
          _ToggleRow(
            title: 'Pets allowed',
            value: state.petsAllowed,
            onChanged: notifier.setPetsAllowed,
          ),
          _ToggleRow(
            title: 'Smoking allowed',
            value: state.smokingAllowed,
            onChanged: notifier.setSmokingAllowed,
          ),

          // ── Notice period (rent/lease only) ──────────────────────────
          if (!isPg) ...[
            const SizedBox(height: 14),
            const FieldLabel('Notice period'),
            Wrap(
              spacing: 8,
              children: ['15 days', '1 month', '2 months', '3 months']
                  .map(
                    (t) => SelectorChip(
                      label: t,
                      isSelected: state.noticePeriod == t,
                      onTap: () => notifier.setNoticePeriod(t),
                    ),
                  )
                  .toList(),
            ),
          ],

          // ── PG: food included / occupancy — still not wired, see note below ──
          if (isPg) ...[
            // unchanged for now — no matching state field exists yet
          ],
          const SizedBox(height: 18),
        ],

        // ── SALE specific ────────────────────────────────────────────────
        if (isSale) ...[
          const _SectionDivider(title: 'Sale details'),
          _ToggleRow(
            title: 'Loan approved property',
            value: false,
            onChanged: (_) {},
          ),
          _ToggleRow(
            title: 'OC / CC received',
            subtitle: 'Occupancy / completion certificate',
            value: false,
            onChanged: (_) {},
          ),
          const SizedBox(height: 18),
        ],

        // ── Next ─────────────────────────────────────────────────────────
        SafeArea(
          child: AppButton(
            title: 'Next',
            onTap: () => context.pushNamed(AppPage.photosVideoName),
          ),
        ),
      ],
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// COMMERCIAL SPECS
// ═════════════════════════════════════════════════════════════════════════════

class _CommercialSpecs extends StatelessWidget {
  final ListPropertyState state;
  final ListPropertyNotifier notifier;

  const _CommercialSpecs({required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    final isRentOrLease = state.isRent || state.isLease;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Carpet + Built-up ────────────────────────────────────────────
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FieldLabel('Carpet area (sqft)'),
                  ListingTextField(
                    hint: '500',
                    keyboardType: TextInputType.number,
                    onChanged: notifier.setCommercialCarpetArea,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FieldLabel('Built-up area (sqft)'),
                  ListingTextField(
                    hint: '620',
                    keyboardType: TextInputType.number,
                    onChanged: notifier.setCommercialBuiltUpArea,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),

        // ── Floor + Total floors ─────────────────────────────────────────
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FieldLabel('Floor'),
                  ListingTextField(
                    hint: 'Ground / 1 / 2…',
                    onChanged: notifier.setCommercialFloor,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FieldLabel('Total floors'),
                  ListingTextField(
                    hint: '4',
                    keyboardType: TextInputType.number,
                    onChanged: notifier.setCommercialTotalFloors,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),

        // ── Frontage ─────────────────────────────────────────────────────
        const FieldLabel('Frontage (ft)'),
        ListingTextField(
          hint: 'Width of shop / office front',
          keyboardType: TextInputType.number,
          onChanged: notifier.setFrontage,
        ),
        const SizedBox(height: 18),

        // ── Ceiling height ───────────────────────────────────────────────
        const FieldLabel('Ceiling height'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: CeilingHeight.values.map((v) {
            final sel = state.ceilingHeight == v;
            return SelectorChip(
              label: v.label,
              isSelected: sel,
              onTap: () => notifier.setCeilingHeight(v),
            );
          }).toList(),
        ),
        const SizedBox(height: 18),

        // ── Power load ───────────────────────────────────────────────────
        const FieldLabel('Power load (kW)'),
        ListingTextField(
          hint: 'e.g. 5 kW (optional)',
          keyboardType: TextInputType.number,
          onChanged: notifier.setPowerLoad,
        ),
        const SizedBox(height: 18),

        // ── Parking ──────────────────────────────────────────────────────
        const FieldLabel('Parking'),
        Wrap(
          spacing: 8,
          children: CommercialParking.values.map((v) {
            final sel = state.commercialParking == v;
            return SelectorChip(
              label: v.label,
              isSelected: sel,
              onTap: () => notifier.setCommercialParking(v),
            );
          }).toList(),
        ),
        const SizedBox(height: 18),

        // ── Facilities ───────────────────────────────────────────────────
        const FieldLabel('Facilities available'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: CommercialFacilities.values.map((v) {
            final sel = state.facilities.contains(v);
            return SelectorChip(
              label: v.label,
              isSelected: sel,
              onTap: () => notifier.toggleFacility(v),
            );
          }).toList(),
        ),
        const SizedBox(height: 18),

        // ── Age ──────────────────────────────────────────────────────────
        const FieldLabel('Property age'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AgeOfProperty.values.map((v) {
            final sel = state.commercialAge == v;
            return SelectorChip(
              label: v.label,
              isSelected: sel,
              onTap: () => notifier.setCommercialAge(v),
            );
          }).toList(),
        ),
        const SizedBox(height: 18),

        // ── RENT / LEASE specific ────────────────────────────────────────
        if (isRentOrLease) ...[
          const _SectionDivider(title: 'Rental terms'),

          // Lock-in period
          const FieldLabel('Lock-in period'),
          Wrap(
            spacing: 8,
            children: ['None', '6 months', '1 year', '2 years', '3 years']
                .map(
                  (t) =>
                      SelectorChip(label: t, isSelected: false, onTap: () {}),
                )
                .toList(),
          ),
          const SizedBox(height: 14),

          // CAM charges
          const FieldLabel('CAM charges included in rent?'),
          Wrap(
            spacing: 8,
            children: ['Yes', 'No', 'Partially']
                .map(
                  (t) =>
                      SelectorChip(label: t, isSelected: false, onTap: () {}),
                )
                .toList(),
          ),
          const SizedBox(height: 14),

          // Brokerage free toggle
          _ToggleRow(
            title: 'Brokerage free',
            subtitle: 'Mark if you are dealing directly with tenant',
            value: state.brokerageFree,
            onChanged: notifier.setBrokerageFree,
          ),
          const SizedBox(height: 18),
        ],

        // ── SALE specific ────────────────────────────────────────────────
        if (state.isSale) ...[
          const _SectionDivider(title: 'Sale details'),
          _ToggleRow(
            title: 'OC / CC received',
            subtitle: 'Occupancy / completion certificate',
            value: false,
            onChanged: (_) {},
          ),
          _ToggleRow(title: 'RERA registered', value: false, onChanged: (_) {}),
          const SizedBox(height: 18),
        ],

        // ── Next ─────────────────────────────────────────────────────────
        SafeArea(
          child: AppButton(
            title: 'Next',
            onTap: () => context.pushNamed(AppPage.photosVideoName),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared small widgets
// ─────────────────────────────────────────────────────────────────────────────

class _SectionDivider extends StatelessWidget {
  final String title;
  const _SectionDivider({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Text(
            title,
            style: text13(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(child: Divider(color: AppColors.grey200, height: 1)),
        ],
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: text13(fontWeight: FontWeight.w500)),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: text11(color: AppColors.textSecondary),
                  ),
              ],
            ),
          ),
          CustomSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
