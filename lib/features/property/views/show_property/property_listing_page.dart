import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/property/models/response/near_properties_response.dart';
import 'package:gharmb_app/features/property/providers/property_listing_near_by_provider.dart';
import 'package:gharmb_app/routes/app_page.dart';
import 'package:gharmb_app/shared/button/custom_button.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod/legacy.dart';

// local filter chips state (kept simple, no separate provider file needed)
final activeFiltersProvider = StateProvider<List<String>>(
  (_) => ['Ready to move', 'Verified', '2-4 BHK'],
);

class VerifiedListingsPage extends ConsumerWidget {
  const VerifiedListingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nearPropertiesAsync = ref.watch(nearPropertiesProvider);
    final filters = ref.watch(activeFiltersProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── App Bar ────────────────────────────────────────────────
            _AppBar(),
            _VerifiedBadgeBanner(),
            const SizedBox(height: 14),
            _FilterChipsRow(
              filters: filters,
              onRemove: (f) {
                ref
                    .read(activeFiltersProvider.notifier)
                    .update((s) => s.where((e) => e != f).toList());
              },
            ),
            const SizedBox(height: 10),
            // ── White Content ──────────────────────────────────────────
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: RefreshIndicator(
                    onRefresh: () =>
                        ref.read(nearPropertiesProvider.notifier).refresh(),
                    child: nearPropertiesAsync.when(
                      loading: () => const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 60),
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      error: (err, _) => Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            'Failed to load listings: $err',
                            style: text13(color: AppColors.textSecondary),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      data: (response) {
                        final properties = response?.data.properties ?? [];
                        final totalCount = response?.totalCount ?? 0;

                        if (properties.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 60),
                              child: Text(
                                'No properties found nearby.',
                                style: text13(color: AppColors.textSecondary),
                              ),
                            ),
                          );
                        }

                        return CustomScrollView(
                          slivers: [
                            // Count header
                            SliverToBoxAdapter(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 16),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: '$totalCount ',
                                            style: text13(
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'verified homes',
                                            style: text13(
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                ],
                              ),
                            ),

                            // Property cards list
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (ctx, i) => Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    0,
                                    16,
                                    16,
                                  ),
                                  child: _PropertyCard(property: properties[i]),
                                ),
                                childCount: properties.length,
                              ),
                            ),

                            // End marker (no server-side pagination available)
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  0,
                                  16,
                                  32,
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Text(
                                      '✓ All listings loaded',
                                      style: text13(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── App Bar ──────────────────────────────────────────────────────────────────

class _AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          CustomBackButton(),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Verified listings',
                  style: text18(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '1,200+ homes ready to move in',
                  style: text12(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 42), // balance back button
        ],
      ),
    );
  }
}

// ─── NestKey Verified Banner ──────────────────────────────────────────────────

