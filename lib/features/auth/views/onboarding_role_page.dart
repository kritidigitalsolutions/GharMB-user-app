import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/auth/providers/onboarding_provider.dart';
import 'package:gharmb_app/routes/app_page.dart';
import 'package:gharmb_app/shared/button/custom_button.dart';
import 'package:gharmb_app/shared/widget/custom_stepprogress.dart';
import 'package:go_router/go_router.dart';

class OnboardingGoalPage extends ConsumerWidget {
  const OnboardingGoalPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedGoals = ref.watch(onboardingGoalProvider);
    final notifier = ref.read(onboardingGoalProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StepProgress(current: 2, total: 3),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  'Welcome to GharMB! 👋',
                  style: text20(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 6),
              Center(
                child: Text(
                  'What are you looking for?',
                  style: text14(color: AppColors.textSecondary),
                ),
              ),
              Center(
                child: Text(
                  '(You can select multiple)',
                  style: text12(color: AppColors.textSecondary),
                ),
              ),
              const SizedBox(height: 24),

              // GridView for 2x2 tiles
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1, // Adjust for visual balance
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _GoalTile(
                            goal: PropertyGoal.buy,
                            icon: Icons.home_outlined,
                            label: 'Buy Property',
                            subtitle: 'Find your dream home',
                            iconColor: AppColors.primary,
                            bgColor: const Color(0xFFFFF1EB),
                            isSelected: selectedGoals.contains(
                              PropertyGoal.buy,
                            ),
                            onTap: () => notifier.toggle(PropertyGoal.buy),
                          ),
                          _GoalTile(
                            goal: PropertyGoal.rent,
                            icon: Icons.vpn_key_outlined,
                            label: 'Rent Property',
                            subtitle: 'Find rental homes easily',
                            iconColor: const Color(0xFF7B2FBE),
                            bgColor: const Color(0xFFF5EEFF),
                            isSelected: selectedGoals.contains(
                              PropertyGoal.rent,
                            ),
                            onTap: () => notifier.toggle(PropertyGoal.rent),
                          ),
                          _GoalTile(
                            goal: PropertyGoal.commercial,
                            icon: Icons.business_outlined,
                            label: 'Commercial\nSpace',
                            subtitle: 'Shops, Offices &\nShowrooms',
                            iconColor: const Color(0xFF059AE4),
                            bgColor: const Color(0xFFE8F6FD),
                            isSelected: selectedGoals.contains(
                              PropertyGoal.commercial,
                            ),
                            onTap: () =>
                                notifier.toggle(PropertyGoal.commercial),
                          ),
                          _GoalTile(
                            goal: PropertyGoal.sell,
                            icon: Icons.local_offer_outlined,
                            label: 'Sell Property',
                            subtitle: 'List & sell your\nproperty',
                            iconColor: AppColors.primary,
                            bgColor: const Color(0xFFFFF1EB),
                            isSelected: selectedGoals.contains(
                              PropertyGoal.sell,
                            ),
                            onTap: () => notifier.toggle(PropertyGoal.sell),
                          ),
                        ],
                      ),
                    ),

                    // Full-width Explore Projects tile
                    _ExploreTile(
                      isSelected: selectedGoals.contains(
                        PropertyGoal.exploreProjects,
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              AppButton(
                title: "Get Started",
                onTap: selectedGoals.isNotEmpty
                    ? () => context.pushNamed(AppPage.preferenceName)
                    : null,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Goal Tile ────────────────────────────────────────────────────────────────

class _GoalTile extends StatelessWidget {
  final PropertyGoal goal;
  final IconData icon;
  final String label;
  final String subtitle;
  final Color iconColor;
  final Color bgColor;
  final bool isSelected;
  final VoidCallback onTap;

  const _GoalTile({
    required this.goal,
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.iconColor,
    required this.bgColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: AppColors.grey50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 1.8,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Icon(icon, color: iconColor, size: 45)),

            Text(
              label,
              textAlign: TextAlign.center,
              style: text13(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: text11(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Explore Projects Full Width Tile ─────────────────────────────────────────

class _ExploreTile extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const _ExploreTile({required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.grey50,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 1.8,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F6FD),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.location_city_outlined,
                color: Color(0xFF059AE4),
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Explore Projects',
                  style: text14(fontWeight: FontWeight.w600),
                ),
                Text(
                  'New Launch & Under Construction',
                  style: text12(color: AppColors.textSecondary),
                ),
              ],
            ),
            const Spacer(),
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: AppColors.white,
                  size: 14,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
