import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/developer/providers/project_add_provider.dart';
import 'package:gharmb_app/features/property/widget/listing_widget.dart';
import 'package:gharmb_app/routes/app_page.dart';
import 'package:gharmb_app/shared/button/custom_button.dart';
import 'package:gharmb_app/shared/widget/custom_stepprogress.dart';
import 'package:gharmb_app/shared/widget/custom_switch_widget.dart';
import 'package:go_router/go_router.dart';

class DevProjectAmenitiesHighlightsPage extends ConsumerStatefulWidget {
  const DevProjectAmenitiesHighlightsPage({super.key});

  @override
  ConsumerState<DevProjectAmenitiesHighlightsPage> createState() =>
      _DevProjectAmenitiesHighlightsPageState();
}

class _DevProjectAmenitiesHighlightsPageState
    extends ConsumerState<DevProjectAmenitiesHighlightsPage> {
  final _landmarkNameController = TextEditingController();
  final _landmarkDistanceController = TextEditingController();

  @override
  void dispose() {
    _landmarkNameController.dispose();
    _landmarkDistanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(projectAddProvider);
    final notifier = ref.read(projectAddProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _ProjectAppBar(title: 'Amenities', step: 3),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionTitle('Select amenities'),
            _AmenityGroup(
              title: 'Approvals & society',
              items: const [
                AmenityItem.reraApproved,
                AmenityItem.gatedSociety,
                AmenityItem.security24x7,
                AmenityItem.lift,
              ],
              selected: state.amenities,
              onTap: notifier.toggleAmenity,
            ),
            const SizedBox(height: 16),
            _AmenityGroup(
              title: 'Lifestyle amenities',
              items: const [
                AmenityItem.clubhouse,
                AmenityItem.swimmingPool,
                AmenityItem.gym,
                AmenityItem.garden,
                AmenityItem.kidsPlayArea,
                AmenityItem.joggingTrack,
                AmenityItem.amphitheatre,
              ],
              selected: state.amenities,
              onTap: notifier.toggleAmenity,
            ),
            const SizedBox(height: 16),
            _AmenityGroup(
              title: 'Sports & recreation',
              items: const [
                AmenityItem.cricketPitch,
                AmenityItem.tennisCourt,
                AmenityItem.badmintonCourt,
              ],
              selected: state.amenities,
              onTap: notifier.toggleAmenity,
            ),
            const SizedBox(height: 16),
            _AmenityGroup(
              title: 'Connectivity & utilities',
              items: const [
                AmenityItem.metroNearby,
                AmenityItem.powerBackup,
                AmenityItem.wifiReady,
                AmenityItem.evCharging,
              ],
              selected: state.amenities,
              onTap: notifier.toggleAmenity,
            ),
            const SizedBox(height: 24),
            _SectionTitle('Nearby landmarks'),
            for (var i = 0; i < state.nearbyLandmarks.length; i++) ...[
              _LandmarkTile(
                text: state.nearbyLandmarks[i],
                onRemove: () => notifier.removeLandmark(i),
              ),
              const SizedBox(height: 8),
            ],
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const FieldLabel('Location name'),
                      ListingTextField(
                        hint: 'NH-58',
                        controller: _landmarkNameController,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const FieldLabel('Distance'),
                      ListingTextField(
                        hint: '1.2 km',
                        controller: _landmarkDistanceController,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.only(top: 29),
                  child: OutlinedButton(
                    onPressed: () {
                      final name = _landmarkNameController.text.trim();
                      final distance = _landmarkDistanceController.text.trim();
                      if (name.isEmpty) return;
                      notifier.addLandmark(
                        distance.isEmpty ? name : '$name - $distance',
                      );
                      _landmarkNameController.clear();
                      _landmarkDistanceController.clear();
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Add',
                      style: text13(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _SectionTitle('Vastu compliant?'),
            _SwitchTile(
              title: 'Yes, all units are vastu compliant',
              value: state.vastuCompliant,
              onChanged: (value) => notifier.setVastuCompliant(value),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomBar(
        title: 'Next',
        onTap: () => context.pushNamed(AppPage.devProjectPhotosName),
      ),
    );
  }
}

class _LandmarkTile extends StatelessWidget {
  final String text;
  final VoidCallback onRemove;

  const _LandmarkTile({required this.text, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.grey300),
      ),
      child: Row(
        children: [
          Expanded(child: Text(text, style: text13())),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close, size: 18, color: AppColors.grey400),
          ),
        ],
      ),
    );
  }
}

class _AmenityGroup extends StatelessWidget {
  final String title;
  final List<AmenityItem> items;
  final Set<AmenityItem> selected;
  final ValueChanged<AmenityItem> onTap;

  const _AmenityGroup({
    required this.title,
    required this.items,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: text13(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items
              .map(
                (item) => SelectorChip(
                  label: item.label,
                  isSelected: selected.contains(item),
                  onTap: () => onTap(item),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: text13(fontWeight: FontWeight.w600)),
        ),
        CustomSwitch(value: value, onChanged: onChanged),
      ],
    );
  }
}

class _ProjectAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final int step;

  const _ProjectAppBar({required this.title, required this.step});

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      toolbarHeight: 80,
      leading: GestureDetector(
        onTap: context.pop,
        child: const Icon(Icons.arrow_back, color: AppColors.primary, size: 18),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: text16(fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          StepProgress(current: step, total: 5),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: text12(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w800,
        ).copyWith(letterSpacing: 1.1),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _BottomBar({required this.title, required this.onTap});

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
        child: AppButton(title: title, onTap: onTap),
      ),
    );
  }
}
