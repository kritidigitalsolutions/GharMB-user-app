import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
              'Pricing & preferences',
              style: text16(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            StepProgress(current: 4, total: 5),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: _PricingBody(
            key: ValueKey('${state.category}-${state.listingFor}'),
            state: state,
            notifier: notifier,
          ),
        ),
      ),
      bottomNavigationBar: _BottomBar(
        onTap: () => context.pushNamed(AppPage.reviewSubmitName),
      ),
    );
  }
}

class _PricingBody extends StatelessWidget {
  final ListPropertyState state;
  final ListPropertyNotifier notifier;

  const _PricingBody({super.key, required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    final Widget pricingFlow;
    if (state.isResidential && state.isSale) {
      pricingFlow = _ResidentialSell(state: state, notifier: notifier);
    } else if (state.isResidential && state.isRent) {
      pricingFlow = _ResidentialRent(state: state, notifier: notifier);
    } else if (state.isResidential && state.isLease) {
      pricingFlow = _ResidentialLease(state: state, notifier: notifier);
    } else if (state.isCommercial && state.isSale) {
      pricingFlow = _CommercialSell(state: state, notifier: notifier);
    } else if (state.isCommercial && state.isRent) {
      pricingFlow = _CommercialRent(state: state, notifier: notifier);
    } else if (state.isCommercial && state.isLease) {
      pricingFlow = _CommercialLease(state: state, notifier: notifier);
    } else {
      pricingFlow = _ResidentialRent(state: state, notifier: notifier);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        pricingFlow,
        _BuyerPreferencesSection(state: state, notifier: notifier),
        const SizedBox(height: 20),
        _ListingPlanSection(state: state, notifier: notifier),
      ],
    );
  }
}

class _ResidentialSell extends StatelessWidget {
  final ListPropertyState state;
  final ListPropertyNotifier notifier;

  const _ResidentialSell({required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return _Flow(
      children: [
        _Section(
          title: 'Pricing',
          children: [
            _MoneyField(
              label: 'Expected price *',
              hint: '85,00,000',
              onChanged: notifier.setExpectedPrice,
            ),
            _SwitchField(
              label: 'Taxes included in expected price?',
              value: state.taxIncluded,
              onChanged: notifier.setTaxIncluded,
            ),
            _NegotiableChips(state: state, notifier: notifier),
            _MoneyField(
              label: 'Maintenance charges (monthly)',
              hint: '3,500',
              onChanged: notifier.setMaintenance,
            ),
            _SwitchField(
              label: 'Maintenance included in expected price?',
              value: state.maintenanceIncluded,
              onChanged: notifier.setMaintenanceIncluded,
            ),
            _MoneyField(
              label: 'Booking token amount (optional)',
              hint: '51,000',
              onChanged: notifier.setBookingTokenAmount,
            ),
            _MoneyField(
              label: 'Other charges',
              hint: '10,000',
              onChanged: notifier.setOtherCharges,
            ),
          ],
        ),
        _InstallmentSection(state: state, notifier: notifier),
        _Section(
          title: 'Preferences',
          children: [
            _ChoiceField(
              label: 'Available from',
              options: _availabilityOptions,
              selected: state.availability,
              onSelected: notifier.setAvailability,
            ),
            _ChoiceField(
              label: 'Ownership type',
              options: const [
                'Freehold',
                'Leasehold',
                'Co-operative',
                'Power of Attorney',
              ],
              selected: state.ownershipType,
              onSelected: notifier.setOwnershipType,
            ),
            _FurnishingChips(state: state, notifier: notifier),
          ],
        ),
      ],
    );
  }
}

class _ResidentialRent extends StatelessWidget {
  final ListPropertyState state;
  final ListPropertyNotifier notifier;

