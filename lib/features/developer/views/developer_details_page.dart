import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/developer/providers/developer_provider.dart';
import 'package:gharmb_app/features/developer/providers/enquiry_provider.dart';
import 'package:gharmb_app/routes/app_page.dart';
import 'package:gharmb_app/shared/button/custom_button.dart';
import 'package:go_router/go_router.dart';

class DeveloperDetailPage extends ConsumerWidget {
  const DeveloperDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dev = ref.watch(selectedDeveloperProvider) ?? _defaultDeveloper;

    // Rating breakdown (5,4,3 stars)
    final ratingBreakdown = [
      _RatingBar(stars: 5, fraction: 0.85),
      _RatingBar(stars: 4, fraction: 0.60),
      _RatingBar(stars: 3, fraction: 0.30),
    ];

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── App Bar ────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
              child: Row(
                children: [
                  const CustomBackButton(),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dev.name,
                          style: text18(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Developer profile',
                          style: text12(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Scrollable Content ─────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Info Card ────────────────────────────────────
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.grey200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Logo + name row
                          Row(
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F0E8),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: AppColors.grey200),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.construction,
                                    color: Color(0xFF8B6914),
                                    size: 30,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      dev.name,
                                      style: text16(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      'Pan India · ${dev.established}',
                                      style: text12(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star_rounded,
                                          color: AppColors.yellow,
                                          size: 14,
                                        ),
                                        const SizedBox(width: 3),
                                        Text(
                                          dev.rating.toStringAsFixed(1),
                                          style: text12(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          dev.reviewCount,
                                          style: text12(
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // 3-stat chips
                          Row(
                            children: [
                              Expanded(
                                child: _StatChip(
                                  value: '${dev.projects}+',
                                  label: 'Projects',
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _StatChip(
                                  value:
                                  '${(dev.unitsDelivered / 1000).toStringAsFixed(0)}K+',
                                  label: 'Units delivered',
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _StatChip(
                                  value: '${dev.cities}',
                                  label: 'Cities',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Badges row
                          Wrap(
                            spacing: 8,
                            children: [
                              if (dev.reraApproved) _SmallBadge(label: 'RERA'),
                              if (dev.isoCertified)
                                _SmallBadge(label: 'ISO certified'),
                              if (dev.bseListed)
                                _SmallBadge(label: 'BSE Listed'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── About ────────────────────────────────────────
                    Text(
                      dev.about,
                      style: text13(
                        color: AppColors.textSecondary,
                      ).copyWith(height: 1.6),
                    ),
                    const SizedBox(height: 20),

                    // ── Enquire Now ──────────────────────────────────
                    AppButton(
                      title: "Enquire now",
                      onTap: () {
                        _showEnquiryBottomSheet(
                          context,
                          ref,
                          developerId: dev.id,
                        );
                      },
                    ),
                    const SizedBox(height: 22),

                    // ── Buyer Reviews ────────────────────────────────
                    Text(
                      'Buyer reviews',
                      style: text16(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),

                    // Rating summary card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF1EB),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Big rating
                          Column(
                            children: [
                              Text(
                                dev.rating.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontSize: 42,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: List.generate(
                                  5,
                                      (i) => Icon(
                                    i < dev.rating.floor()
                                        ? Icons.star_rounded
                                        : Icons.star_border_rounded,
                                    color: AppColors.yellow,
                                    size: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                dev.reviewCount,
                                style: text11(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                          const SizedBox(width: 20),

                          // Rating bars
                          Expanded(
                            child: Column(
                              children: ratingBreakdown
                                  .map((r) => _RatingBarRow(data: r))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // ── Review Cards ─────────────────────────────────
                    ...dev.reviews.map(
                          (r) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _ReviewCard(review: r),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Back to Home ─────────────────────────────────
                    AppButton(
                      title: 'Back to Home',
                      onTap: () {
                        context.goNamed(AppPage.myHomeName);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Bottom Sheet for Enquiry ──────────────────────────────────────
  void _showEnquiryBottomSheet(
      BuildContext context,
      WidgetRef ref, {
        required String developerId,
      }) {
    final TextEditingController messageController = TextEditingController();
    bool isLoading = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      'Send Enquiry',
                      style: text18(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your message will be sent to the developer.',
                      style: text13(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 20),

                    // Message TextField
                    TextField(
                      controller: messageController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Write your message here...',
                        hintStyle: text15(color: AppColors.hintText),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.grey300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.grey300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.primary),
                        ),
                        filled: true,
                        fillColor: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                        onPressed: () async {
                          final message = messageController.text.trim();
                          if (message.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter a message.'),
                              ),
                            );
                            return;
                          }

                          setState(() => isLoading = true);

                          final enquiryNotifier =
                          ref.read(enquiryProvider.notifier);
                          final success =
                          await enquiryNotifier.submitEnquiry(
                            developerId: developerId,
                            message: message,
                          );

                          setState(() => isLoading = false);

                          // Close bottom sheet
                          Navigator.pop(context);

                          // Show feedback
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Enquiry submitted successfully!',
                                ),
                                backgroundColor: AppColors.success,
                              ),
                            );
                          } else {
                            final error = ref
                                .read(enquiryProvider)
                                .errorMessage ??
                                'Something went wrong.';
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(error),
                                backgroundColor: AppColors.error,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          'Submit',
                          style: text16(
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// ─── Stat Chip ────────────────────────────────────────────────────────────────

class _StatChip extends StatelessWidget {
  final String value;
  final String label;

  const _StatChip({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: text16(fontWeight: FontWeight.bold, color: AppColors.white),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: text10(color: Colors.white.withOpacity(0.85)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─── Small Badge ─────────────────────────────────────────────────────────────

class _SmallBadge extends StatelessWidget {
  final String label;
  const _SmallBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Text(
        label,
        style: text11(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ─── Rating Bar Row ───────────────────────────────────────────────────────────

class _RatingBar {
  final int stars;
  final double fraction;
  const _RatingBar({required this.stars, required this.fraction});
}

class _RatingBarRow extends StatelessWidget {
  final _RatingBar data;
  const _RatingBarRow({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            '${data.stars}',
            style: text12(
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: data.fraction,
                minHeight: 7,
                backgroundColor: Colors.white.withOpacity(0.5),
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Review Card ─────────────────────────────────────────────────────────────

class _ReviewCard extends StatelessWidget {
  final ReviewModel review;
  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.blue.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    review.initials,
                    style: text12(
                      fontWeight: FontWeight.bold,
                      color: AppColors.blue,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  review.name,
                  style: text14(fontWeight: FontWeight.w600),
                ),
              ),
              // Star rating
              Row(
                children: List.generate(
                  5,
                      (i) => Icon(
                    i < review.rating.floor()
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    color: AppColors.yellow,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            review.review,
            style: text13(color: AppColors.textSecondary).copyWith(height: 1.5),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                review.projectBought,
                style: text11(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(review.timeAgo, style: text11(color: AppColors.hintText)),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Fallback developer ───────────────────────────────────────────────────────

const _defaultDeveloper = DeveloperModel(
  id: 'default',
  name: 'Godrej Properties',
  coverage: 'Pan India · 80+ projects',
  projects: 80,
  rating: 4.9,
  reviewCount: '12K reviews',
  reraApproved: true,
  isoCertified: true,
  bseListed: true,
  established: 'Est. 1990 · BSE listed',
  unitsDelivered: 15000,
  cities: 12,
  about:
  'Godrej Properties brings the Godrej Group philosophy of innovation, sustainability and excellence to the real estate industry. They have won over 250 awards for excellence in construction, design and delivery. All projects are IGBC green-rated.',
  reviews: [
    ReviewModel(
      name: 'Anil Verma',
      initials: 'AV',
      rating: 5.0,
      review:
      'Excellent construction quality. Delivered on time. The admin team at NestKey made the entire process smooth.',
      projectBought: 'Bought Godrej Meridian',
      timeAgo: '2 weeks ago',
    ),
  ],
);