import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/features/commercial/providers/commercial_provider.dart';
import 'package:gharmb_app/features/commercial/widget/commercial_appbar.dart';
import 'package:gharmb_app/routes/app_page.dart';
import 'package:go_router/go_router.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';

class CommercialListingsPage extends ConsumerWidget {
  const CommercialListingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listings = ref.watch(commercialListingsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // ── App Bar ──────────────────────────────────────────────
            Container(
              color: AppColors.white,
              child: CommercialAppBar(
                title: 'Commercial listings',
                subtitle: '86 verified spaces',
              ),
            ),

            // ── List ─────────────────────────────────────────────────
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                itemCount: listings.length,
                separatorBuilder: (_, _) => const SizedBox(height: 14),
                itemBuilder: (_, i) => _ListingCard(
                  listing: listings[i],
                  onViewDetails: () {
                    ref.read(selectedListingProvider.notifier).state =
                        listings[i];
                    context.pushNamed(AppPage.commercialPropertyDetailName);
                  },
                  onEnquire: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Listing Card ─────────────────────────────────────────────────────────────

class _ListingCard extends StatelessWidget {
  final CommercialListing listing;
  final VoidCallback onViewDetails;
  final VoidCallback onEnquire;

  const _ListingCard({
    required this.listing,
    required this.onViewDetails,
    required this.onEnquire,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Container(
              height: 190,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: _gradient(listing.imageGradientKey),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.storefront_outlined,
                      size: 72,
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                  // Tag
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: listing.tag == 'For Sale'
                            ? AppColors.primary
                            : AppColors.success,
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
                ],
              ),
            ),
          ),

          // ── Details ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Price
                Text(listing.price, style: text20(fontWeight: FontWeight.bold)),
                const SizedBox(height: 3),
                Text(
                  listing.pricePerSqft,
                  style: text12(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 8),

                // Type · Floor · Area
                Text(
                  '${listing.type} · ${listing.floor} · ${listing.area}',
                  style: text13(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 4),

                // Location
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 13,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      listing.location,
                      style: text12(color: AppColors.textSecondary),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      width: 3,
                      height: 3,
                      decoration: const BoxDecoration(
                        color: AppColors.grey400,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      listing.market,
                      style: text12(color: AppColors.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onViewDetails,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 13),
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
                          padding: const EdgeInsets.symmetric(vertical: 13),
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
    );
  }

  LinearGradient _gradient(String key) => switch (key) {
    'warm2' => const LinearGradient(
      colors: [Color(0xFF2A1A0A), Color(0xFF5A3A1A)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    _ => const LinearGradient(
      colors: [Color(0xFF3A2510), Color(0xFF7A5028)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  };
}