  const _ResidentialRent({required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return _Flow(
      children: [
        _Section(
          title: 'Pricing',
          children: [
            _MoneyField(
              label: 'Monthly rent *',
              hint: '18,000',
              onChanged: notifier.setExpectedPrice,
            ),
            _MoneyField(
              label: 'Security deposit *',
              hint: '54,000',
              onChanged: notifier.setSecurityDeposit,
            ),
            _TextInput(
              label: 'Security deposit duration',
              hint: 'Enter months',
              keyboardType: TextInputType.number,
              onChanged: notifier.setSecurityDepositMonths,
            ),
            _MoneyField(
              label: 'Maintenance charges',
              hint: '2,000',
              onChanged: notifier.setMaintenance,
            ),
            _SwitchField(
              label: 'Maintenance included in rent?',
              value: state.maintenanceIncluded,
              onChanged: notifier.setMaintenanceIncluded,
            ),
            _MoneyField(
              label: 'Brokerage (optional)',
              hint: '18,000',
              onChanged: notifier.setBrokerageAmount,
            ),
            _MoneyField(
              label: 'Other charges',
              hint: '1,000',
              onChanged: notifier.setOtherCharges,
            ),
          ],
        ),
        _Section(
          title: 'Rental details',
          children: [
            _ChoiceField(
              label: 'Available from',
              options: _availabilityOptions,
              selected: state.availability,
              onSelected: notifier.setAvailability,
            ),
            _ChoiceField(
              label: 'Preferred tenant',
              options: const ['Family', 'Bachelor', 'Female', 'Male', 'Anyone'],
              selected: state.preferredTenant,
              onSelected: notifier.setPreferredTenant,
            ),
            _ChoiceField(
              label: 'Lease duration',
              options: const ['11 Months', '1 Year', '2 Years'],
              selected: state.leaseDuration,
              onSelected: notifier.setLeaseDuration,
            ),
          ],
        ),
        _Section(
          title: 'Additional',
          children: [
            _ChoiceField(
              label: 'Notice period',
              options: const ['15 Days', '1 Month', '2 Months', '3 Months'],
              selected: state.noticePeriod,
              onSelected: notifier.setNoticePeriod,
            ),
            _NegotiableChips(
              state: state,
              notifier: notifier,
              label: 'Rent negotiable',
            ),
          ],
        ),
      ],
    );
  }
}

class _ResidentialLease extends StatelessWidget {
  final ListPropertyState state;
  final ListPropertyNotifier notifier;

  const _ResidentialLease({required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return _Flow(
      children: [
        _Section(
          title: 'Pricing',
          children: [
            _MoneyField(
              label: 'Lease deposit amount *',
              hint: '5,00,000',
              onChanged: notifier.setExpectedPrice,
            ),
            _MoneyField(
              label: 'Monthly rent (optional)',
              hint: '0',
              onChanged: notifier.setMonthlyRent,
            ),
            _MoneyField(
              label: 'Maintenance charges',
              hint: '2,000',
              onChanged: notifier.setMaintenance,
            ),
            _SwitchField(
              label: 'Maintenance included in monthly rent?',
              value: state.maintenanceIncluded,
              onChanged: notifier.setMaintenanceIncluded,
            ),
            _MoneyField(
              label: 'Other charges',
              hint: '1,000',
              onChanged: notifier.setOtherCharges,
            ),
          ],
        ),
        _Section(
          title: 'Lease details',
          children: [
            _ChoiceField(
              label: 'Lease duration *',
              options: const ['1 Year', '3 Years', '5 Years', '9 Years'],
              selected: state.leaseDuration,
              onSelected: notifier.setLeaseDuration,
            ),
            _LockInChips(state: state, notifier: notifier),
          ],
        ),
        _Section(
          title: 'Preferences',
          children: [
            _ChoiceField(
              label: 'Available from',
              options: _availabilityOptions,
              selected: state.availability,
              onSelected: notifier.setAvailability,
            ),
            _ChoiceField(
              label: 'Preferred tenant',
              options: const ['Family', 'Bachelor', 'Female', 'Male', 'Anyone'],
              selected: state.preferredTenant,
              onSelected: notifier.setPreferredTenant,
            ),
          ],
        ),
      ],
    );
  }
}

class _CommercialSell extends StatelessWidget {
  final ListPropertyState state;
  final ListPropertyNotifier notifier;

