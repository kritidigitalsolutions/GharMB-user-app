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
            Text("Property specs", style: text16(fontWeight: FontWeight.bold)),
            SizedBox(height: 2),
            StepProgress(current: 2, total: 5),
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
                  // ── Bedrooms + Bathrooms ──────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const FieldLabel('Bedrooms (BHK)'),
                            NumberSelectorRow(
                              options: ['1', '2', '3', '4+'],
                              selected: state.bedrooms > 3
                                  ? '4+'
                                  : '${state.bedrooms}',
                              onSelect: (v) => notifier.setBedrooms(
                                v == '4+' ? 4 : int.parse(v),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const FieldLabel('Bedrooms (BHK)'),
                            NumberSelectorRow(
                              options: ['1', '2', '3', '4+'],
                              selected: state.bathrooms > 3
                                  ? '4+'
                                  : '${state.bathrooms}',
                              onSelect: (v) => notifier.setBathrooms(
                                v == '4+' ? 4 : int.parse(v),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // ── Carpet Area + Built-up Area ───────────────────────
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

                  // ── Floor No + Total Floors ───────────────────────────
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

                  // ── Age of Property ───────────────────────────────────
                  const FieldLabel('Bedrooms (BHK)'),
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

                  // ── Furnishing ────────────────────────────────────────
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

                  // ── Facing Direction ──────────────────────────────────
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

                  // ── Parking ───────────────────────────────────────────
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

                  // ── Amenities ─────────────────────────────────────────
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
                  const SizedBox(height: 28),

                  // ── Next ──────────────────────────────────────────────
                  SafeArea(
                    child: AppButton(
                      title: "Next",
                      onTap: () {
                        context.pushNamed(AppPage.photosVideoName);
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
