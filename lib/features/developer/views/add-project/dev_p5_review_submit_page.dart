import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/developer/providers/project_add_provider.dart';
import 'package:gharmb_app/shared/button/custom_button.dart';
import 'package:gharmb_app/shared/widget/custom_stepprogress.dart';
import 'package:go_router/go_router.dart';

class DevProjectReviewSubmitPage extends ConsumerWidget {
  const DevProjectReviewSubmitPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(projectAddProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _ProjectAppBar(title: 'Review & submit', step: 5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeroPreview(state: state),
            const SizedBox(height: 16),
            Text(
              state.projectName.isEmpty ? 'Project name' : state.projectName,
              style: text16(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              _locationLine(state),
              style: text12(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                if (state.reraApproved) const _Badge('RERA approved'),
                if (state.possessionDate.isNotEmpty) const _Badge('Ready to move'),
                const _Badge('Verified'),
              ],
            ),
            const SizedBox(height: 18),
            _SummaryCard(
              rows: [
                _SummaryRow('BHK types', state.bhkSummary),
                _SummaryRow('Total units', state.totalUnitsSummary),
                _SummaryRow('Price range', state.priceRange),
                _SummaryRow(
                  'Possession',
                  state.possessionDate.isEmpty ? '-' : state.possessionDate,
                ),
                _SummaryRow(
                  'Open space',
                  state.openSpacePercent.isEmpty
                      ? '-'
                      : '${state.openSpacePercent}%',
                ),
                _SummaryRow('Photos added', '${state.projectPhotos.length} of 12'),
                _SummaryRow(
                  'Brochure',
                  state.brochure == null ? 'Not added' : 'Added',
                ),
              ],
            ),
            if (state.projectPhotos.length < 8) ...[
              const SizedBox(height: 16),
              _WarningBanner(
                '${8 - state.projectPhotos.length} more photos recommended. You can add them after submitting from your dashboard.',
              ),
            ],
            const SizedBox(height: 18),
            AppButton(
              title: 'Submit project',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Project submitted for admin review.'),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: context.pop,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Edit details',
                style: text14(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'By submitting you agree to our listing terms. Project will be reviewed by admin within 24 hrs.',
              textAlign: TextAlign.center,
              style: text10(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  String _locationLine(ProjectAddState state) {
    final parts = [
      if (state.address.isNotEmpty) state.address,
      if (state.locality.isNotEmpty) state.locality,
      if (state.city.isNotEmpty) state.city,
    ];
    return parts.isEmpty ? 'Location not added' : parts.join(', ');
  }
}

class _HeroPreview extends StatelessWidget {
  final ProjectAddState state;

  const _HeroPreview({required this.state});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: double.infinity,
        height: 120,
        color: const Color(0xFF303030),
        child: state.projectPhotos.isEmpty
            ? const Icon(Icons.apartment, color: AppColors.primary, size: 34)
            : Image.file(state.projectPhotos.first.file, fit: BoxFit.cover),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final List<_SummaryRow> rows;

  const _SummaryCard({required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        children: rows
            .map(
              (row) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        row.label,
                        style: text12(color: AppColors.textSecondary),
                      ),
                    ),
                    Text(row.value, style: text12(fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _SummaryRow {
  final String label;
  final String value;

  const _SummaryRow(this.label, this.value);
}

class _Badge extends StatelessWidget {
  final String label;

  const _Badge(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEEE5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: text10(color: AppColors.primary, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _WarningBanner extends StatelessWidget {
  final String text;

  const _WarningBanner(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEEE5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: text12(color: AppColors.textSecondary).copyWith(height: 1.4),
      ),
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
