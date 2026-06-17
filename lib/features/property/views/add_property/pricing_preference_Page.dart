import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/property/providers/property_add_provider.dart';
import 'package:gharmb_app/features/property/widget/listing_widget.dart';
import 'package:gharmb_app/routes/app_page.dart';
import 'package:gharmb_app/shared/button/custom_button.dart';
import 'package:gharmb_app/shared/widget/custom_stepprogress.dart';
import 'package:gharmb_app/shared/widget/custom_switch_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';

class PricingPreferencesPage extends ConsumerWidget {
  const PricingPreferencesPage({super.key});

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
          onTap: () {
            context.pop();
          },
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
              "Pricing & preferences",
              style: text16(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 2),
            StepProgress(current: 4, total: 5),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Expected Price ───────────────────────────────────
                  const FieldLabel('Expected price'),
                  _PriceInputField(
                    hint: '₹ 85,00,000',
                    initialValue: state.expectedPrice,
                    onChanged: notifier.setExpectedPrice,
                  ),
                  const SizedBox(height: 18),

                  // ── Price Negotiable? ────────────────────────────────
                  const FieldLabel('Price negotiable?'),
                  Wrap(
                    spacing: 8,
                    children: PriceNegotiable.values.map((v) {
                      final sel = state.priceNegotiable == v;
                      return SelectorChip(
                        label: v.label,
                        isSelected: sel,
                        onTap: () => notifier.setPriceNegotiable(v),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 18),

                  // ── Maintenance + Possession ─────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const FieldLabel('Maintenance / mo'),
                            _OrangeFilledField(
                              hint: '₹3,500',
                              value: state.maintenancePerMonth,
                              onChanged: notifier.setMaintenance,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const FieldLabel('Possession'),
                            _PossessionDropdown(
                              value: state.possession,
                              onChanged: notifier.setPossession,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ── Buyer Preferences ────────────────────────────────
                  Text(
                    'Buyer preferences',
                    style: text16(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 14),
                  _TogglePrefRow(
                    title: 'Vastu compliant',
                    subtitle: 'Mark if property is Vastu certified',
                    value: state.vastuCompliant,
                    onChanged: notifier.setVastu,
                  ),
                  _TogglePrefRow(
                    title: 'Open to all buyers',
                    subtitle: 'No religion / community restriction',
                    value: state.openToAllBuyers,
                    onChanged: notifier.setOpenToAll,
                  ),
                  _TogglePrefRow(
                    title: 'Loan assistance needed',
                    subtitle: 'Admin can help coordinate home loan',
                    value: state.loanAssistanceNeeded,
                    onChanged: notifier.setLoanAssistance,
                    showDivider: false,
                  ),
                  const SizedBox(height: 24),

                  // ── Listing Type ─────────────────────────────────────
                  Text(
                    'Buyer preferences',
                    style: text16(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _ListingTypeTile(
                    title: 'Standard listing',
                    subtitle: 'Goes live after verification · free',
                    type: ListingType.standard,
                    selected: state.listingType,
                    price: null,
                    onTap: () => notifier.setListingType(ListingType.standard),
                  ),
                  const SizedBox(height: 10),
                  _ListingTypeTile(
                    title: 'Featured listing',
                    subtitle: 'Top of search · Highlighted badge',
                    type: ListingType.featured,
                    selected: state.listingType,
                    price: '₹999',
                    onTap: () => notifier.setListingType(ListingType.featured),
                  ),
                  const SizedBox(height: 10),
                  _ListingTypeTile(
                    title: 'Premium listing',
                    subtitle: 'Priority admin processing · map pin boost',
                    type: ListingType.premium,
                    selected: state.listingType,
                    price: '₹1,999',
                    onTap: () => notifier.setListingType(ListingType.premium),
                  ),
                  const SizedBox(height: 28),

                  // ── Submit ───────────────────────────────────────────
                  SafeArea(
                    child: AppButton(
                      title: 'Review & submit listing',
                      onTap: () {
                        context.pushNamed(AppPage.reviewSubmitName);
                      },
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

// ─── Price Input (large orange style) ────────────────────────────────────────

class _PriceInputField extends StatelessWidget {
  final String hint;
  final String initialValue;
  final ValueChanged<String> onChanged;

  const _PriceInputField({
    required this.hint,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onChanged: onChanged,
      style: text18(fontWeight: FontWeight.bold, color: AppColors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: text16(
          fontWeight: FontWeight.bold,
          color: Colors.white.withOpacity(0.8),
        ),
        filled: true,
        fillColor: AppColors.primary,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        prefixText: '₹ ',
        prefixStyle: text18(
          fontWeight: FontWeight.bold,
          color: AppColors.white,
        ),
      ),
    );
  }
}

// ─── Orange Filled Field (Maintenance) ───────────────────────────────────────

class _OrangeFilledField extends StatelessWidget {
  final String hint;
  final String value;
  final ValueChanged<String> onChanged;

  const _OrangeFilledField({
    required this.hint,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.number,
      onChanged: onChanged,
      style: text14(fontWeight: FontWeight.w600, color: AppColors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: text14(color: Colors.white.withOpacity(0.8)),
        filled: true,
        fillColor: AppColors.primary,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

// ─── Possession Dropdown (orange filled) ─────────────────────────────────────

class _PossessionDropdown extends StatelessWidget {
  final PossessionStatus value;
  final ValueChanged<PossessionStatus> onChanged;

  const _PossessionDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton<PossessionStatus>(
        value: value,
        isExpanded: true,
        dropdownColor: AppColors.primary,
        underline: const SizedBox(),
        icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.white),
        style: text14(fontWeight: FontWeight.w600, color: AppColors.white),
        items: PossessionStatus.values
            .map(
              (v) => DropdownMenuItem(
                value: v,
                child: Text(
                  _possessionLabel(v),
                  style: text14(
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: (v) => v != null ? onChanged(v) : null,
      ),
    );
  }

  String _possessionLabel(PossessionStatus s) => switch (s) {
    PossessionStatus.immediate => 'Immediate',
    PossessionStatus.within1Month => 'Within 1 Month',
    PossessionStatus.within3Months => 'Within 3 Months',
    PossessionStatus.within6Months => 'Within 6 Months',
  };
}

// ─── Toggle Preference Row ────────────────────────────────────────────────────

class _TogglePrefRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool showDivider;

  const _TogglePrefRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: text13(fontWeight: FontWeight.w500)),
                    Text(
                      subtitle,
                      style: text11(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              CustomSwitch(value: value, onChanged: onChanged),
            ],
          ),
        ),
        if (showDivider) const Divider(height: 1, color: AppColors.grey100),
      ],
    );
  }
}

// ─── Listing Type Tile ────────────────────────────────────────────────────────

class _ListingTypeTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final ListingType type;
  final ListingType selected;
  final String? price;
  final VoidCallback onTap;

  const _ListingTypeTile({
    required this.title,
    required this.subtitle,
    required this.type,
    required this.selected,
    required this.price,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = type == selected;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.04)
              : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.grey200,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: text14(fontWeight: FontWeight.w600)),
                  Text(subtitle, style: text11(color: AppColors.textSecondary)),
                ],
              ),
            ),
            if (price != null)
              Text(
                price!,
                style: text14(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              )
            else if (isSelected)
              Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: AppColors.white,
                  size: 14,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
