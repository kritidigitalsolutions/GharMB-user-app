import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/developer/providers/project_add_provider.dart';
import 'package:gharmb_app/features/property/widget/listing_widget.dart';
import 'package:gharmb_app/routes/app_page.dart';
import 'package:gharmb_app/shared/button/custom_button.dart';
import 'package:gharmb_app/shared/widget/custom_stepprogress.dart';
import 'package:go_router/go_router.dart';

class ProjectBasicInfoPage extends ConsumerWidget {
  const ProjectBasicInfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(projectAddProvider);
    final notifier = ref.read(projectAddProvider.notifier);

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
            Text('Basic info', style: text16(fontWeight: FontWeight.bold)),

            const SizedBox(height: 4),
            StepProgress(current: 1, total: 5),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Project name ────────────────────────────────────────────────
            FieldLabel('Project name *'),
            const SizedBox(height: 6),
            _InputField(
              hint: 'Emerald Heights Phase 2',
              onChanged: notifier.setProjectName,
            ),
            const SizedBox(height: 16),

            // ── Developer / builder name ────────────────────────────────────
            FieldLabel('Developer / builder name *'),
            const SizedBox(height: 6),
            _InputField(
              hint: 'e.g. Lodha Group, Godrej Properties',
              onChanged: notifier.setDeveloperName,
            ),
            const SizedBox(height: 16),

            // ── RERA number + expiry ────────────────────────────────────────
            FieldLabel('RERA project number *'),
            const SizedBox(height: 6),
            _InputField(
              hint: 'UPREAREG24XXXXXX',
              onChanged: notifier.setReraNumber,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FieldLabel('RERA expiry date *'),
                      const SizedBox(height: 6),
                      _DateField(
                        hint: 'DD / MM / YYYY',
                        onChanged: notifier.setReraExpiryDate,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FieldLabel('Launch date'),
                      const SizedBox(height: 6),
                      _DateField(
                        hint: 'DD / MM / YYYY',
                        onChanged: notifier.setLaunchDate,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ── Project type ────────────────────────────────────────────────
            FieldLabel('Project type *'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ProjectType.values
                  .map(
                    (v) => SelectorChip(
                      label: v.label,
                      isSelected: state.projectType == v,
                      onTap: () => notifier.setProjectType(v),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),

            // ── Project status ──────────────────────────────────────────────
            FieldLabel('Project status *'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ProjectStatus.values.map((v) {
                final sel = state.projectStatus == v;
                return GestureDetector(
                  onTap: () => notifier.setProjectStatus(v),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: sel
                          ? AppColors.primary.withOpacity(0.08)
                          : AppColors.grey50,
                      border: Border.all(
                        color: sel ? AppColors.primary : AppColors.grey200,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          v.icon,
                          size: 20,
                          color: sel ? AppColors.primary : AppColors.grey,
                        ),

                        const SizedBox(width: 6),
                        Text(
                          v.label,
                          style: text13(
                            fontWeight: FontWeight.w500,
                            color: sel
                                ? AppColors.primary
                                : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // ── City + Locality ─────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FieldLabel('City *'),
                      const SizedBox(height: 6),
                      _InputField(hint: 'Meerut', onChanged: notifier.setCity),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FieldLabel('Locality *'),
                      const SizedBox(height: 6),
                      _InputField(
                        hint: 'Shastri Nagar',
                        onChanged: notifier.setLocality,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ── Full address ────────────────────────────────────────────────
            FieldLabel('Full address / pin location *'),
            const SizedBox(height: 6),
            _InputField(
              hint: 'Plot no, sector, landmark...',
              onChanged: notifier.setFullAddress,
            ),
            const SizedBox(height: 10),

            // ── Pincode ─────────────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FieldLabel('Pincode *'),
                      const SizedBox(height: 6),
                      _InputField(
                        hint: '250002',
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        onChanged: notifier.setPincode,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FieldLabel('Possession date *'),
                      const SizedBox(height: 6),
                      _DateField(
                        hint: 'Dec 2026',
                        onChanged: notifier.setPossessionDate,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ── Project website ─────────────────────────────────────────────
            FieldLabel('Project website'),
            const SizedBox(height: 6),
            _InputField(
              hint: 'https://emeraldheights.in',
              keyboardType: TextInputType.url,
              onChanged: notifier.setProjectWebsite,
            ),
            const SizedBox(height: 16),

            // ── Tagline ─────────────────────────────────────────────────────
            FieldLabel('Project tagline'),
            const SizedBox(height: 6),
            _InputField(
              hint: 'e.g. Where luxury meets nature',
              onChanged: notifier.setProjectTagline,
            ),
            const SizedBox(height: 16),

            // ── Short description ───────────────────────────────────────────
            FieldLabel('Short description'),
            const SizedBox(height: 6),
            TextField(
              maxLines: 3,
              onChanged: notifier.setShortDescription,
              style: text13(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText:
                    'Premium gated project near NH-58 with 70% open space...',
                hintStyle: text13(color: AppColors.grey400),
                filled: true,
                fillColor: AppColors.grey50,
                contentPadding: const EdgeInsets.all(14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.grey200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.grey200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomBar(
        onTap: () => context.pushNamed(AppPage.devProjectUnitConfigName),
      ),
    );
  }
}

// ─── Small reusable widgets ───────────────────────────────────────────────────

class _InputField extends StatelessWidget {
  final String hint;
  final TextInputType keyboardType;
  final int? maxLength;
  final ValueChanged<String> onChanged;

  const _InputField({
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      keyboardType: keyboardType,
      maxLength: maxLength,
      style: text13(color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: text13(color: AppColors.grey400),
        counterText: '',
        filled: true,
        fillColor: AppColors.grey50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.grey200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.grey200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;
  const _DateField({required this.hint, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      style: text13(color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: text13(color: AppColors.grey400),
        suffixIcon: const Icon(
          Icons.calendar_today_outlined,
          size: 16,
          color: AppColors.grey400,
        ),
        filled: true,
        fillColor: AppColors.grey50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.grey200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.grey200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
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
        child: AppButton(title: 'Next →', onTap: onTap),
      ),
    );
  }
}
