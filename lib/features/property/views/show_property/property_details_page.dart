import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/property/providers/provider_details_provider.dart';
import 'package:gharmb_app/routes/app_page.dart';
import 'package:go_router/go_router.dart';

class PropertyDetailPage extends ConsumerWidget {
  const PropertyDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final property = ref.watch(propertyDetailProvider);
    final isWishlisted = ref.watch(isWishlistedProvider);
    final isExpanded = ref.watch(isExpandedProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // ── Hero Image Sliver ──────────────────────────────────
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                backgroundColor: AppColors.primary,
                leading: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black26,
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
                    onTap: () => ref
                        .read(isWishlistedProvider.notifier)
                        .update((s) => !s),
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        isWishlisted ? Icons.favorite : Icons.favorite_border,
                        color: isWishlisted ? AppColors.error : AppColors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.share_outlined,
                      color: AppColors.white,
                      size: 20,
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Gradient background as placeholder
                      Container(
                        decoration: const BoxDecoration(),
                        child: Image.asset(
                          "assets/builder.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Bottom badges row
                      Positioned(
                        bottom: 12,
                        left: 12,
                        child: Row(
                          children: [
                            _Badge(label: '✓ Verified', bg: AppColors.success),
                            const SizedBox(width: 6),
                            if (property.isHot)
                              _Badge(label: '🔥 Hot', bg: AppColors.error),
                          ],
                        ),
                      ),
                      // Photos count
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black45,
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
                                '${property.photos} Photos',
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

              // ── Body Content ──────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Price + Type ───────────────────────────────
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        property.price,
                                        style: text24(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        property.priceSuffix,
                                        style: text12(
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on_outlined,
                                        size: 13,
                                        color: AppColors.textSecondary,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        property.location,
                                        style: text12(
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.primary.withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                property.type,
                                style: text12(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ── Stat Row ───────────────────────────────────
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _StatItem(
                              value: property.area,
                              unit: 'sq.ft',
                              icon: Icons.crop_square_rounded,
                            ),
                            _Divider(),
                            _StatItem(
                              value: '${property.bedrooms}',
                              unit: 'Bedrooms',
                              icon: Icons.bed_outlined,
                            ),
                            _Divider(),
                            _StatItem(
                              value: '${property.bathrooms}',
                              unit: 'Bathrooms',
                              icon: Icons.bathtub_outlined,
                            ),
                            _Divider(),
                            _StatItem(
                              value: property.parking,
                              unit: 'Parking',
                              icon: Icons.local_parking_outlined,
                            ),
                            _Divider(),
                            _StatItem(
                              value: property.floor,
                              unit: 'on floor',
                              icon: Icons.layers_outlined,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 22),
                      const _Divider2(),

                      // ── Property Highlights ────────────────────────
                      _SectionTitle('Property Highlights'),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: property.highlights
                              .map((h) => _HighlightTile(item: h))
                              .toList(),
                        ),
                      ),

                      const SizedBox(height: 22),
                      const _Divider2(),

                      // ── About ──────────────────────────────────────
                      _SectionTitle('About Property'),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              property.aboutText,
                              style: text13(
                                color: AppColors.textSecondary,
                              ).copyWith(height: 1.6),
                              maxLines: isExpanded ? null : 3,
                              overflow: isExpanded
                                  ? TextOverflow.visible
                                  : TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            GestureDetector(
                              onTap: () => ref
                                  .read(isExpandedProvider.notifier)
                                  .update((s) => !s),
                              child: Text(
                                isExpanded ? 'Read less' : 'Read more',
                                style: text13(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 22),
                      const _Divider2(),

                      // ── Amenities ──────────────────────────────────
                      _SectionTitle('Amenities'),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: property.amenities
                              .map((a) => _AmenityTile(item: a))
                              .toList(),
                        ),
                      ),

                      const SizedBox(height: 22),
                      const _Divider2(),

                      // ── Property Details ───────────────────────────
                      _SectionTitle('Property Details'),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _PropertyDetailsGrid(
                          details: property.propertyDetails,
                        ),
                      ),

                      const SizedBox(height: 22),
                      const _Divider2(),

                      // ── Location & Nearby ──────────────────────────
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Location & Nearby',
                              style: text16(fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Text(
                                'View on Map',
                                style: text12(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Mini map placeholder
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F0FE),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.grey200),
                              ),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(11),
                                    child: Container(
                                      color: const Color(0xFFD1E3FF),
                                    ),
                                  ),
                                  Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          color: AppColors.primary,
                                          size: 28,
                                        ),
                                        Text(
                                          'Sector 62,\nNoida',
                                          style: text10(
                                            color: AppColors.textPrimary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Nearby list
                            Expanded(
                              child: Column(
                                children: property.nearbyPlaces
                                    .map((n) => _NearbyRow(item: n))
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 22),
                      const _Divider2(),

                      // ── Verified Banner ────────────────────────────
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAF7EF),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.success),
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
                                      'Verified Property',
                                      style: text13(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.success,
                                      ),
                                    ),
                                    Text(
                                      'This property has been verified by our team',
                                      style: text11(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ── Bottom Action Bar ──────────────────────────────────────
          Positioned(bottom: 0, left: 0, right: 0, child: _BottomActions()),
        ],
      ),
    );
  }
}

