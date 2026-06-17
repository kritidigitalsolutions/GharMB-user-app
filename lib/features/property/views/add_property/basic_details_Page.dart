import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/property/providers/property_add_provider.dart';
import 'package:gharmb_app/features/property/widget/listing_widget.dart';
import 'package:gharmb_app/routes/app_page.dart';
import 'package:gharmb_app/shared/button/custom_button.dart';
import 'package:gharmb_app/shared/widget/custom_stepprogress.dart';
import 'package:go_router/go_router.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';

class BasicDetailsPage extends ConsumerWidget {
  const BasicDetailsPage({super.key});

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
            Text("Basic details", style: text16(fontWeight: FontWeight.bold)),
            SizedBox(height: 2),
            StepProgress(current: 1, total: 5),
          ],
        ),
      ),
      body: Column(
        children: [
          // Scrollable form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Property Title ───────────────────────────────────
                  const FieldLabel('Property title'),
                  ListingTextField(
                    hint: '3 BHK Apartment, Sector 62 Noida',
                    onChanged: notifier.setPropertyTitle,
                  ),
                  const SizedBox(height: 18),

                  // ── Listing For ──────────────────────────────────────
                  const FieldLabel('Listing for'),
                  Wrap(
                    spacing: 8,
                    children: ListingFor.values.map((v) {
                      final sel = state.listingFor.contains(v);
                      return SelectorChip(
                        label: v.label,
                        isSelected: sel,
                        onTap: () => notifier.toggleListingFor(v),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 18),

                  // ── Property Type ────────────────────────────────────
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

                  // ── City + Locality ──────────────────────────────────
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
                              hint: 'Sector 62',
                              onChanged: notifier.setLocality,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // ── Full Address ─────────────────────────────────────
                  const FieldLabel('Full address'),
                  ListingTextField(
                    hint: 'A-304, Skyline Heights, Sector 62...',
                    onChanged: notifier.setFullAddress,
                  ),
                  const SizedBox(height: 18),

                  // ── Pincode ──────────────────────────────────────────
                  const FieldLabel('Pincode'),
                  ListingTextField(
                    hint: '282203',
                    keyboardType: TextInputType.number,
                    onChanged: notifier.setPincode,
                  ),
                  const SizedBox(height: 18),

                  // ── Description ──────────────────────────────────────
                  const FieldLabel('Description'),
                  ListingTextField(
                    hint:
                        'Describe the property – views,\ncondition, unique features...',
                    maxLines: 4,
                    onChanged: notifier.setDescription,
                  ),
                  const SizedBox(height: 28),

                  // ── Next ─────────────────────────────────────────────
                  SafeArea(
                    child: AppButton(
                      title: "Next",
                      onTap: () {
                        context.pushNamed(AppPage.propertySpecsName);
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
