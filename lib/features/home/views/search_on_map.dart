import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:gharmb_app/routes/app_page.dart';
import 'package:gharmb_app/shared/button/custom_button.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:go_router/go_router.dart';

// ─── Models ───────────────────────────────────────────────────────────────────

class MapPinModel {
  final String price;
  final String bhk;
  final double top;
  final double left;
  final bool isHighlighted;

  const MapPinModel({
    required this.price,
    required this.bhk,
    required this.top,
    required this.left,
    this.isHighlighted = false,
  });
}

class MapPropertyCard {
  final String title;
  final String location;
  final String price;
  final int beds;
  final int baths;
  final int parking;
  final bool isVerified;

  const MapPropertyCard({
    required this.title,
    required this.location,
    required this.price,
    required this.beds,
    required this.baths,
    required this.parking,
    required this.isVerified,
  });
}

// ─── Providers ────────────────────────────────────────────────────────────────

final _selectedCategoryProvider = StateProvider<String>((_) => 'All');

const _pins = [
  MapPinModel(price: '₹1.9 Cr', bhk: '2 bhk', top: 0.10, left: 0.05),
  MapPinModel(price: '₹1.50 Cr', bhk: '2 bhk', top: 0.06, left: 0.58),
  MapPinModel(
    price: '₹89 L – ₹2.5 Cr',
    bhk: '50+ Properties',
    top: 0.22,
    left: 0.28,
    isHighlighted: true,
  ),
  MapPinModel(price: '₹89 L', bhk: '2 bhk', top: 0.40, left: 0.04),
  MapPinModel(price: '₹5 Cr', bhk: '2 bhk', top: 0.36, left: 0.72),
  MapPinModel(price: '₹1.50 Cr', bhk: '2 bhk', top: 0.58, left: 0.05),
  MapPinModel(price: '₹1.50 Cr', bhk: '2 bhk', top: 0.58, left: 0.58),
];

const _numberBubbles = [
  _NumberBubble(count: 12, top: 0.33, left: 0.42),
  _NumberBubble(count: 8, top: 0.68, left: 0.30),
  _NumberBubble(count: 5, top: 0.70, left: 0.68),
];

const _categories = [
  _CategoryItem(icon: Icons.apps, label: 'All'),
  _CategoryItem(icon: Icons.home_outlined, label: 'Buy'),
  _CategoryItem(icon: Icons.vpn_key_outlined, label: 'Rent'),
  _CategoryItem(icon: Icons.domain_outlined, label: 'New\nProjects'),
  _CategoryItem(icon: Icons.business_center_outlined, label: 'Commercial'),
  _CategoryItem(icon: Icons.terrain_outlined, label: 'Plot/Land'),
];

const _recommendedProperties = [
  MapPropertyCard(
    title: '2 BHK Apartment',
    location: 'Mira Road East',
    price: '₹82 Lakh',
    beds: 2,
    baths: 2,
    parking: 1,
    isVerified: true,
  ),
  MapPropertyCard(
    title: '2 BHK Apartment',
    location: 'Mira Road East',
    price: '₹82 Lakh',
    beds: 2,
    baths: 2,
    parking: 1,
    isVerified: true,
  ),
  MapPropertyCard(
    title: '2 BHK Apartment',
    location: 'Mira Road East',
    price: '₹82 Lakh',
    beds: 2,
    baths: 2,
    parking: 1,
    isVerified: true,
  ),
];

class SearchOnMapPage extends ConsumerWidget {
  const SearchOnMapPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCat = ref.watch(_selectedCategoryProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            _AppBar(),
            Expanded(flex: 5, child: _MapArea()),
            _CategoryRow(
              selected: selectedCat,
              onSelect: (c) =>
                  ref.read(_selectedCategoryProvider.notifier).state = c,
            ),
            _RecommendedSection(),
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
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
      child: Row(
        children: [
          // Back button — orange bg with arrow
          CustomBackButton(),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Search on Map',
              style: text18(fontWeight: FontWeight.bold),
            ),
          ),
          // Notification bell with badge
          // Stack(
          //   clipBehavior: Clip.none,
          //   children: [
          //     Container(
          //       padding: const EdgeInsets.all(8),
          //       decoration: BoxDecoration(
          //         color: AppColors.grey100,
          //         borderRadius: BorderRadius.circular(10),
          //       ),
          //       child: const Icon(
          //         Icons.notifications_outlined,
          //         color: AppColors.textPrimary,
          //         size: 22,
          //       ),
          //     ),
          //     Positioned(
          //       top: -2,
          //       right: -2,
          //       child: Container(
          //         width: 16,
          //         height: 16,
          //         decoration: const BoxDecoration(
          //           color: AppColors.primary,
          //           shape: BoxShape.circle,
          //         ),
          //         child: const Center(
          //           child: Text(
          //             '2',
          //             style: TextStyle(
          //               color: Colors.white,
          //               fontSize: 9,
          //               fontWeight: FontWeight.bold,
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}

// ─── Map Area ─────────────────────────────────────────────────────────────────

class _MapArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        return Stack(
          children: [
            // ── Map placeholder (replace with actual map widget later) ──
            Container(
              width: double.infinity,
              height: double.infinity,
              color: const Color(0xFFE8EAF0),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.map_outlined,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Map View',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Price pins ──
            ..._pins.map(
              (pin) => Positioned(
                top: pin.top * h,
                left: pin.left * w,
                child: _PricePin(pin: pin),
              ),
            ),

            // ── Number bubbles ──
            ..._numberBubbles.map(
              (b) => Positioned(
                top: b.top * h,
                left: b.left * w,
                child: _NumberBubbleWidget(bubble: b),
              ),
            ),

            // ── Bottom control buttons ──
            Positioned(
              bottom: 12,
              left: 12,
              child: _MapControlBtn(
                icon: Icons.edit_outlined,
                label: 'Draw on Map',
              ),
            ),
            Positioned(
              bottom: 12,
              right: 12,
              child: _MapControlBtn(
                icon: Icons.my_location,
                label: 'My location',
              ),
            ),
          ],
        );
      },
    );
  }
}

