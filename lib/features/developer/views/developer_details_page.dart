import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/developer/model/payload/review_payload.dart';
import 'package:gharmb_app/features/developer/model/response/developer_reviews_response.dart';
import 'package:gharmb_app/features/developer/providers/developer_provider.dart';
import 'package:gharmb_app/features/developer/providers/enquiry_provider.dart';
import 'package:gharmb_app/features/developer/providers/review_provider.dart';
import 'package:gharmb_app/features/wishlist/providers/wishlist_provider.dart';
import 'package:gharmb_app/routes/app_page.dart';
import 'package:gharmb_app/shared/button/custom_button.dart';
import 'package:gharmb_app/shared/snakebar/custom_snakebar.dart';
import 'package:go_router/go_router.dart';

class DeveloperDetailPage extends ConsumerStatefulWidget {
  final String? developerId;
  const DeveloperDetailPage({super.key, this.developerId});

  @override
  ConsumerState<DeveloperDetailPage> createState() =>
      _DeveloperDetailPageState();
}

class _DeveloperDetailPageState extends ConsumerState<DeveloperDetailPage> {
  @override
  Widget build(BuildContext context) {
    final selectedDev = ref.watch(selectedDeveloperProvider);
    final dev = selectedDev ?? _defaultDeveloper;
    final devId = (widget.developerId != null && widget.developerId!.isNotEmpty)
        ? widget.developerId!
        : dev.id;

    final reviewsAsync = ref.watch(developerReviewsProvider(devId));
    final wishlistState = ref.watch(wishlistProvider);
    final isWishlisted = wishlistState.items.any(
      (item) => item.property?.id == devId || item.id == devId,
    );

    final stats = reviewsAsync.value?.stats;
    final avgRating = stats?.averageRating ?? dev.rating;
    final totalCount = stats != null
        ? '${stats.totalReviews} reviews'
        : dev.reviewCount;

    // Dynamic rating breakdown (5,4,3,2,1 stars)
    final ratingBreakdown = [5, 4, 3, 2, 1].map((s) {
      final fraction = stats != null
          ? stats.fractionForStar(s)
          : (s == 5 ? 0.7 : s == 4 ? 0.2 : 0.05);
      return _RatingBar(stars: s, fraction: fraction);
    }).toList();

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
                  // ── Wishlist Heart Button ──────────────────────────
                  GestureDetector(
                    onTap: () async {
                      final added = await ref
                          .read(wishlistProvider.notifier)
                          .toggleWishlist(
                            propertyId: devId,
                            itemType: 'Developer',
                          );
                      if (context.mounted) {
                        AppSnackBar.showSuccess(
                          context,
                          title: added ? 'Wishlisted!' : 'Removed',
                          message: added
                              ? '${dev.name} added to your wishlist'
                              : '${dev.name} removed from wishlist',
                        );
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isWishlisted
                            ? AppColors.error.withOpacity(0.1)
                            : AppColors.grey100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isWishlisted
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color:
                            isWishlisted ? AppColors.error : AppColors.grey400,
                        size: 22,
                      ),
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
                                          avgRating.toStringAsFixed(1),
                                          style: text12(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          totalCount,
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
                              if (dev.reraApproved) const _SmallBadge(label: 'RERA'),
                              if (dev.isoCertified)
                                const _SmallBadge(label: 'ISO certified'),
                              if (dev.bseListed)
                                const _SmallBadge(label: 'BSE Listed'),
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

                    // ── Action Buttons Row ───────────────────────────
                    Row(
                      children: [
                        // Enquire Now
                        Expanded(
                          flex: 2,
                          child: AppButton(
                            title: "Enquire now",
                            onTap: () {
                              _showEnquiryBottomSheet(
                                context,
                                ref,
                                developerId: devId,
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Add Review
                        Expanded(
                          flex: 2,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              _showAddReviewBottomSheet(
                                context,
                                ref,
                                developerId: devId,
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.primary),
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            icon: const Icon(
                              Icons.rate_review_outlined,
                              size: 16,
                              color: AppColors.primary,
                            ),
                            label: Text(
                              'Add Review',
                              style: text13(
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
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
                                avgRating.toStringAsFixed(1),
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
                                    i < avgRating.floor()
                                        ? Icons.star_rounded
                                        : Icons.star_border_rounded,
                                    color: AppColors.yellow,
                                    size: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                totalCount,
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
                    reviewsAsync.when(
                      data: (res) {
                        final reviewsList = res?.reviews ?? [];
                        if (reviewsList.isEmpty) {
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              vertical: 24,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.grey100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.rate_review_outlined,
                                  size: 32,
                                  color: AppColors.grey400,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'No reviews yet',
                                  style: text14(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Be the first to share your experience with this developer!',
                                  style: text12(color: AppColors.textSecondary),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        }
                        return Column(
                          children: reviewsList
                              .map(
                                (r) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: _DeveloperReviewCard(review: r),
                                ),
                              )
                              .toList(),
                        );
                      },
                      loading: () => const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      error: (_, __) => Column(
                        children: dev.reviews
                            .map(
                              (r) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: _ReviewCard(review: r),
                              ),
                            )
                            .toList(),
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
          builder: (context, setModalState) {
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
                                if (developerId.isEmpty ||
                                    developerId == 'default') {
                                  AppSnackBar.showWarning(
                                    context,
                                    title: 'Invalid Developer',
                                    message: 'Developer ID is missing.',
                                  );
                                  return;
                                }
                                if (message.isEmpty) {
                                  AppSnackBar.showWarning(
                                    context,
                                    title: 'Required',
                                    message: 'Please enter a message.',
                                  );
                                  return;
                                }

                                setModalState(() => isLoading = true);

                                final enquiryNotifier =
                                    ref.read(enquiryProvider.notifier);
                                final success =
                                    await enquiryNotifier.submitEnquiry(
                                  developerId: developerId,
                                  message: message,
                                );

                                setModalState(() => isLoading = false);

                                if (context.mounted) {
                                  Navigator.pop(context);
                                }

                                if (success) {
                                  if (context.mounted) {
                                    AppSnackBar.showSuccess(
                                      context,
                                      title: 'Success',
                                      message:
                                          'Enquiry submitted successfully!',
                                    );
                                  }
                                } else {
                                  if (context.mounted) {
                                    final error = ref
                                            .read(enquiryProvider)
                                            .errorMessage ??
                                        'Something went wrong.';
                                    AppSnackBar.showError(
                                      context,
                                      title: 'Error',
                                      message: error,
                                    );
                                  }
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

  // ─── Bottom Sheet for Add Review ───────────────────────────────────────
  void _showAddReviewBottomSheet(
    BuildContext context,
    WidgetRef ref, {
    required String developerId,
  }) {
    int selectedStars = 5;
    List<String> selectedTags = ['Quality'];
    final commentController = TextEditingController();
    bool isLoading = false;
    final tags = ['Quality', 'Timely Delivery', 'Support', 'Value for Money'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (sheetCtx, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(sheetCtx).viewInsets.bottom + 16,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle
                    Center(
                      child: Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.grey300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Text(
                      'Add Your Review',
                      style: text18(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Share your experience with this developer',
                      style: text13(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 20),

                    // Star Rating
                    Text(
                      'Rating',
                      style: text13(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (i) {
                        return GestureDetector(
                          onTap: () =>
                              setModalState(() => selectedStars = i + 1),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.all(4),
                            child: Icon(
                              i < selectedStars
                                  ? Icons.star_rounded
                                  : Icons.star_border_rounded,
                              color: AppColors.yellow,
                              size: 38,
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 16),

                    // Tag selector
                    Text(
                      'What are you rating?',
                      style: text13(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: tags.map((tag) {
                        final isSelected = selectedTags.contains(tag);
                        return GestureDetector(
                          onTap: () => setModalState(() {
                            if (isSelected) {
                              if (selectedTags.length > 1) {
                                selectedTags.remove(tag);
                              }
                            } else {
                              selectedTags.add(tag);
                            }
                          }),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.grey100,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.grey300,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isSelected) ...[
                                  const Icon(
                                    Icons.check,
                                    size: 14,
                                    color: AppColors.white,
                                  ),
                                  const SizedBox(width: 4),
                                ],
                                Text(
                                  tag,
                                  style: text12(
                                    color: isSelected
                                        ? AppColors.white
                                        : AppColors.textPrimary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // Comment
                    Text(
                      'Your Review',
                      style: text13(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: commentController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Write your experience...',
                        hintStyle: text13(color: AppColors.hintText),
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
                    const SizedBox(height: 20),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              onPressed: () async {
                                if (developerId.isEmpty ||
                                    developerId == 'default') {
                                  AppSnackBar.showWarning(
                                    context,
                                    title: 'Invalid Developer',
                                    message: 'Developer ID is missing.',
                                  );
                                  return;
                                }
                                if (selectedStars == 0) {
                                  AppSnackBar.showWarning(
                                    context,
                                    title: 'Rating Required',
                                    message: 'Please select a star rating.',
                                  );
                                  return;
                                }
                                final comment = commentController.text.trim();
                                if (comment.isEmpty) {
                                  AppSnackBar.showWarning(
                                    context,
                                    title: 'Review Required',
                                    message: 'Please write your review.',
                                  );
                                  return;
                                }

                                setModalState(() => isLoading = true);

                                final success = await ref
                                    .read(reviewProvider.notifier)
                                    .submitReview(
                                      developerId: developerId,
                                      payload: ReviewPayload(
                                        rating: selectedStars,
                                        comment: comment,
                                        tag: selectedTags.join(', '),
                                        whatAreYouRating: selectedTags,
                                      ),
                                    );

                                setModalState(() => isLoading = false);
                                if (sheetCtx.mounted) {
                                  Navigator.pop(sheetCtx);
                                }

                                if (success) {
                                  if (context.mounted) {
                                    AppSnackBar.showSuccess(
                                      context,
                                      title: 'Review Submitted!',
                                      message:
                                          'Thank you for your feedback.',
                                    );
                                  }
                                } else {
                                  if (context.mounted) {
                                    AppSnackBar.showError(
                                      context,
                                      title: 'Failed',
                                      message: ref
                                              .read(reviewProvider)
                                              .errorMessage ??
                                          'Could not submit review.',
                                    );
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Text(
                                'Submit Review',
                                style: text15(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(height: 8),
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

// ─── Developer Review Card (Live API) ──────────────────────────────────

class _DeveloperReviewCard extends StatelessWidget {
  final DeveloperReviewItem review;
  const _DeveloperReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    final reviewerName = review.reviewer?.name ?? 'Verified Buyer';
    final initials = review.reviewer?.initials ?? 'VB';
    final avatarUrl = review.reviewer?.profilePicture ?? '';

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
                child: ClipOval(
                  child: avatarUrl.isNotEmpty
                      ? Image.network(
                          avatarUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Center(
                            child: Text(
                              initials,
                              style: text12(
                                fontWeight: FontWeight.bold,
                                color: AppColors.blue,
                              ),
                            ),
                          ),
                        )
                      : Center(
                          child: Text(
                            initials,
                            style: text12(
                              fontWeight: FontWeight.bold,
                              color: AppColors.blue,
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reviewerName,
                      style: text14(fontWeight: FontWeight.w600),
                    ),
                    if (review.tags.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Wrap(
                          spacing: 4,
                          children: review.tags
                              .map(
                                (t) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    t,
                                    style: text10(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                  ],
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
          if (review.comment.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              review.comment,
              style:
                  text13(color: AppColors.textSecondary).copyWith(height: 1.5),
            ),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Verified Buyer',
                style: text11(
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
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

// ─── Review Card (Fallback) ──────────────────────────────────────────────────

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