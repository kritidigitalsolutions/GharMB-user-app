import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/commercial/providers/commercial_provider.dart';
import 'package:gharmb_app/features/commercial/widget/commercial_appbar.dart';
import 'package:gharmb_app/features/developer/providers/enquiry_provider.dart';
import 'package:gharmb_app/features/property/models/response/near_properties_response.dart';
import 'package:gharmb_app/features/wishlist/providers/wishlist_provider.dart';
import 'package:gharmb_app/routes/app_page.dart';
import 'package:gharmb_app/shared/button/custom_button.dart';
import 'package:gharmb_app/shared/snakebar/custom_snakebar.dart';
import 'package:gharmb_app/shared/widget/custom_shimmer.dart';
import 'package:go_router/go_router.dart';

class CommercialListingsPage extends ConsumerStatefulWidget {
  const CommercialListingsPage({super.key});

  @override
  ConsumerState<CommercialListingsPage> createState() =>
      _CommercialListingsPageState();
}

class _CommercialListingsPageState
    extends ConsumerState<CommercialListingsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(commercialProvider.notifier).loadMore();
    }
  }

  void _showEnquirySheet(Property property) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EnquiryBottomSheet(property: property),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(commercialProvider);
    final notifier = ref.read(commercialProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Column(
          children: [
            // ── App Bar ──────────────────────────────────────────────
            Container(
              color: AppColors.white,
              child: CommercialAppBar(
                title: 'Commercial spaces',
                subtitle: state.isLoading
                    ? 'Loading spaces...'
                    : '${state.totalCount} spaces found',
              ),
            ),

            // ── Mode & Category Filters ──────────────────────────────
            Container(
              color: AppColors.white,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Column(
                children: [
                  // Buy / Rent Toggle
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.grey100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _FilterTab(
                            title: 'For Sale / Buy',
                            isSelected: state.mode == CommercialMode.buy,
                            onTap: () => notifier.setMode(CommercialMode.buy),
                          ),
                        ),
                        Expanded(
                          child: _FilterTab(
                            title: 'For Rent',
                            isSelected: state.mode == CommercialMode.rent,
                            onTap: () => notifier.setMode(CommercialMode.rent),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Categories Horizontal Bar
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _CategoryChip(
                          label: 'All Spaces',
                          isSelected: state.selectedCategory == null,
                          onTap: () => notifier.setCategory(null),
                        ),
                        ...CommercialCategory.values.map(
                          (cat) => _CategoryChip(
                            label: cat.label,
                            isSelected: state.selectedCategory == cat,
                            onTap: () => notifier.setCategory(
                              state.selectedCategory == cat ? null : cat,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Listings Content ─────────────────────────────────────
            Expanded(
              child: RefreshIndicator(
                onRefresh: () =>
                    notifier.fetchCommercialSpaces(refresh: true),
                color: AppColors.primary,
                child: state.isLoading && state.properties.isEmpty
                    ? const CommercialListShimmer(itemCount: 4)
                    : state.properties.isEmpty
                    ? SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.55,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(0.08),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.storefront_outlined,
                                      size: 54,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No Commercial Spaces Found',
                                    style: text16(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Try changing the filters or switching between Buy/Rent.',
                                    textAlign: TextAlign.center,
                                    style: text13(color: AppColors.textSecondary),
                                  ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    width: 160,
                                    height: 42,
                                    child: ElevatedButton(
                                      onPressed: () => notifier.fetchCommercialSpaces(
                                        refresh: true,
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Text(
                                        'Refresh',
                                        style: text13(
                                          color: AppColors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : ListView.separated(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 30),
                        itemCount: state.properties.length +
                            (state.isMoreLoading ? 1 : 0),
                        separatorBuilder: (_, _) => const SizedBox(height: 14),
                        itemBuilder: (_, i) {
                          if (i == state.properties.length) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: AppColors.primary,
                                ),
                              ),
                            );
                          }

                          final property = state.properties[i];
                          return _CommercialCard(
                            property: property,
                            onViewDetails: () {
                              notifier.selectProperty(property);
                              context.pushNamed(
                                AppPage.commercialPropertyDetailName,
                              );
                            },
                            onEnquire: () => _showEnquirySheet(property),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Filter Tab ───────────────────────────────────────────────────────────────

class _FilterTab extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterTab({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            title,
            style: text12(
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Category Chip ────────────────────────────────────────────────────────────

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.grey100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: text12(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? AppColors.white : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Commercial Property Card ─────────────────────────────────────────────────

class _CommercialCard extends ConsumerWidget {
  final Property property;
  final VoidCallback onViewDetails;
  final VoidCallback onEnquire;

  const _CommercialCard({
    required this.property,
    required this.onViewDetails,
    required this.onEnquire,
  });

  String _formatPrice(int price) {
    if (price >= 10000000) {
      return '₹${(price / 10000000).toStringAsFixed(2)} Cr';
    } else if (price >= 100000) {
      return '₹${(price / 100000).toStringAsFixed(2)} Lakh';
    }
    return '₹$price';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistState = ref.watch(wishlistProvider);
    final isWishlisted = wishlistState.items.any(
      (item) => item.property?.id == property.id || item.id == property.id,
    );

    final String image = property.images.isNotEmpty ? property.images.first : '';
    final String tag = property.listingFor.toLowerCase() == 'rent'
        ? 'For Rent'
        : 'For Sale';
    final String location = [property.locality, property.city]
        .where((s) => s.isNotEmpty)
        .join(', ');

    return GestureDetector(
      onTap: onViewDetails,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero Image ──────────────────────────────────────────────
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: SizedBox(
                height: 180,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (image.isNotEmpty)
                      Image.network(
                        image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _FallbackImage(),
                      )
                    else
                      _FallbackImage(),

                    // Top Gradient Overlay
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.black45, Colors.transparent],
                          begin: Alignment.topCenter,
                          end: Alignment.center,
                        ),
                      ),
                    ),

                    // Tag
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
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

                    // Heart / Wishlist
                    Positioned(
                      top: 10,
                      right: 10,
                      child: GestureDetector(
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
                          padding: const EdgeInsets.all(7),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isWishlisted
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: isWishlisted
                                ? AppColors.error
                                : AppColors.textSecondary,
                            size: 18,
                          ),
                        ),
                      ),
                    ),

                    // Photos badge
                    if (property.images.length > 1)
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.65),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.photo_library_outlined,
                                size: 12,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${property.images.length}',
                                style: text11(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // ── Details ─────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + Price Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          property.title.isNotEmpty
                              ? property.title
                              : property.propertyType,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: text15(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatPrice(property.price),
                        style: text16(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Property Specs (Type · Area · Floor)
                  Text(
                    [
                      if (property.propertyType.isNotEmpty)
                        property.propertyType,
                      if (property.carpetArea > 0)
                        '${property.carpetArea} sqft',
                      if (property.floorNo.isNotEmpty)
                        'Floor: ${property.floorNo}',
                    ].join(' · '),
                    style: text12(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 8),

                  // Location
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location.isNotEmpty
                              ? location
                              : 'Location upon request',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: text12(color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onViewDetails,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'View Details',
                            style: text13(
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onEnquire,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: const BorderSide(
                              color: AppColors.primary,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Enquire',
                            style: text13(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Fallback Image ───────────────────────────────────────────────────────────

class _FallbackImage extends StatelessWidget {
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
          size: 64,
          color: Colors.white.withOpacity(0.25),
        ),
      ),
    );
  }
}

// ─── Enquiry Bottom Sheet ─────────────────────────────────────────────────────

class _EnquiryBottomSheet extends ConsumerStatefulWidget {
  final Property property;
  const _EnquiryBottomSheet({required this.property});

  @override
  ConsumerState<_EnquiryBottomSheet> createState() =>
      _EnquiryBottomSheetState();
}

class _EnquiryBottomSheetState extends ConsumerState<_EnquiryBottomSheet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _messageController.text =
        'Hello, I am interested in ${widget.property.title.isNotEmpty ? widget.property.title : widget.property.propertyType} at ${widget.property.locality}. Please provide more details.';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitEnquiry() async {
    final msg = _messageController.text.trim();
    if (msg.isEmpty) {
      AppSnackBar.showError(
        context,
        title: 'Required',
        message: 'Please enter your enquiry message',
      );
      return;
    }

    final developerId = widget.property.owner.id.isNotEmpty
        ? widget.property.owner.id
        : widget.property.id;

    final success = await ref
        .read(enquiryProvider.notifier)
        .submitEnquiry(
          developerId: developerId,
          message: msg,
        );

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
      AppSnackBar.showSuccess(
        context,
        title: 'Enquiry Sent',
        message: 'Your enquiry has been submitted successfully.',
      );
    } else {
      final error = ref.read(enquiryProvider).errorMessage ??
          'Failed to submit enquiry';
      AppSnackBar.showError(
        context,
        title: 'Enquiry Failed',
        message: error,
      );
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
                  'Send Enquiry',
                  style: text18(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Message
            Text('Message', style: text13(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            TextField(
              controller: _messageController,
              maxLines: 3,
              style: text13(),
              decoration: InputDecoration(
                hintText: 'Enter your message',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.grey200),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 20),

            AppButton(
              title: 'Submit Enquiry',
              isLoading: enquiryState.isLoading,
              onTap: _submitEnquiry,
            ),
          ],
        ),
      ),
    );
  }
}