// ─── Price Pin ────────────────────────────────────────────────────────────────

class _PricePin extends StatelessWidget {
  final MapPinModel pin;
  const _PricePin({required this.pin});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: pin.isHighlighted ? AppColors.primary : AppColors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  pin.price,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: pin.isHighlighted
                        ? AppColors.white
                        : AppColors.textPrimary,
                  ),
                ),
                Text(
                  pin.bhk,
                  style: TextStyle(
                    fontSize: 9,
                    color: pin.isHighlighted
                        ? Colors.white.withOpacity(0.85)
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          CustomPaint(
            size: const Size(10, 5),
            painter: _PinTrianglePainter(
              color: pin.isHighlighted ? AppColors.primary : AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Number Bubble ────────────────────────────────────────────────────────────

class _NumberBubble {
  final int count;
  final double top;
  final double left;
  const _NumberBubble({
    required this.count,
    required this.top,
    required this.left,
  });
}

class _NumberBubbleWidget extends StatelessWidget {
  final _NumberBubble bubble;
  const _NumberBubbleWidget({required this.bubble});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          '${bubble.count}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// ─── Map Control Button ───────────────────────────────────────────────────────

class _MapControlBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MapControlBtn({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 5),
          Text(
            label,
            style: text12(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Category Row ─────────────────────────────────────────────────────────────

class _CategoryItem {
  final IconData icon;
  final String label;
  const _CategoryItem({required this.icon, required this.label});
}

class _CategoryRow extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelect;
  const _CategoryRow({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _categories.map((cat) {
          final sel =
              cat.label.replaceAll('\n', ' ').trim() ==
              selected.replaceAll('\n', ' ').trim();
          return GestureDetector(
            onTap: () => onSelect(cat.label.replaceAll('\n', ' ').trim()),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: sel ? AppColors.primary : AppColors.grey100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    cat.icon,
                    size: 22,
                    color: sel ? AppColors.white : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  cat.label,
                  style: text10(
                    color: sel ? AppColors.primary : AppColors.textSecondary,
                    fontWeight: sel ? FontWeight.w600 : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── Recommended Section ──────────────────────────────────────────────────────

class _RecommendedSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recommended for you',
                style: text14(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'View All',
                  style: text13(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 170,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _recommendedProperties.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (_, i) =>
                  _RecommendedCard(property: _recommendedProperties[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendedCard extends StatelessWidget {
  final MapPropertyCard property;
  const _RecommendedCard({required this.property});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(AppPage.propertyDetailsName);
      },
      child: Container(
        width: 155,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: AppColors.card,
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image placeholder ──
            Stack(
              children: [
                Container(
                  height: 82,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1B3A5C), Color(0xFF2D6A9F)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.apartment_rounded,
                      size: 44,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                // Verified badge
                if (property.isVerified)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text(
                        'Verified',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                // Favourite icon
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white24,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                      size: 13,
                    ),
                  ),
                ),
              ],
            ),

            // ── Details ──
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.title,
                    style: text12(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    property.location,
                    style: text10(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    property.price,
                    style: text12(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      _MiniStat(
                        icon: Icons.bed_outlined,
                        value: '${property.beds}',
                      ),
                      const SizedBox(width: 8),
                      _MiniStat(
                        icon: Icons.bathtub_outlined,
                        value: '${property.baths}',
                      ),
                      const SizedBox(width: 8),
                      _MiniStat(
                        icon: Icons.local_parking_outlined,
                        value: '${property.parking}',
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

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String value;
  const _MiniStat({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 11, color: AppColors.textPrimary),
        const SizedBox(width: 2),
        Text(
          value,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 10),
        ),
      ],
    );
  }
}

// ─── Pin Triangle ─────────────────────────────────────────────────────────────

class _PinTrianglePainter extends CustomPainter {
  final Color color;
  const _PinTrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}
