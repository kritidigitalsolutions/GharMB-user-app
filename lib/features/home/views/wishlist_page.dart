import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/wishlist/models/wishlist_response_model.dart';
import 'package:gharmb_app/features/wishlist/providers/wishlist_provider.dart';
import 'package:gharmb_app/routes/app_page.dart';
import 'package:gharmb_app/shared/button/custom_button.dart';
import 'package:gharmb_app/shared/widget/custom_shimmer.dart';
import 'package:go_router/go_router.dart';

class WishlistPage extends ConsumerWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistState = ref.watch(wishlistProvider);
    final items = wishlistState.items;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'My Wishlist',
                      style: text18(fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (items.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${items.length} Saved',
                        style: text11(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Content ───────────────────────────────────────
            Expanded(
              child: RefreshIndicator(
                onRefresh: () =>
                    ref.read(wishlistProvider.notifier).fetchWishlist(),
                color: AppColors.primary,
                child: wishlistState.isLoading && items.isEmpty
                    ? const PropertyListShimmer(itemCount: 4)
                    : items.isEmpty
                        ? SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.6,
                              child: _EmptyState(),
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                            itemCount: items.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 14),
                            itemBuilder: (context, i) {
                              final item = items[i];
                              return _WishlistCard(
                                item: item,
                                onRemove: () async {
                                  final success = await ref
                                      .read(wishlistProvider.notifier)
                                      .removeWishlist(item.id);
                                  if (context.mounted && success) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Item removed from wishlist',
                                        ),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                },
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

// ─── Wishlist Card ─────────────────────────────────────────────
class _WishlistCard extends StatelessWidget {
  final WishlistItem item;
  final VoidCallback onRemove;

  const _WishlistCard({required this.item, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final property = item.property;
    final title = property?.title ?? 'Property';
    final price = property?.formattedPrice ?? '';
    final location = property?.formattedLocation ?? '';
    final imageUrl =
        property != null && property.images.isNotEmpty ? property.images.first : '';
    final isVerified = property?.isVerified ?? false;
    final bedrooms = property?.bedrooms ?? '';
    final area = property?.carpetArea ?? 0;

    return GestureDetector(
      onTap: () {
        if (property != null && property.id.isNotEmpty) {
          context.pushNamed(AppPage.propertyDetailsName, extra: property.id);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.grey200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image ──────────────────────────────────────────
            Stack(
              children: [
                Container(
                  height: 150,
                  width: double.infinity,
                  color: AppColors.grey200,
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => const Center(
                            child: Icon(
                              Icons.apartment_outlined,
                              color: AppColors.grey400,
                              size: 48,
                            ),
                          ),
                        )
                      : const Center(
                          child: Icon(
                            Icons.apartment_outlined,
                            color: AppColors.grey400,
                            size: 48,
                          ),
                        ),
                ),
                // Verified badge
                if (isVerified)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.verified_rounded,
                            color: AppColors.white,
                            size: 11,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            'Verified',
                            style: text10(
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                // Remove (heart) button
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: onRemove,
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.favorite_rounded,
                        color: AppColors.primary,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ── Details ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: text15(fontWeight: FontWeight.w700),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (price.isNotEmpty)
                        Text(
                          price,
                          style: text14(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                    ],
                  ),
                  if (location.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 13,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            location,
                            style: text12(color: AppColors.textSecondary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 10),
                  // Tags
                  Row(
                    children: [
                      if (bedrooms.isNotEmpty) ...[
                        _Tag(
                          label: bedrooms.contains('BHK')
                              ? bedrooms
                              : '$bedrooms BHK',
                          icon: Icons.bed_outlined,
                        ),
                        const SizedBox(width: 8),
                      ],
                      if (area > 0)
                        _Tag(
                          label: '$area sq ft',
                          icon: Icons.square_foot_outlined,
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // View Details button
                  AppButton(
                    title: "View Details",
                    onTap: () {
                      if (property != null && property.id.isNotEmpty) {
                        context.pushNamed(
                          AppPage.propertyDetailsName,
                          extra: property.id,
                        );
                      }
                    },
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

// ─── Tag Chip ──────────────────────────────────────────────────
class _Tag extends StatelessWidget {
  final String label;
  final IconData icon;
  const _Tag({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(
            label,
            style: text11(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Empty State ───────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite_border_rounded,
              size: 48,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No saved properties',
            style: text16(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            'Properties you save will appear here',
            style: text13(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.of(context).maybePop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 13),
              elevation: 0,
            ),
            child: Text(
              'Explore Properties',
              style: text14(
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
