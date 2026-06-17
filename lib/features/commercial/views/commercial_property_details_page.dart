import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/features/commercial/providers/commercial_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';

class CommercialPropertyDetailsPage extends ConsumerWidget {
  const CommercialPropertyDetailsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listing = ref.watch(selectedListingProvider) ?? _defaultListing;
    final highlights = ref.watch(shopHighlightsProvider);
    final landmarks = ref.watch(landmarksProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // ── Hero SliverAppBar ──────────────────────────────────
              SliverAppBar(
                expandedHeight: 220,
                pinned: true,
                backgroundColor: const Color(0xFF3A2510),
                leading: GestureDetector(
                  onTap: () => context.pop(),
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
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Gradient hero
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF3A2510), Color(0xFF7A5028)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.storefront_outlined,
                            size: 80,
                            color: Colors.white.withOpacity(0.1),
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
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            listing.tag,
                            style: text11(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
                                '${listing.photos} Photos',
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

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Price + Type ─────────────────────────────────
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              listing.price,
                              style: text24(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '${listing.pricePerSqft} · ${listing.area} carpet',
                              style: text12(color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${listing.type} · ${listing.floor} · Sector 18 Market',
                              style: text14(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                      _Divider2(),

                      // ── Why this shop stands out ─────────────────────
                      _SectionTitle('Why this shop stands out'),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: highlights
                              .map((h) => _HighlightRow(text: h))
                              .toList(),
                        ),
                      ),

                      const SizedBox(height: 8),
                      _Divider2(),

                      // ── Nearby Landmarks ─────────────────────────────
                      _SectionTitle('Nearby landmarks'),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: landmarks
                              .map((l) => _LandmarkCard(landmark: l))
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ── Bottom Actions ─────────────────────────────────────────
          Positioned(bottom: 0, left: 0, right: 0, child: _BottomActions()),
        ],
      ),
    );
  }
}

// ─── Section Title ────────────────────────────────────────────────────────────

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

// ─── Highlight Row ────────────────────────────────────────────────────────────

class _HighlightRow extends StatelessWidget {
  final String text;
  const _HighlightRow({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 4),
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: text13(
                color: AppColors.textSecondary,
              ).copyWith(height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Landmark Card ────────────────────────────────────────────────────────────

class _LandmarkCard extends StatelessWidget {
  final LandmarkModel landmark;
  const _LandmarkCard({required this.landmark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1EB),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Text(landmark.name, style: text14(fontWeight: FontWeight.w500)),
          const Spacer(),
          Text(
            landmark.distance,
            style: text13(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Bottom Actions ───────────────────────────────────────────────────────────

class _BottomActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
              onPressed: () {},
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
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: AppColors.primary, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Book Site Visit',
                style: text14(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Default listing fallback ─────────────────────────────────────────────────

const _defaultListing = CommercialListing(
  id: 'default',
  price: '₹48 Lakhs',
  pricePerSqft: '₹9,600/sqft',
  type: 'Retail shop',
  floor: 'Ground floor',
  area: '500 sqft',
  location: '9 Sector 18, Noida',
  market: 'Main market',
  imageGradientKey: 'warm',
  tag: 'For Sale',
  photos: 12,
);