  const _CommercialSell({required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return _Flow(
      children: [
        _Section(
          title: 'Pricing',
          children: [
            _MoneyField(
              label: 'Expected price *',
              hint: '48,00,000',
              onChanged: notifier.setExpectedPrice,
            ),
            _SwitchField(
              label: 'Taxes included in expected price?',
              value: state.taxIncluded,
              onChanged: notifier.setTaxIncluded,
            ),
            _NegotiableChips(state: state, notifier: notifier),
            _MoneyField(
              label: 'Maintenance charges',
              hint: '5,000',
              onChanged: notifier.setMaintenance,
            ),
            _SwitchField(
              label: 'Maintenance included in expected price?',
              value: state.maintenanceIncluded,
              onChanged: notifier.setMaintenanceIncluded,
            ),
            _MoneyField(
              label: 'Other charges',
              hint: '10,000',
              onChanged: notifier.setOtherCharges,
            ),
          ],
        ),
        _InstallmentSection(state: state, notifier: notifier),
        _Section(
          title: 'Availability',
          children: [
            _ChoiceField(
              label: 'Availability',
              options: const ['Immediate', 'Specific Date'],
              selected: state.availability,
              onSelected: notifier.setAvailability,
            ),
          ],
        ),
      ],
    );
  }
}

class _CommercialRent extends StatelessWidget {
  final ListPropertyState state;
  final ListPropertyNotifier notifier;

  const _CommercialRent({required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return _Flow(
      children: [
        _Section(
          title: 'Pricing',
          children: [
            _MoneyField(
              label: 'Monthly rent *',
              hint: '48,000',
              onChanged: notifier.setExpectedPrice,
            ),
            _MoneyField(
              label: 'Security deposit *',
              hint: '1,44,000',
              onChanged: notifier.setSecurityDeposit,
            ),
            _TextInput(
              label: 'Security deposit duration',
              hint: 'Enter months',
              keyboardType: TextInputType.number,
              onChanged: notifier.setSecurityDepositMonths,
            ),
            _MoneyField(
              label: 'Maintenance charges *',
              hint: '5,000',
              onChanged: notifier.setMaintenance,
            ),
            _SwitchField(
              label: 'Maintenance included in rent?',
              value: state.maintenanceIncluded,
              onChanged: notifier.setMaintenanceIncluded,
            ),
            _MoneyField(
              label: 'Brokerage (optional)',
              hint: '48,000',
              onChanged: notifier.setBrokerageAmount,
            ),
            _MoneyField(
              label: 'Other charges',
              hint: '2,000',
              onChanged: notifier.setOtherCharges,
            ),
          ],
        ),
        _Section(
          title: 'Rental terms',
          children: [
            _LockInChips(state: state, notifier: notifier),
            _TextInput(
              label: 'Rent escalation (% yearly)',
              hint: '5',
              keyboardType: TextInputType.number,
              onChanged: notifier.setRentEscalation,
            ),
          ],
        ),
        _Section(
          title: 'Availability',
          children: [
            _ChoiceField(
              label: 'Available from',
              options: _availabilityOptions,
              selected: state.availability,
              onSelected: notifier.setAvailability,
            ),
          ],
        ),
      ],
    );
  }
}

class _CommercialLease extends StatelessWidget {
  final ListPropertyState state;
  final ListPropertyNotifier notifier;

