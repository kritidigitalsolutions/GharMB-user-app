import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/features/home/providers/developer_provider.dart';
import 'package:gharmb_app/routes/app_page.dart';
import 'package:gharmb_app/shared/button/custom_button.dart';
import 'package:go_router/go_router.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';

class TopDevelopersPage extends ConsumerWidget {
  const TopDevelopersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(developerListProvider);
    final notifier = ref.read(developerListProvider.notifier);
    final cities = ref.watch(citiesProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── App Bar ──────────────────────────────────────────────
            _AppBar(),

            // ── City Chips ───────────────────────────────────────────
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                itemCount: cities.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final c = cities[i];
                  final sel = c == state.selectedCity;
                  return GestureDetector(
                    onTap: () => notifier.setCity(c),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: sel ? AppColors.primary : AppColors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: sel ? AppColors.primary : AppColors.grey300,
                        ),
                      ),
                      child: Text(
                        c,
                        style: text13(
                          color: sel
                              ? AppColors.white
                              : AppColors.textSecondary,
                          fontWeight: sel ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),

            // ── Developer List ───────────────────────────────────────
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                children: [
                  ...state.visibleDevelopers.asMap().entries.map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _DeveloperCard(
                        rank: e.key + 1,
                        developer: e.value,
                        onTap: () {
                          ref.read(selectedDeveloperProvider.notifier).state =
                              e.value;
                          context.pushNamed(AppPage.developerDetailName);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // View all / View less
                  Center(
                    child: GestureDetector(
                      onTap: notifier.toggleShowAll,
                      child: Text(
                        state.showAll
                            ? 'View less ↑'
                            : 'View all ${state.developers.length} developers ↓',
                        style: text13(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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

// ─── App Bar ──────────────────────────────────────────────────────────────────

class _AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      child: Row(
        children: [
          CustomBackButton(),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Top 10 developers',
                  style: text18(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Verified · RERA registered · trusted',
                  style: text12(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.menu, color: AppColors.white, size: 20),
          ),
        ],
      ),
    );
  }
}

// ─── Developer Card ───────────────────────────────────────────────────────────

class _DeveloperCard extends StatelessWidget {
  final int rank;
  final DeveloperModel developer;
  final VoidCallback onTap;

  const _DeveloperCard({
    required this.rank,
    required this.developer,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.grey200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Logo
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.grey100,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.grey200),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: const _ConstructionLogoPlaceholder(),
              ),
            ),
            const SizedBox(width: 12),

            // Name + details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          developer.name,
                          style: text14(fontWeight: FontWeight.bold),
                        ),
                      ),
                      // Rating
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: AppColors.yellow,
                            size: 14,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            developer.rating.toStringAsFixed(1),
                            style: text12(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          developer.coverage,
                          style: text12(color: AppColors.textSecondary),
                        ),
                      ),
                      Text(
                        developer.reviewCount,
                        style: text11(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Badges
                  Row(
                    children: [
                      if (developer.reraApproved) _Badge(label: 'RERA'),
                      if (developer.reraApproved) const SizedBox(width: 6),
                      if (developer.isoCertified)
                        _Badge(label: 'ISO certified'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Arrow
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  const _Badge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Text(
        label,
        style: text10(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ─── Construction Logo Placeholder ───────────────────────────────────────────

class _ConstructionLogoPlaceholder extends StatelessWidget {
  const _ConstructionLogoPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F0E8),
      child: const Center(
        child: Icon(Icons.construction, color: Color(0xFF8B6914), size: 28),
      ),
    );
  }
}
