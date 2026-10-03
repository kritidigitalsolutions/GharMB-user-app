import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/commercial/providers/commercial_provider.dart';
import 'package:gharmb_app/features/developer/model/payload/review_payload.dart';
import 'package:gharmb_app/features/developer/providers/enquiry_provider.dart';
import 'package:gharmb_app/features/developer/providers/review_provider.dart';
import 'package:gharmb_app/features/property/models/response/near_properties_response.dart';
import 'package:gharmb_app/features/wishlist/providers/wishlist_provider.dart';
import 'package:gharmb_app/features/commercial/repo/commercial_repo.dart';
import 'package:gharmb_app/shared/button/custom_button.dart';
import 'package:gharmb_app/shared/snakebar/custom_snakebar.dart';
import 'package:gharmb_app/shared/widget/custom_shimmer.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class CommercialPropertyDetailsPage extends ConsumerStatefulWidget {
  final String? spaceId;
  final Property? initialProperty;

  const CommercialPropertyDetailsPage({
    super.key,
    this.spaceId,
    this.initialProperty,
  });

  @override
  ConsumerState<CommercialPropertyDetailsPage> createState() =>
      _CommercialPropertyDetailsPageState();
}

class _CommercialPropertyDetailsPageState
    extends ConsumerState<CommercialPropertyDetailsPage> {
  int _activeImageIndex = 0;
  Property? _fetchedProperty;
  bool _isLoadingDetail = false;

  @override
  void initState() {
    super.initState();
    _fetchedProperty = widget.initialProperty;
    if (_fetchedProperty == null && widget.spaceId != null) {
      _loadSpaceDetail(widget.spaceId!);
    }
  }

  Future<void> _loadSpaceDetail(String id) async {
    setState(() => _isLoadingDetail = true);
    try {
      final res = await CommercialRepo().getCommercialSpaceDetail(id);
      if (mounted) {
        setState(() {
          _fetchedProperty = res;
          _isLoadingDetail = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoadingDetail = false);
      }
    }
  }

  String _formatPrice(int price) {
    if (price >= 10000000) {
      return '₹${(price / 10000000).toStringAsFixed(2)} Cr';
    } else if (price >= 100000) {
      return '₹${(price / 100000).toStringAsFixed(2)} Lakh';
    }
    return '₹$price';
  }

  void _showEnquirySheet(Property property) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CommercialEnquiryBottomSheet(property: property),
    );
  }

  void _showAddReviewSheet(String developerId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddReviewBottomSheet(developerId: developerId),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingDetail) {
      return const Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(child: DetailsPageShimmer()),
      );
    }

    final state = ref.watch(commercialProvider);
    final property = _fetchedProperty ?? state.selectedProperty;

    if (property == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'Commercial Space',
            style: text16(fontWeight: FontWeight.bold),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.storefront_outlined,
                size: 64,
                color: AppColors.grey400,
              ),
              const SizedBox(height: 12),
              Text(
                'Property details not found',
                style: text14(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: Text('Go Back', style: text13(color: AppColors.white)),
              ),
            ],
          ),
        ),
      );
    }

    final developerId = property.owner.id.isNotEmpty
        ? property.owner.id
        : property.id;
    final reviewsAsync = ref.watch(developerReviewsProvider(developerId));

    final wishlistState = ref.watch(wishlistProvider);
    final isWishlisted = wishlistState.items.any(
      (item) => item.property?.id == property.id || item.id == property.id,
    );

    final String tag = property.listingFor.toLowerCase() == 'rent'
        ? 'For Rent'
        : 'For Sale';
    final images = property.images.isNotEmpty ? property.images : <String>[];

    final stats = reviewsAsync.value?.stats;
    final reviews = reviewsAsync.value?.reviews ?? [];
    final avgRating = stats?.averageRating ?? 4.5;
    final totalReviews = stats?.totalReviews ?? reviews.length;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // ── Hero SliverAppBar ──────────────────────────────────
              SliverAppBar(
                expandedHeight: 260,
                pinned: true,
                backgroundColor: AppColors.primary,
                leading: GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: AppColors.white,
                      size: 20,
                    ),
                  ),
                ),
                actions: [
                  GestureDetector(
                    onTap: () async {
                      final added = await ref
                          .read(wishlistProvider.notifier)
                          .toggleWishlist(
                            propertyId: property.id,
                            itemType: 'Property',
                          );
                      if (context.mounted) {
                        AppSnackBar.showSuccess(
                          context,
                          title: added ? 'Wishlisted' : 'Removed',
                          message: added
                              ? 'Added to your wishlist'
                              : 'Removed from wishlist',
                        );
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        isWishlisted
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: isWishlisted ? AppColors.error : AppColors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (images.isNotEmpty)
                        PageView.builder(
                          itemCount: images.length,
                          onPageChanged: (i) =>
                              setState(() => _activeImageIndex = i),
                          itemBuilder: (_, i) => Image.network(
                            images[i],
                            fit: BoxFit.fill,
                            errorBuilder: (_, __, ___) => _DefaultCover(),
                          ),
                        )
                      else
                        _DefaultCover(),

                      // Top / Bottom Gradient
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black45,
                              Colors.transparent,
                              Colors.black54,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),

                      // Tag
                      Positioned(
                        top: 56,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: tag == 'For Sale'
                                ? AppColors.primary
                                : AppColors.success,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            tag,
                            style: text11(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      // Photos index badge
                      if (images.length > 1)
                        Positioned(
                          bottom: 14,
                          right: 14,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.65),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.photo_library_outlined,
                                  color: AppColors.white,
                                  size: 13,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${_activeImageIndex + 1}/${images.length} Photos',
                                  style: text11(color: AppColors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // ── Body Details ───────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 110),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Price & Title ──────────────────────────────
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  _formatPrice(property.price),
                                  style: text24(fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                if (property.isLive)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.success.withOpacity(
                                        0.12,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.verified,
                                          size: 14,
                                          color: AppColors.success,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Verified Space',
                                          style: text11(
                                            color: AppColors.success,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              property.title.isNotEmpty
                                  ? property.title
                                  : '${property.propertyType} in ${property.locality}',
                              style: text15(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  size: 15,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    [
                                      property.fullAddress,
                                      property.city,
                                    ].where((s) => s.isNotEmpty).join(', '),
                                    style: text12(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // ── Installment / EMI Plan (if allowed) ─────────
                      if (property.allowInstallments)
                        _CommercialInstallmentPlanCard(property: property),

                      const SizedBox(height: 16),
                      _Divider2(),

                      // ── Key Specifications ─────────────────────────
                      const _SectionTitle('Key Specifications'),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            _SpecCard(
                              label: 'Carpet Area',
                              value: '${property.carpetArea} sqft',
                              icon: Icons.aspect_ratio_rounded,
                            ),
                            if (property.builtUpArea > 0)
                              _SpecCard(
                                label: 'Built-up Area',
                                value: '${property.builtUpArea} sqft',
                                icon: Icons.straighten_rounded,
                              ),
                            if (property.floorNo.isNotEmpty)
                              _SpecCard(
                                label: 'Floor Level',
                                value: 'Floor ${property.floorNo}',
                                icon: Icons.stairs_rounded,
                              ),
                            if (property.furnishing.isNotEmpty)
                              _SpecCard(
                                label: 'Furnishing',
                                value: property.furnishing,
                                icon: Icons.chair_outlined,
                              ),
                            if (property.parking.isNotEmpty)
                              _SpecCard(
                                label: 'Parking',
                                value: property.parking,
                                icon: Icons.local_parking_rounded,
                              ),
                            if (property.facingDirection.isNotEmpty)
                              _SpecCard(
                                label: 'Facing',
                                value: property.facingDirection,
                                icon: Icons.explore_outlined,
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _Divider2(),

                      // ── Description ────────────────────────────────
                      if (property.description.isNotEmpty) ...[
                        const _SectionTitle('About this Commercial Space'),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            property.description,
                            style: text13(
                              color: AppColors.textSecondary,
                            ).copyWith(height: 1.6),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _Divider2(),
                      ],

                      // ── Amenities & Features ───────────────────────
                      if (property.amenities.isNotEmpty) ...[
                        const _SectionTitle('Amenities & Features'),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: property.amenities.map((a) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.grey50,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppColors.grey200),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.check_circle_outline,
                                      size: 16,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      a,
                                      style: text12(
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _Divider2(),
                      ],

                      // ── Developer / Owner Profile ──────────────────
                      const _SectionTitle('Developer / Owner Information'),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.grey200),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.business_rounded,
                                  color: AppColors.primary,
                                  size: 26,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      property.owner.name.isNotEmpty
                                          ? property.owner.name
                                          : 'Verified Developer',
                                      style: text15(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      'BUILDER · Real Estate Partner',
                                      style: text11(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.phone_outlined,
                                  color: AppColors.primary,
                                ),
                                onPressed: () {
                                  if (property.owner.phone.isNotEmpty) {
                                    launchUrl(
                                      Uri.parse('tel:${property.owner.phone}'),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _Divider2(),

                      // ── Buyer Reviews & Ratings ────────────────────
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Buyer & Investor Reviews',
                              style: text16(fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                              onTap: () => _showAddReviewSheet(developerId),
                              child: Text(
                                '+ Add Review',
                                style: text13(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Overall Rating Breakdown Card
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFAF6F2),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  Text(
                                    avgRating.toStringAsFixed(1),
                                    style: text20(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: List.generate(
                                      5,
                                      (i) => Icon(
                                        i < avgRating.floor()
                                            ? Icons.star_rounded
                                            : (i < avgRating
                                                  ? Icons.star_half_rounded
                                                  : Icons.star_outline_rounded),
                                        size: 16,
                                        color: Colors.amber,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '$totalReviews reviews',
                                    style: text11(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                child: Column(
                                  children: [5, 4, 3, 2, 1].map((s) {
                                    final fraction = stats != null
                                        ? stats.fractionForStar(s)
                                        : (s == 5
                                              ? 0.7
                                              : s == 4
                                              ? 0.2
                                              : 0.05);
                                    return _RatingProgressBar(
                                      star: s,
                                      fraction: fraction,
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Reviews List
                      if (reviews.isNotEmpty)
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: reviews.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (_, i) =>
                              _ReviewCard(review: reviews[i]),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Text(
                            'No reviews yet. Be the first to share your experience!',
                            style: text13(color: AppColors.textSecondary),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ── Fixed Bottom Actions ───────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                16,
                12,
                16,
                MediaQuery.of(context).padding.bottom + 12,
              ),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _showEnquirySheet(property),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Enquire Now',
                        style: text14(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        if (property.owner.phone.isNotEmpty) {
                          launchUrl(
                            Uri.parse('tel:${property.owner.phone}'),
                          );
                        } else {
                          _showEnquirySheet(property);
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Call Developer',
                        style: text14(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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

// ─── Helpers ──────────────────────────────────────────────────────────────────

class _DefaultCover extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2C3E50), Color(0xFF4CA1AF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.storefront_outlined,
          size: 80,
          color: Colors.white.withOpacity(0.2),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
    child: Text(title, style: text16(fontWeight: FontWeight.bold)),
  );
}

class _Divider2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(height: 8, color: AppColors.grey50);
}

class _SpecCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _SpecCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width - 44) / 2,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Row(
        children: [
          Icon(icon, size: 22, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: text11(color: AppColors.textSecondary)),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: text13(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingProgressBar extends StatelessWidget {
  final int star;
  final double fraction;

  const _RatingProgressBar({required this.star, required this.fraction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Text('$star', style: text11(fontWeight: FontWeight.w600)),
          const Icon(Icons.star_rounded, size: 13, color: Colors.amber),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: fraction.clamp(0.0, 1.0),
                backgroundColor: AppColors.grey200,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                minHeight: 6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final dynamic review;
  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    final reviewerName = review.reviewer?.name ?? 'Verified Buyer';
    final comment = review.comment ?? '';
    final rating = review.rating ?? 5;
    final tags = review.tags as List<String>? ?? [];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Text(
                  reviewerName.isNotEmpty ? reviewerName[0] : 'U',
                  style: text13(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
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
                      style: text13(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (i) => Icon(
                          i < rating
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          size: 13,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (tags.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              children: tags
                  .map(
                    (t) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.grey100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        t,
                        style: text10(color: AppColors.textSecondary),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
          if (comment.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(comment, style: text12(color: AppColors.textPrimary)),
          ],
        ],
      ),
    );
  }
}

// ─── Enquiry Sheet ────────────────────────────────────────────────────────────

class _CommercialEnquiryBottomSheet extends ConsumerStatefulWidget {
  final Property property;
  const _CommercialEnquiryBottomSheet({required this.property});

  @override
  ConsumerState<_CommercialEnquiryBottomSheet> createState() =>
      _CommercialEnquiryBottomSheetState();
}

class _CommercialEnquiryBottomSheetState
    extends ConsumerState<_CommercialEnquiryBottomSheet> {
  final TextEditingController _msgCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _msgCtrl.text =
        'Hello, I am interested in ${widget.property.title.isNotEmpty ? widget.property.title : widget.property.propertyType} in ${widget.property.locality}. Please contact me.';
  }

  @override
  void dispose() {
    _msgCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final msg = _msgCtrl.text.trim();
    if (msg.isEmpty) {
      AppSnackBar.showError(
        context,
        title: 'Required',
        message: 'Please enter enquiry message',
      );
      return;
    }

    final developerId = widget.property.owner.id.isNotEmpty
        ? widget.property.owner.id
        : widget.property.id;

    final ok = await ref
        .read(enquiryProvider.notifier)
        .submitEnquiry(developerId: developerId, message: msg);

    if (!mounted) return;
    if (ok) {
      Navigator.pop(context);
      AppSnackBar.showSuccess(
        context,
        title: 'Enquiry Sent',
        message: 'Your enquiry has been submitted!',
      );
    } else {
      final err =
          ref.read(enquiryProvider).errorMessage ?? 'Failed to submit enquiry';
      AppSnackBar.showError(context, title: 'Error', message: err);
    }
  }

  @override
  Widget build(BuildContext context) {
    final enquiryState = ref.watch(enquiryProvider);

    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Send Enquiry to Developer',
                  style: text16(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _msgCtrl,
              maxLines: 4,
              style: text13(),
              decoration: InputDecoration(
                hintText: 'Enter your message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 20),
            AppButton(
              title: 'Send Enquiry',
              isLoading: enquiryState.isLoading,
              onTap: _submit,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Add Review Sheet ─────────────────────────────────────────────────────────

class _AddReviewBottomSheet extends ConsumerStatefulWidget {
  final String developerId;
  const _AddReviewBottomSheet({required this.developerId});

  @override
  ConsumerState<_AddReviewBottomSheet> createState() =>
      _AddReviewBottomSheetState();
}

class _AddReviewBottomSheetState extends ConsumerState<_AddReviewBottomSheet> {
  int _selectedRating = 5;
  final List<String> _selectedTags = [];
  final TextEditingController _commentCtrl = TextEditingController();

  static const _availableTags = [
    'Quality',
    'Timely Delivery',
    'Support',
    'Value for Money',
  ];

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final comment = _commentCtrl.text.trim();
    if (comment.isEmpty) {
      AppSnackBar.showError(
        context,
        title: 'Required',
        message: 'Please enter your review feedback',
      );
      return;
    }

    final ok = await ref
        .read(reviewProvider.notifier)
        .submitReview(
          developerId: widget.developerId,
          payload: ReviewPayload(
            rating: _selectedRating,
            comment: comment,
            tags: _selectedTags,
          ),
        );

    if (!mounted) return;
    if (ok) {
      Navigator.pop(context);
      AppSnackBar.showSuccess(
        context,
        title: 'Review Submitted',
        message: 'Thank you for your valuable feedback!',
      );
    } else {
      final err =
          ref.read(reviewProvider).errorMessage ?? 'Failed to submit review';
      AppSnackBar.showError(context, title: 'Error', message: err);
    }
  }

  @override
  Widget build(BuildContext context) {
    final reviewState = ref.watch(reviewProvider);

    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add Your Review',
                  style: text18(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Rating Stars
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (i) {
                  final starNum = i + 1;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedRating = starNum),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Icon(
                        starNum <= _selectedRating
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        size: 36,
                        color: Colors.amber,
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),

            // Rating Tags
            Text(
              'What are you rating?',
              style: text13(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _availableTags.map((tag) {
                final isSelected = _selectedTags.contains(tag);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedTags.remove(tag);
                      } else {
                        _selectedTags.add(tag);
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.grey100,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      tag,
                      style: text12(
                        color: isSelected
                            ? AppColors.white
                            : AppColors.textPrimary,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Comment
            Text('Your Experience', style: text13(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            TextField(
              controller: _commentCtrl,
              maxLines: 3,
              style: text13(),
              decoration: InputDecoration(
                hintText: 'Share details of your experience...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 20),

            AppButton(
              title: 'Submit Review',
              isLoading: reviewState.isLoading,
              onTap: _submit,
            ),
          ],
        ),
      ),
    );
  }
}

class _CommercialInstallmentPlanCard extends StatelessWidget {
  final Property property;

  const _CommercialInstallmentPlanCard({required this.property});

  String _formatCurrency(int amount) {
    if (amount <= 0) return '₹0';
    if (amount >= 10000000) {
      final cr = amount / 10000000;
      return '₹${cr.toStringAsFixed(cr.truncateToDouble() == cr ? 0 : 2)} Cr';
    } else if (amount >= 100000) {
      final l = amount / 100000;
      return '₹${l.toStringAsFixed(l.truncateToDouble() == l ? 0 : 2)} L';
    } else if (amount >= 1000) {
      final k = amount / 1000;
      return '₹${k.toStringAsFixed(k.truncateToDouble() == k ? 0 : 1)} K';
    }
    return '₹$amount';
  }

  @override
  Widget build(BuildContext context) {
    final details = property.installmentDetails;

    // Down payment text
    String downPaymentText = 'Available';
    if (details != null && details.downPaymentAmount > 0) {
      downPaymentText = _formatCurrency(details.downPaymentAmount);
      if (details.downPaymentPercentage > 0) {
        downPaymentText += ' (${details.downPaymentPercentage}%)';
      }
    } else if (details != null && details.downPaymentPercentage > 0) {
      downPaymentText = '${details.downPaymentPercentage}%';
    }

    // Installment / EMI text
    String emiText = 'Flexible';
    if (details != null && details.installmentAmount > 0) {
      final freq = details.installmentFrequency.isNotEmpty
          ? details.installmentFrequency.toLowerCase().replaceAll('ly', '')
          : 'mo';
      emiText = '${_formatCurrency(details.installmentAmount)} / $freq';
    } else if (details != null && details.numberOfInstallments > 0) {
      emiText = '${details.numberOfInstallments} Installments';
    }

    // Tenure / Duration
    String durationText = 'Custom Plan';
    if (details != null && details.numberOfInstallments > 0) {
      final freq = details.installmentFrequency.isNotEmpty
          ? details.installmentFrequency
          : 'Monthly';
      if (details.installmentDurationMonths > 0 &&
          details.installmentDurationMonths != details.numberOfInstallments) {
        durationText =
            '${details.numberOfInstallments} ($freq) · ${details.installmentDurationMonths}M';
      } else {
        durationText = '${details.numberOfInstallments} ($freq)';
      }
    } else if (details != null && details.installmentDurationMonths > 0) {
      durationText = '${details.installmentDurationMonths} Months';
    }

    // Interest rate
    String interestText = '0% (Interest Free)';
    if (details != null && details.interestRate > 0) {
      interestText = '${details.interestRate}% p.a.';
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.grey200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.payments_outlined,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Installment / EMI Plan',
                        style: text14(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        'Flexible payment options available for this commercial space',
                        style: text11(color: AppColors.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Available',
                    style: text10(
                      color: const Color(0xFF2E7D32),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // 2x2 Metric Cards Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 2.3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: [
                _CommercialInstallmentMetricTile(
                  title: 'Down Payment',
                  value: downPaymentText,
                  icon: Icons.account_balance_wallet_outlined,
                ),
                _CommercialInstallmentMetricTile(
                  title: 'Estimated EMI',
                  value: emiText,
                  icon: Icons.credit_card_outlined,
                ),
                _CommercialInstallmentMetricTile(
                  title: 'Tenure & Frequency',
                  value: durationText,
                  icon: Icons.calendar_month_outlined,
                ),
                _CommercialInstallmentMetricTile(
                  title: 'Interest Rate',
                  value: interestText,
                  icon: Icons.percent_outlined,
                ),
              ],
            ),

            // Grace Period Pill
            if (details != null && details.gracePeriodDays > 0) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.grey50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.schedule,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Grace Period: ${details.gracePeriodDays} days after due date',
                      style: text11(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Terms and conditions note
            if (details != null &&
                details.termsAndConditions.trim().isNotEmpty) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.grey50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.grey200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Terms & Conditions',
                      style: text11(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      details.termsAndConditions.trim(),
                      style: text12(color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CommercialInstallmentMetricTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _CommercialInstallmentMetricTile({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: text10(color: AppColors.textSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: text12(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

