import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';

import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/profile/models/models.dart';
import 'package:gharmb_app/features/profile/provider/my_property_provider.dart';
import 'package:gharmb_app/shared/button/custom_button.dart';
import 'package:gharmb_app/shared/widget/custom_widget.dart';

class MyPropertyDetailsPage extends ConsumerWidget {
  const MyPropertyDetailsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listing = ref.watch(listingDetailProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DetailHeader(title: listing.title),
              const SizedBox(height: 16),
              _PropertyCard(listing: listing),
              const SizedBox(height: 24),
              Text(
                'Listing Status Timeline',
                style: text15(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              _Timeline(events: listing.timeline),
              const SizedBox(height: 24),
              _ActionButtons(),
              const SizedBox(height: 16),
              HelpRow(),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Header ────────────────────────────────────────────────────
class _DetailHeader extends StatelessWidget {
  final String title;
  const _DetailHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomBackButton(),
        const SizedBox(width: 12),
        Text(title, style: text18(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

// ─── Property Card ─────────────────────────────────────────────
class _PropertyCard extends StatelessWidget {
  final ListingDetail listing;
  const _PropertyCard({required this.listing});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.grey200),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Property image
          Stack(
            children: [
              Image.network(
                listing.imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  height: 180,
                  color: AppColors.grey200,
                  child: const Center(
                    child: Icon(
                      Icons.apartment_outlined,
                      color: AppColors.grey400,
                      size: 48,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Live',
                    style: text11(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${listing.title}  •  ',
                      style: text14(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      listing.area,
                      style: text14(color: AppColors.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
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
                        listing.location,
                        style: text12(color: AppColors.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Listing ID: ${listing.id}',
                  style: text11(color: AppColors.grey400),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Timeline ─────────────────────────────────────────────────
class _Timeline extends StatelessWidget {
  final List<TimelineEvent> events;
  const _Timeline({required this.events});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(events.length, (i) {
        final event = events[i];
        final isLast = i == events.length - 1;
        return _TimelineItem(event: event, isLast: isLast);
      }),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final TimelineEvent event;
  final bool isLast;
  const _TimelineItem({required this.event, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final color = event.completed ? AppColors.success : AppColors.grey300;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dot + line
          Column(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 2),
                ),
                child: const Icon(
                  Icons.check,
                  color: AppColors.white,
                  size: 11,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: AppColors.success.withOpacity(0.3),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        event.title,
                        style: text13(
                          fontWeight: FontWeight.w600,
                          color: event.completed
                              ? AppColors.textPrimary
                              : AppColors.grey400,
                        ),
                      ),
                      Text(event.date, style: text10(color: AppColors.grey400)),
                    ],
                  ),
                  if (event.subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      event.subtitle!,
                      style: text11(color: AppColors.textSecondary),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Action Buttons ────────────────────────────────────────────
class _ActionButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: Text(
              'Edit Listing',
              style: text14(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
              elevation: 0,
            ),
            child: Text(
              'Share Listing',
              style: text14(
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
