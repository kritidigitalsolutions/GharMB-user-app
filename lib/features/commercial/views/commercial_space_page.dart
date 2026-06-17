import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/features/commercial/providers/commercial_provider.dart';
import 'package:gharmb_app/features/commercial/widget/commercial_appbar.dart';
import 'package:gharmb_app/routes/app_page.dart';
import 'package:gharmb_app/shared/button/custom_button.dart';
import 'package:go_router/go_router.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';

class CommercialSpacesPage extends ConsumerWidget {
  const CommercialSpacesPage({super.key});

  // Category data: label + icon + gradient key + isSelected logic
  static const _categories = [
    _CatData(label: 'Shop', cat: CommercialCategory.shop, gradientKey: 'shop'),
    _CatData(
      label: 'Office space',
      cat: CommercialCategory.officeSpace,
      gradientKey: 'office',
    ),
    _CatData(
      label: 'Showroom',
      cat: CommercialCategory.showroom,
      gradientKey: 'showroom',
    ),
    _CatData(
      label: 'Warehouse',
      cat: CommercialCategory.warehouse,
      gradientKey: 'warehouse',
    ),
    _CatData(
      label: 'Co-working',
      cat: CommercialCategory.coWorking,
      gradientKey: 'cowork',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(commercialProvider);
    final notifier = ref.read(commercialProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── App Bar ──────────────────────────────────────────────
            CommercialAppBar(
              title: 'Commercial spaces',
              subtitle: 'Buy or rent · admin verified',
            ),

            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16),
                children: [
                  // ── Buy / Rent Toggle ──────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: _ModeCard(
                          image: "assets/com/house.png",
                          label: 'Buy',
                          sublabel: 'Own the space',
                          isSelected: state.mode == CommercialMode.buy,
                          onTap: () => notifier.setMode(CommercialMode.buy),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ModeCard(
                          image: "assets/com/deal.png",
                          label: 'Rent',
                          sublabel: 'Monthly lease',
                          isSelected: state.mode == CommercialMode.rent,
                          onTap: () => notifier.setMode(CommercialMode.rent),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // ── What are you looking for? ──────────────────────
                  Text(
                    'What are you\nlooking for?',
                    style: text20(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 14),

                  // 2x2 grid + 1 centered
                  _CategoryGrid(
                    categories: _categories,
                    selectedCat: state.selectedCategory,
                    onSelect: (cat) {
                      notifier.setCategory(cat);
                      context.pushNamed(AppPage.commercialListingsName);
                    },
                  ),
                  const SizedBox(height: 32),

                  // ── Back to Home ───────────────────────────────────
                  AppButton(title: "Back to Home", onTap: () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Mode Card ────────────────────────────────────────────────────────────────

class _ModeCard extends StatelessWidget {
  final String image;
  final String label;
  final String sublabel;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeCard({
    required this.image,
    required this.label,
    required this.sublabel,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.grey200,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Image.asset(
              color: isSelected ? AppColors.white : AppColors.primary,
              image,
              width: 40,
              height: 40,
            ),

            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: text16(
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? AppColors.white
                          : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    sublabel,
                    style: text11(
                      color: isSelected
                          ? Colors.white.withOpacity(0.8)
                          : AppColors.textSecondary,
                    ),
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

// ─── Category Grid ────────────────────────────────────────────────────────────

class _CatData {
  final String label;
  final CommercialCategory cat;
  final String gradientKey;
  const _CatData({
    required this.label,
    required this.cat,
    required this.gradientKey,
  });
}

class _CategoryGrid extends StatelessWidget {
  final List<_CatData> categories;
  final CommercialCategory? selectedCat;
  final ValueChanged<CommercialCategory> onSelect;

  const _CategoryGrid({
    required this.categories,
    required this.selectedCat,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    // First 4 in 2x2 grid, last 1 centered
    final first4 = categories.take(4).toList();
    final last = categories.length > 4 ? categories.last : null;

    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          primary: false,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: first4.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.25,
          ),
          itemBuilder: (_, i) => _CategoryTile(
            data: first4[i],
            isSelected: selectedCat == first4[i].cat,
            onTap: () => onSelect(first4[i].cat),
          ),
        ),
        if (last != null) ...[
          const SizedBox(height: 12),
          SizedBox(
            width: MediaQuery.of(context).size.width / 2 - 22,
            child: _CategoryTile(
              data: last,
              isSelected: selectedCat == last.cat,
              onTap: () => onSelect(last.cat),
            ),
          ),
        ],
      ],
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final _CatData data;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryTile({
    required this.data,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        height: 120,
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
          gradient: _gradientFor(data.gradientKey),
        ),
        child: Stack(
          children: [
            // Store/space icon placeholder background
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Icon(
                  _iconFor(data.cat),
                  size: 60,
                  color: Colors.white.withOpacity(0.12),
                ),
              ),
            ),
            // Label at bottom
            Positioned(
              bottom: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  data.label,
                  style: text12(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  LinearGradient _gradientFor(String key) {
    return switch (key) {
      'office' => const LinearGradient(
        colors: [Color(0xFF1A2A4A), Color(0xFF2D4A7A)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      'showroom' => const LinearGradient(
        colors: [Color(0xFF3A1A10), Color(0xFF7A3820)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      'warehouse' => const LinearGradient(
        colors: [Color(0xFF1A2A1A), Color(0xFF3A5A3A)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      'cowork' => const LinearGradient(
        colors: [Color(0xFF1A1A3A), Color(0xFF3A3A7A)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      _ => const LinearGradient(
        colors: [Color(0xFF3A2A10), Color(0xFF7A5A20)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    };
  }

  IconData _iconFor(CommercialCategory cat) => switch (cat) {
    CommercialCategory.shop => Icons.storefront_outlined,
    CommercialCategory.officeSpace => Icons.business_center_outlined,
    CommercialCategory.showroom => Icons.car_repair_outlined,
    CommercialCategory.warehouse => Icons.warehouse_outlined,
    CommercialCategory.coWorking => Icons.people_outline,
  };
}