  const _CommercialLease({required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return _Flow(
      children: [
        _Section(
          title: 'Pricing',
          children: [
            _MoneyField(
              label: 'Lease deposit amount *',
              hint: '12,00,000',
              onChanged: notifier.setExpectedPrice,
            ),
            _MoneyField(
              label: 'Monthly rent (optional)',
              hint: '0',
              onChanged: notifier.setMonthlyRent,
            ),
            _MoneyField(
              label: 'Maintenance charges',
              hint: '5,000',
              onChanged: notifier.setMaintenance,
            ),
            _SwitchField(
              label: 'Maintenance included in monthly rent?',
              value: state.maintenanceIncluded,
              onChanged: notifier.setMaintenanceIncluded,
            ),
            _MoneyField(
              label: 'Other charges',
              hint: '2,000',
              onChanged: notifier.setOtherCharges,
            ),
          ],
        ),
        _Section(
          title: 'Lease details',
          children: [
            _ChoiceField(
              label: 'Lease duration *',
              options: const ['1 Year', '3 Years', '5 Years', '9 Years'],
              selected: state.leaseDuration,
              onSelected: notifier.setLeaseDuration,
            ),
            _LockInChips(state: state, notifier: notifier, requiredLabel: true),
            _TextInput(
              label: 'Rent escalation (optional)',
              hint: '5',
              keyboardType: TextInputType.number,
              onChanged: notifier.setRentEscalation,
            ),
          ],
        ),
        _Section(
          title: 'Commercial usage',
          children: [
            _ChoiceField(
              label: 'Usage',
              options: const [
                'Office',
                'Retail',
                'Warehouse',
                'Factory',
                'Hotel',
                'Restaurant',
              ],
              selected: state.commercialUsage,
              onSelected: notifier.setCommercialUsage,
            ),
          ],
        ),
        _Section(
          title: 'Availability',
          children: [
            _ChoiceField(
              label: 'Availability',
              options: const [
                'Immediate',
                'Within 1 Month',
                'Within 3 Months',
                'Custom Date',
              ],
              selected: state.availability,
              onSelected: notifier.setAvailability,
            ),
          ],
        ),
      ],
    );
  }
}

const _availabilityOptions = [
  'Immediate',
  'Within 1 Month',
  'Within 3 Months',
  'Custom Date',
];

class _Flow extends StatelessWidget {
  final List<Widget> children;

  const _Flow({required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final child in children) ...[child, const SizedBox(height: 20)],
      ],
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: text15(fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        _FieldGrid(children: children),
      ],
    );
  }
}

class _FieldGrid extends StatelessWidget {
  final List<Widget> children;

