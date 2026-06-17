import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/quick_access/providers/service_provider.dart';
import 'package:gharmb_app/shared/button/custom_button.dart';

class InteriorDesignPage extends ConsumerWidget {
  const InteriorDesignPage({super.key});

  static const _styleLabels = {
    InteriorStyle.allStyles: 'All styles',
    InteriorStyle.modern: 'Modern',
    InteriorStyle.minimal: 'Minimal',
    InteriorStyle.classic: 'Classic',
    InteriorStyle.luxury: 'Luxury',
  };

  static const _styleColors = [
    [Color(0xFF2C3E50), Color(0xFF4CA1AF)],
    [Color(0xFF8E44AD), Color(0xFF3498DB)],
    [Color(0xFF7F8C8D), Color(0xFF2C3E50)],
    [Color(0xFFC0392B), Color(0xFF8E44AD)],
  ];

  static const _styleTitles = ['Modern', 'Minimal', 'Classic', 'Luxurious'];
  static const _stylePrices = ['From ₹1L', 'From ₹2L', 'From ₹5L', 'From ₹8L'];

  static const _features = [
    _Feature(icon: Icons.design_services_outlined, label: 'Free 3D\nDesign'),
    _Feature(icon: Icons.palette_outlined, label: 'Material\nSelection'),
    _Feature(icon: Icons.local_shipping_outlined, label: 'On-time\nDelivery'),
    _Feature(icon: Icons.verified_outlined, label: '1 Year\nWarranty'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(interiorDesignProvider);
    final notifier = ref.read(interiorDesignProvider.notifier);
    final packages = ref.watch(interiorPackagesProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──────────────────────────────────────
              Row(
                children: [
                  CustomBackButton(),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Interior design',
                        style: text18(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Transform your new home',
                        style: text12(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ── Style Tabs ───────────────────────────────────
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: InteriorStyle.values.map((s) {
                    final isSelected = state.selectedStyle == s;
                    return GestureDetector(
                      onTap: () => notifier.setStyle(s),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.grey300,
                          ),
                        ),
                        child: Text(
                          _styleLabels[s]!,
                          style: text12(
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? AppColors.white
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),

              // ── Choose Your Style ────────────────────────────
              Text(
                'Choose your style',
                style: text15(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 140,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _styleTitles.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 10),
                  itemBuilder: (_, i) => _StyleCard(
                    title: _styleTitles[i],
                    price: _stylePrices[i],
                    gradientColors: _styleColors[i],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ── Packages ─────────────────────────────────────
              Text('Our packages', style: text15(fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              Row(
                children: packages
                    .map(
                      (p) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _PackageCard(package: p),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 24),

              // ── What's Included ──────────────────────────────
              Text(
                "What's included",
                style: text15(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _features
                    .map((f) => _FeatureItem(feature: f))
                    .toList(),
              ),
              const SizedBox(height: 28),

              // ── CTA Button ───────────────────────────────────
              AppButton(title: 'Book Free Consultation', onTap: () {}),

              const SizedBox(height: 14),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.success,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '1000+ Homes Designed',
                      style: text12(
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StyleCard extends StatelessWidget {
  final String title;
  final String price;
  final List<Color> gradientColors;
  const _StyleCard({
    required this.title,
    required this.price,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 12,
            left: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: text13(
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
                Text(
                  price,
                  style: text10(color: AppColors.white.withOpacity(0.8)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PackageCard extends StatelessWidget {
  final InteriorPackage package;
  const _PackageCard({required this.package});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: package.color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: package.color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            package.name,
            style: text13(fontWeight: FontWeight.w700, color: package.color),
          ),
          const SizedBox(height: 3),
          Text(package.price, style: text11(fontWeight: FontWeight.w600)),
          const SizedBox(height: 5),
          Text(
            package.description,
            style: text10(color: AppColors.textSecondary),
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}

class _Feature {
  final IconData icon;
  final String label;
  const _Feature({required this.icon, required this.label});
}

class _FeatureItem extends StatelessWidget {
  final _Feature feature;
  const _FeatureItem({required this.feature});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(feature.icon, color: AppColors.primary, size: 22),
        ),
        const SizedBox(height: 6),
        Text(
          feature.label,
          style: text10(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