class _VerifiedBadgeBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFEAF7EF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFA8DFB8), width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.verified_user_outlined,
                color: AppColors.success,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'NestKey verified',
                    style: text14(
                      fontWeight: FontWeight.bold,
                      color: AppColors.success,
                    ),
                  ),
                  Text(
                    'Site visited · Docs checked · Owner confirmed',
                    style: text11(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.success, width: 1),
              ),
              child: Text(
                'Trusted',
                style: text11(
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Filter Chips Row ─────────────────────────────────────────────────────────

class _FilterChipsRow extends StatelessWidget {
  final List<String> filters;
  final ValueChanged<String> onRemove;

  const _FilterChipsRow({required this.filters, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.tune, color: AppColors.white, size: 14),
                const SizedBox(width: 6),
                Text(
                  'Filters',
                  style: text13(
                    color: AppColors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ...filters.map(
            (f) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.grey300),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(f, style: text13(color: AppColors.textPrimary)),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () => onRemove(f),
                      child: const Icon(
                        Icons.close,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Property Card ────────────────────────────────────────────────────────────

class _PropertyCard extends StatelessWidget {
  final Property property;

  const _PropertyCard({required this.property});

  @override
  Widget build(BuildContext context) {
    final isRent = property.listingFor.toLowerCase().contains('rent');
    final tagLabel = isRent ? 'For Rent' : 'For Sale';
    final tagBg = isRent ? AppColors.success : AppColors.blue;
    final priceSuffix = isRent ? '/month' : '';

    final area = property.carpetArea > 0
        ? property.carpetArea
        : property.builtUpArea;

    final restrictions = <String>[
      property.preferredTenants.isNotEmpty
          ? property.preferredTenants.join(', ')
          : 'Any',
      property.petsAllowed ? 'Pets OK' : 'No Pets',
      property.smokingAllowed ? 'Smoking OK' : 'No Smoking',
    ];
    final restrictionIcons = <String>[
      property.preferredTenants.isNotEmpty ? '👨‍👩‍👧' : '✅',
      property.petsAllowed ? '🐾' : '🚫',
      property.smokingAllowed ? '🚬' : '🥦',
    ];

    return GestureDetector(
      onTap: () {
        context.pushNamed(AppPage.propertyDetailsName);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image / Hero ─────────────────────────────────────────
            Stack(
              children: [
                Container(
                  height: 190,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    gradient: LinearGradient(
                      colors: _gradientForIndex(property.id),
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(14),
                    ),
                    child: property.images.isNotEmpty
                        ? Image.network(
                            property.images.first,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (ctx, err, stack) => Image.asset(
                              "assets/builder.png",
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          )
                        : Image.asset(
                            "assets/builder.png",
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                  ),
                ),
                // Tag chip
                Positioned(
                  top: 14,
                  left: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: tagBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      tagLabel,
                      style: text12(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                // Wishlist
                Positioned(
                  bottom: 12,
                  right: 14,
                  child: Container(
                    padding: const EdgeInsets.all(6),
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
                      Icons.favorite_border,
                      color: AppColors.textSecondary,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),

            // ── Body ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + type
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          property.title,
                          style: text18(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${property.bedrooms} BHK ${property.propertyType}',
                            style: text12(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            property.locality,
                            style: text11(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Location
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 13,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          '${property.locality}, ${property.city}',
                          style: text12(color: AppColors.textSecondary),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Price
                  Row(
                    children: [
                      Text(
                        '₹${property.price}',
                        style: text20(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        priceSuffix,
                        style: text13(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Area · Furnishing · Baths · Parking
                  Wrap(
                    spacing: 14,
                    runSpacing: 4,
                    children: [
                      _MetaItem(
                        icon: Icons.crop_square_rounded,
                        label: '$area sqft',
                      ),
                      _MetaItem(
                        icon: Icons.chair_outlined,
                        label: property.furnishing,
                      ),
                      _MetaItem(
                        icon: Icons.bathtub_outlined,
                        label: '${property.bathrooms} Bathroom(s)',
                      ),
                      _MetaItem(
                        icon: Icons.local_parking_outlined,
                        label: property.parking,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Divider(height: 1, color: AppColors.grey100),
                  const SizedBox(height: 14),

                  // Restrictions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(
                      restrictions.length,
                      (i) => _RestrictionItem(
                        emoji: restrictionIcons[i],
                        label: restrictions[i],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: _ActionBtn(
                          label: 'Whatsapp',
                          icon: Icons.chat_outlined,
                          bgColor: const Color(0xFF25D366),
                          textColor: AppColors.white,
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _ActionBtn(
                          label: 'Contact',
                          icon: Icons.phone_outlined,
                          bgColor: AppColors.primary,
                          textColor: AppColors.white,
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _ActionBtn(
                          label: 'Book with token',
                          bgColor: AppColors.white,
                          textColor: AppColors.primary,
                          borderColor: AppColors.primary,
                          onTap: () {
                            context.pushNamed(AppPage.bookByTokenName);
                          },
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

  List<Color> _gradientForIndex(String id) {
    final idx = id.hashCode % 6;
    const gradients = [
      [Color(0xFF1A3A5C), Color(0xFF2D6A9F)],
      [Color(0xFF1B4332), Color(0xFF40916C)],
      [Color(0xFF4A1942), Color(0xFF9B2335)],
      [Color(0xFF1A1A4E), Color(0xFF3D3DAA)],
      [Color(0xFF3B2F00), Color(0xFF8B6914)],
      [Color(0xFF002B36), Color(0xFF004D5E)],
    ];
    return gradients[idx.abs()].map((c) => c).toList();
  }
}

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MetaItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(label, style: text11(color: AppColors.textSecondary)),
      ],
    );
  }
}

class _RestrictionItem extends StatelessWidget {
  final String emoji;
  final String label;
  const _RestrictionItem({required this.emoji, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.grey100,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(emoji, style: const TextStyle(fontSize: 22)),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: text10(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color bgColor;
  final Color textColor;
  final Color? borderColor;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.label,
    this.icon,
    required this.bgColor,
    required this.textColor,
    this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          border: borderColor != null
              ? Border.all(color: borderColor!, width: 1.2)
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: textColor),
              const SizedBox(width: 4),
            ],
            Flexible(
              child: Text(
                label,
                style: text11(color: textColor, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