// ─── Widgets ──────────────────────────────────────────────────────────────────

class _Badge extends StatelessWidget {
  final String label;
  final Color bg;
  const _Badge({required this.label, required this.bg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        label,
        style: text10(color: AppColors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String unit;
  final IconData icon;
  const _StatItem({
    required this.value,
    required this.unit,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(height: 4),
        Text(value, style: text13(fontWeight: FontWeight.bold)),
        Text(unit, style: text10(color: AppColors.textSecondary)),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 36, color: AppColors.grey200);
  }
}

class _Divider2 extends StatelessWidget {
  const _Divider2();
  @override
  Widget build(BuildContext context) {
    return Container(height: 8, color: AppColors.grey50);
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
      child: Text(title, style: text16(fontWeight: FontWeight.bold)),
    );
  }
}

class _HighlightTile extends StatelessWidget {
  final HighlightItem item;
  const _HighlightTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Icon(item.icon, color: AppColors.grey600, size: 24),
        ),
        const SizedBox(height: 6),
        Text(
          item.label,
          style: text10(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _AmenityTile extends StatelessWidget {
  final AmenityItem item;
  const _AmenityTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Icon(item.icon, color: AppColors.textSecondary, size: 24),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 58,
          child: Text(
            item.label,
            style: text10(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}

class _PropertyDetailsGrid extends StatelessWidget {
  final Map<String, String> details;
  const _PropertyDetailsGrid({required this.details});

  @override
  Widget build(BuildContext context) {
    final entries = details.entries.toList();
    return Column(
      children: List.generate((entries.length / 2).ceil(), (row) {
        final left = entries[row * 2];
        final right = row * 2 + 1 < entries.length
            ? entries[row * 2 + 1]
            : null;
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Row(
            children: [
              Expanded(
                child: _DetailCell(k: left.key, v: left.value),
              ),
              if (right != null)
                Expanded(
                  child: _DetailCell(k: right.key, v: right.value),
                ),
            ],
          ),
        );
      }),
    );
  }
}

class _DetailCell extends StatelessWidget {
  final String k;
  final String v;
  const _DetailCell({required this.k, required this.v});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(k, style: text12(color: AppColors.textSecondary)),
        const SizedBox(height: 3),
        Text(v, style: text13(fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _NearbyRow extends StatelessWidget {
  final NearbyItem item;
  const _NearbyRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              item.place,
              style: text12(color: AppColors.textSecondary),
            ),
          ),
          Text(item.distance, style: text12(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ─── Bottom Action Bar ────────────────────────────────────────────────────────

class _BottomActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        12,
        10,
        12,
        MediaQuery.of(context).padding.bottom + 10,
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
          // Whatsapp
          Expanded(
            child: _BottomBtn(
              label: 'Whatsapp',
              icon: Icons.chat_outlined,
              bgColor: const Color(0xFF25D366),
              textColor: AppColors.white,
              onTap: () {},
            ),
          ),
          const SizedBox(width: 8),
          // Contact
          Expanded(
            child: _BottomBtn(
              label: 'Contact',
              icon: Icons.phone_outlined,
              bgColor: AppColors.primary,
              textColor: AppColors.white,
              onTap: () {},
            ),
          ),
          const SizedBox(width: 8),
          // Schedule Visit
          Expanded(
            child: _BottomBtn(
              label: 'Schedule\nVisit',
              icon: Icons.calendar_today_outlined,
              bgColor: AppColors.white,
              textColor: AppColors.textPrimary,
              borderColor: AppColors.grey300,
              onTap: () {},
            ),
          ),
          const SizedBox(width: 8),
          // Book with token
          Expanded(
            child: _BottomBtn(
              label: 'Book with\ntoken',
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
    );
  }
}

class _BottomBtn extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color bgColor;
  final Color textColor;
  final Color? borderColor;
  final VoidCallback onTap;

  const _BottomBtn({
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
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          border: borderColor != null
              ? Border.all(color: borderColor!, width: 1.2)
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: textColor),
              const SizedBox(height: 3),
            ],
            Text(
              label,
              style: text10(color: textColor, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
