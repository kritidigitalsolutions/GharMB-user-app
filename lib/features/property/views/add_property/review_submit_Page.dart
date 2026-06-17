import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/property/providers/property_add_provider.dart';
import 'package:gharmb_app/routes/app_page.dart';
import 'package:gharmb_app/shared/button/custom_button.dart';
import 'package:gharmb_app/shared/widget/custom_stepprogress.dart';
import 'package:go_router/go_router.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';

class ReviewSubmitPage extends ConsumerStatefulWidget {
  const ReviewSubmitPage({super.key});

  @override
  ConsumerState<ReviewSubmitPage> createState() => _ReviewSubmitPageState();
}

class _ReviewSubmitPageState extends ConsumerState<ReviewSubmitPage> {
  bool _isSubmitting = false;

  Future<void> _handleSubmit() async {
    setState(() => _isSubmitting = true);
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isSubmitting = false);
    context.pushNamed(AppPage.propertySubmittedName);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(listPropertyProvider);

    // Summary rows
    final summaryRows = <_SummaryRow>[
      _SummaryRow(
        label: 'Expected price',
        value: state.expectedPrice.isEmpty
            ? '₹85 Lakhs'
            : '₹${state.expectedPrice}',
      ),
      _SummaryRow(
        label: 'Furnishing',
        value: state.furnishingLabel.isEmpty
            ? 'Semi-furnished'
            : state.furnishingLabel,
      ),
      _SummaryRow(label: 'Possession', value: state.possessionLabel),
      _SummaryRow(
        label: 'Photos added',
        value: '${state.photos.length} photos',
      ),
      _SummaryRow(label: 'Documents', value: '2 of 4 uploaded'),
      _SummaryRow(label: 'Listing type', value: state.listingTypeLabel),
    ];

    // Tags
    final tags = <String>[
      '${state.bedrooms} BHK',
      state.carpetArea.isEmpty ? '1450 sqft' : '${state.carpetArea} sqft',
      state.floorNo.isEmpty ? '2th floor' : '${state.floorNo}th floor',
      'For sale',
    ];

    // Hero image — first picked photo or gradient placeholder
    final firstPhoto = state.photos.isNotEmpty ? state.photos.first : null;

    return PopScope(
      canPop: true,
      child: Scaffold(
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
                "Review & submit",
                style: text16(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 2),
              StepProgress(current: 5, total: 5),
            ],
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Hero Image ─────────────────────────────────────────
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: firstPhoto != null
                    ? Image.file(
                        firstPhoto,
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: double.infinity,
                        height: 180,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF1A3A5C), Color(0xFF2D6A9F)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.apartment_rounded,
                            size: 64,
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 16),

              // ── Property Name + Tags ───────────────────────────────
              Text(
                state.propertyTitle.isEmpty
                    ? 'Skyline Heights — 3 BHK Apartment'
                    : state.propertyTitle,
                style: text18(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                state.fullAddress.isEmpty
                    ? 'Sector 62, Uttar Pradesh — 283501'
                    : state.fullAddress,
                style: text12(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: tags.map((t) => _TagChip(label: t)).toList(),
              ),
              const SizedBox(height: 20),

              // ── Summary Card ───────────────────────────────────────
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.grey200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: List.generate(summaryRows.length, (i) {
                    final row = summaryRows[i];
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 13,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  row.label,
                                  style: text13(color: AppColors.textSecondary),
                                ),
                              ),
                              Text(
                                row.value,
                                style: text13(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        if (i < summaryRows.length - 1)
                          const Divider(height: 1, color: AppColors.grey100),
                      ],
                    );
                  }),
                ),
              ),
              const SizedBox(height: 16),

              // ── Pending Docs Warning ───────────────────────────────
              // Container(
              //   padding: const EdgeInsets.all(14),
              //   decoration: BoxDecoration(
              //     color: AppColors.warning.withOpacity(0.07),
              //     borderRadius: BorderRadius.circular(12),
              //     border: Border.all(
              //       color: AppColors.warning.withOpacity(0.35),
              //     ),
              //   ),
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       const Icon(
              //         Icons.info_outline,
              //         color: AppColors.warning,
              //         size: 18,
              //       ),
              //       const SizedBox(width: 10),
              //       Expanded(
              //         child: Text(
              //           '2 required documents are still pending. You can submit now. Admin will request missing docs during verification',
              //           style: text12(
              //             color: AppColors.textSecondary,
              //           ).copyWith(height: 1.5),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // const SizedBox(height: 14),

              // ── Agreement Note ─────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  textAlign: TextAlign.center,
                  'By submitting you agree to our listing terms. Your property will be reviewed by admin within 24-48 hours. You will be notified via SMS and app notification.',
                  style: text12(
                    color: AppColors.textSecondary,
                  ).copyWith(height: 1.6),
                ),
              ),
              const SizedBox(height: 20),

              // ── Need Help ──────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.grey50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.grey200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Need Help?',
                      style: text13(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _HelpBtn(
                          icon: FontAwesomeIcons.phone,
                          label: 'Call Admin',
                        ),
                        _HelpBtn(
                          icon: FontAwesomeIcons.whatsapp,
                          label: 'Whatsapp',
                        ),
                        _HelpBtn(
                          icon: FontAwesomeIcons.envelope,
                          label: 'Email Support',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // ── Bottom Buttons ─────────────────────────────────────────────
        bottomNavigationBar: Container(
          padding: EdgeInsets.fromLTRB(
            16,
            10,
            16,
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Submit for verification
              AppButton(
                title: "Submit for verification",
                onTap: _isSubmitting ? null : _handleSubmit,
                isLoading: _isSubmitting,
              ),

              const SizedBox(height: 10),

              AppOutlineButton(
                title: "Edit listing",
                onTap: () {
                  context.pushNamed(AppPage.basicDetailsName);
                },
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Helper classes ───────────────────────────────────────────────────────────

class _SummaryRow {
  final String label;
  final String value;
  const _SummaryRow({required this.label, required this.value});
}

class _TagChip extends StatelessWidget {
  final String label;
  const _TagChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: text11(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _HelpBtn extends StatelessWidget {
  final FaIconData icon;
  final String label;
  const _HelpBtn({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Row(
        children: [
          FaIcon(
            icon,
            size: 18,
            color: label == "Whatsapp"
                ? AppColors.success
                : AppColors.textPrimary,
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: text10(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