  const _FieldGrid({required this.children});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final useTwoColumns = constraints.maxWidth >= 560;
        return Wrap(
          spacing: 12,
          runSpacing: 14,
          children: children
              .map(
                (child) => SizedBox(
                  width: useTwoColumns
                      ? (constraints.maxWidth - 12) / 2
                      : constraints.maxWidth,
                  child: child,
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _MoneyField extends StatelessWidget {
  final String label;
  final String hint;
  final ValueChanged<String> onChanged;

  const _MoneyField({
    required this.label,
    required this.hint,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(label),
        TextField(
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: onChanged,
          style: text14(fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: text14(color: AppColors.hintText),
            prefixText: 'Rs. ',
            prefixStyle: text14(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 13,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.grey300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.grey300),
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
      ],
    );
  }
}

class _TextInput extends StatelessWidget {
  final String label;
  final String hint;
  final TextInputType? keyboardType;
  final ValueChanged<String> onChanged;

  const _TextInput({
    required this.label,
    required this.hint,
    this.keyboardType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(label),
        ListingTextField(
          hint: hint,
          keyboardType: keyboardType,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _ChoiceField extends StatelessWidget {
  final String label;
  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelected;

  const _ChoiceField({
    required this.label,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(label),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options
              .map(
                (option) => SelectorChip(
                  label: option,
                  isSelected: selected == option,
                  onTap: () => onSelected(option),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _NegotiableChips extends StatelessWidget {
  final ListPropertyState state;
  final ListPropertyNotifier notifier;
  final String label;

  const _NegotiableChips({
    required this.state,
    required this.notifier,
    this.label = 'Price negotiable',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(label),
        Wrap(
          spacing: 8,
          children: [
            SelectorChip(
              label: 'Yes',
              isSelected: state.priceNegotiable == PriceNegotiable.yes,
              onTap: () => notifier.setPriceNegotiable(PriceNegotiable.yes),
            ),
            SelectorChip(
              label: 'No',
              isSelected: state.priceNegotiable == PriceNegotiable.no,
              onTap: () => notifier.setPriceNegotiable(PriceNegotiable.no),
            ),
          ],
        ),
      ],
    );
  }
}

class _SwitchField extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.grey300),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: text13(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          CustomSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _BuyerPreferencesSection extends StatelessWidget {
  final ListPropertyState state;
  final ListPropertyNotifier notifier;

  const _BuyerPreferencesSection({required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Buyer preferences', style: text16(fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        _PreferenceSwitchRow(
          title: 'Vastu compliant',
          subtitle: 'Mark if property is Vastu certified',
          value: state.vastuCompliant,
          onChanged: notifier.setVastu,
        ),
        _PreferenceSwitchRow(
          title: 'Key Handover',
          subtitle: 'Indicate if keys are ready for immediate handover',
          value: state.keyHandover,
          onChanged: notifier.setKeyHandover,
        ),
        _PreferenceSwitchRow(
          title: 'Open to all buyers',
          subtitle: 'No religion / community restriction',
          value: state.openToAllBuyers,
          onChanged: notifier.setOpenToAll,
        ),
        _PreferenceSwitchRow(
          title: 'Loan assistance needed',
          subtitle: 'Admin can help coordinate home loan',
          value: state.loanAssistanceNeeded,
          onChanged: notifier.setLoanAssistance,
        ),
      ],
    );
  }
}

class _PreferenceSwitchRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _PreferenceSwitchRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: text13(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(subtitle, style: text10(color: AppColors.textSecondary)),
              ],
            ),
          ),
          CustomSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _ListingPlanSection extends StatelessWidget {
  final ListPropertyState state;
  final ListPropertyNotifier notifier;

  const _ListingPlanSection({required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(color: AppColors.grey300),
        const SizedBox(height: 12),
        Text('Buyer preferences', style: text16(fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        _ListingPlanTile(
          title: 'Standard listing',
          subtitle: 'Goes live after verification - free',
          selected: state.listingType == ListingType.standard,
          onTap: () => notifier.setListingType(ListingType.standard),
        ),
        const SizedBox(height: 10),
        _ListingPlanTile(
          title: 'Featured listing',
          subtitle: 'Top of search - highlighted badge',
          price: 'Rs. 999',
          selected: state.listingType == ListingType.featured,
          onTap: () => notifier.setListingType(ListingType.featured),
        ),
        const SizedBox(height: 10),
        _ListingPlanTile(
          title: 'Premium listing',
          subtitle: 'Priority admin processing - map pin boost',
          price: 'Rs. 1,999',
          selected: state.listingType == ListingType.premium,
          onTap: () => notifier.setListingType(ListingType.premium),
        ),
      ],
    );
  }
}

class _ListingPlanTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? price;
  final bool selected;
  final VoidCallback onTap;

  const _ListingPlanTile({
    required this.title,
    required this.subtitle,
    this.price,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.grey300,
            width: selected ? 1.4 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: text13(fontWeight: FontWeight.w700),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (price != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            price!,
                            style: text10(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(subtitle, style: text10(color: AppColors.textSecondary)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            if (selected)
              Container(
                width: 20,
                height: 20,
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

class _FurnishingChips extends StatelessWidget {
  final ListPropertyState state;
  final ListPropertyNotifier notifier;

  const _FurnishingChips({required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel('Furnishing status'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: Furnishing.values
              .map(
                (value) => SelectorChip(
                  label: value.label,
                  isSelected: state.furnishing == value,
                  onTap: () => notifier.setFurnishing(value),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _LockInChips extends StatelessWidget {
  final ListPropertyState state;
  final ListPropertyNotifier notifier;
  final bool requiredLabel;

  const _LockInChips({
    required this.state,
    required this.notifier,
    this.requiredLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    final values = [
      LockInPeriod.none,
      LockInPeriod.sixMonths,
      LockInPeriod.oneYear,
      LockInPeriod.twoYears,
      LockInPeriod.threeYears,
      LockInPeriod.fiveYears,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(requiredLabel ? 'Lock-in period *' : 'Lock-in period'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: values
              .map(
                (value) => SelectorChip(
                  label: value.label,
                  isSelected: state.lockInPeriod == value,
                  onTap: () => notifier.setLockInPeriod(value),
                ),
              )
              .toList(),
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
        child: AppButton(title: 'Review & submit listing', onTap: onTap),
      ),
    );
  }
}

// ─── Installment / EMI Section Widget ─────────────────────────────────────────

class _InstallmentSection extends StatefulWidget {
  final ListPropertyState state;
  final ListPropertyNotifier notifier;

  const _InstallmentSection({
    required this.state,
    required this.notifier,
  });

  @override
  State<_InstallmentSection> createState() => _InstallmentSectionState();
}

class _InstallmentSectionState extends State<_InstallmentSection> {
  late TextEditingController _downPaymentPctController;
  late TextEditingController _downPaymentAmtController;
  late TextEditingController _installmentsCountController;
  late TextEditingController _interestRateController;
  late TextEditingController _termsController;

  @override
  void initState() {
    super.initState();
    _downPaymentPctController =
        TextEditingController(text: widget.state.downPaymentPercentage);
    _downPaymentAmtController =
        TextEditingController(text: widget.state.downPaymentAmount);
    _installmentsCountController =
        TextEditingController(text: widget.state.numberOfInstallments);
    _interestRateController =
        TextEditingController(text: widget.state.interestRate);
    _termsController =
        TextEditingController(text: widget.state.installmentTerms);
  }

  @override
  void didUpdateWidget(covariant _InstallmentSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state.downPaymentPercentage != _downPaymentPctController.text) {
      _downPaymentPctController.text = widget.state.downPaymentPercentage;
    }
    if (widget.state.downPaymentAmount != _downPaymentAmtController.text) {
      _downPaymentAmtController.text = widget.state.downPaymentAmount;
    }
    if (widget.state.numberOfInstallments != _installmentsCountController.text) {
      _installmentsCountController.text = widget.state.numberOfInstallments;
    }
    if (widget.state.interestRate != _interestRateController.text) {
      _interestRateController.text = widget.state.interestRate;
    }
    if (widget.state.installmentTerms != _termsController.text) {
      _termsController.text = widget.state.installmentTerms;
    }
  }

  @override
  void dispose() {
    _downPaymentPctController.dispose();
    _downPaymentAmtController.dispose();
    _installmentsCountController.dispose();
    _interestRateController.dispose();
    _termsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final notifier = widget.notifier;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: state.allowInstallments
              ? AppColors.primary.withOpacity(0.5)
              : AppColors.grey300,
          width: state.allowInstallments ? 1.5 : 1,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Toggle Header ──────────────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: state.allowInstallments
                      ? AppColors.primary.withOpacity(0.12)
                      : AppColors.grey100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.payments_outlined,
                  size: 22,
                  color: state.allowInstallments
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Allow Installments / EMI Option',
                      style: text14(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Enable buyers to pay via flexible down payment & monthly installments',
                      style: text11(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              CustomSwitch(
                value: state.allowInstallments,
                onChanged: notifier.setAllowInstallments,
              ),
            ],
          ),

          // ── Installment Plan Fields (Rendered only when toggle is ON) ───
          if (state.allowInstallments) ...[
            const SizedBox(height: 16),
            const Divider(color: AppColors.grey200),
            const SizedBox(height: 14),

            // 1. Down Payment
            const FieldLabel('Minimum Down Payment *'),
            Row(
              children: [
                // Down Payment %
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _downPaymentPctController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (val) {
                      notifier.setDownPaymentPercentage(val);
                    },
                    style: text14(fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      hintText: '20',
                      suffixText: '%',
                      suffixStyle: text14(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppColors.grey300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppColors.grey300),
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
                ),
                const SizedBox(width: 10),
                // Down Payment Amount (Rs.)
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _downPaymentAmtController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (val) {
                      notifier.setDownPaymentAmount(val);
                    },
                    style: text14(fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      hintText: 'Down payment',
                      prefixText: 'Rs. ',
                      prefixStyle: text14(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppColors.grey300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppColors.grey300),
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
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Quick Down Payment % Chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['10%', '20%', '25%', '30%', '50%'].map((pctStr) {
                final pctVal = pctStr.replaceAll('%', '');
                final isSelected = state.downPaymentPercentage == pctVal;
                return SelectorChip(
                  label: pctStr,
                  isSelected: isSelected,
                  onTap: () {
                    _downPaymentPctController.text = pctVal;
                    notifier.setDownPaymentPercentage(pctVal);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // 2. Number of Installments
            const FieldLabel('Number of Installments (Months / Count) *'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['6', '12', '24', '36', '48', '60'].map((countStr) {
                final isSelected = state.numberOfInstallments == countStr;
                return SelectorChip(
                  label: '$countStr Months',
                  isSelected: isSelected,
                  onTap: () {
                    _installmentsCountController.text = countStr;
                    notifier.setNumberOfInstallments(countStr);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _installmentsCountController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: notifier.setNumberOfInstallments,
              style: text14(fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: 'Or enter custom number of installments (e.g. 18)',
                hintStyle: text13(color: AppColors.hintText),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.grey300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.grey300),
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
            const SizedBox(height: 16),

            // 3. Installment Frequency
            const FieldLabel('Payment Frequency'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                'Monthly',
                'Quarterly',
                'Bi-annual',
                'Yearly',
                'Milestone-based',
              ].map((freq) {
                final isSelected = state.installmentFrequency == freq;
                return SelectorChip(
                  label: freq,
                  isSelected: isSelected,
                  onTap: () => notifier.setInstallmentFrequency(freq),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // 4. Annual Interest Rate (% per annum)
            const FieldLabel('Annual Interest Rate (% per annum)'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                '0% (Interest-Free)',
                '6%',
                '8.5%',
                '10%',
                '12%',
              ].map((rateStr) {
                final rateVal =
                    rateStr.contains('0%') ? '0' : rateStr.replaceAll('%', '');
                final isSelected = state.interestRate == rateVal;
                return SelectorChip(
                  label: rateStr,
                  isSelected: isSelected,
                  onTap: () {
                    _interestRateController.text = rateVal;
                    notifier.setInterestRate(rateVal);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // 5. Grace Period (Days)
            const FieldLabel('Grace Period (Optional)'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['0 Days', '7 Days', '15 Days', '30 Days'].map((gStr) {
                final gVal = gStr.split(' ').first;
                final isSelected = state.gracePeriodDays == gVal;
                return SelectorChip(
                  label: gStr,
                  isSelected: isSelected,
                  onTap: () => notifier.setGracePeriodDays(gVal),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // 6. Estimated EMI Preview Card
            if (state.installmentAmount.isNotEmpty &&
                state.installmentAmount != '0') ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.25),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.calculate_outlined,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Estimated Installment / EMI',
                          style: text13(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '₹${state.installmentAmount} / ${state.installmentFrequency.toLowerCase()}',
                      style: text18(
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Down Payment: ₹${state.downPaymentAmount.isEmpty ? '0' : state.downPaymentAmount} • ${state.numberOfInstallments.isEmpty ? '0' : state.numberOfInstallments} installments • ${state.interestRate}% interest',
                      style: text11(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // 7. Installment Terms & Conditions
            const FieldLabel('Installment Terms & Conditions (Optional)'),
            TextField(
              controller: _termsController,
              maxLines: 3,
              onChanged: notifier.setInstallmentTerms,
              style: text14(),
              decoration: InputDecoration(
                hintText:
                    'e.g. Possession after 40% payment, registry upon final payment clearance.',
                hintStyle: text13(color: AppColors.hintText),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.grey300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.grey300),
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
          ],
        ],
      ),
    );
  }
}
