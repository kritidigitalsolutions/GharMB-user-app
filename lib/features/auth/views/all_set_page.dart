import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/auth/providers/onboarding_provider.dart';
import 'package:gharmb_app/routes/app_page.dart';
import 'package:gharmb_app/shared/button/custom_button.dart';
import 'package:go_router/go_router.dart';

class AllSetPage extends ConsumerWidget {
  const AllSetPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);

    // Build the summary rows from actual state
    final summaryItems = _buildSummary(state);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const Spacer(flex: 1),

              // ── Confetti / Success Illustration ───────────────────────────
              _SuccessIllustration(),
              const SizedBox(height: 24),

              Text(
                "You're all set! 🎉",
                style: text24(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Your profile is ready. We\'ll show you the best\nmatches based on your preferences.',
                style: text13(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // ── Preferences Summary Card ────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.grey50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.grey200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your preferences',
                      style: text14(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 14),
                    ...summaryItems.map(
                      (item) => _SummaryRow(
                        icon: item.icon,
                        iconBg: item.iconBg,
                        iconColor: item.iconColor,
                        label: item.label,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 2),

              // ── Explore Button ─────────────────────────────────────────
              AppButton(
                title: "Explore Properties",
                onTap: () {
                  context.pushNamed(AppPage.stayUpdateName);
                },
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  List<_SummaryItem> _buildSummary(OnboardingState state) {
    final items = <_SummaryItem>[];
    final goals = state.goals;
    final prefs = state;

    // Goal → intent
    if (goals.isNotEmpty) {
      final goalLabel = goals.first == PropertyGoal.buy
          ? 'Buying a Property'
          : goals.first == PropertyGoal.rent
          ? 'Renting a Property'
          : goals.first == PropertyGoal.sell
          ? 'Selling a Property'
          : goals.first == PropertyGoal.commercial
          ? 'Commercial Space'
          : 'Exploring Projects';
      items.add(
        _SummaryItem(
          icon: Icons.home_outlined,
          iconBg: const Color(0xFFFFF1EB),
          iconColor: AppColors.primary,
          label: goalLabel,
        ),
      );
    }

    // Budget
    items.add(
      _SummaryItem(
        icon: Icons.currency_rupee_outlined,
        iconBg: const Color(0xFFE6F9F0),
        iconColor: AppColors.success,
        label: 'Budget: ${prefs.budgetLabel}',
      ),
    );

    // City
    if (prefs.city.isNotEmpty) {
      items.add(
        _SummaryItem(
          icon: Icons.location_on_outlined,
          iconBg: const Color(0xFFE8F0FE),
          iconColor: AppColors.blue,
          label: 'Location: ${prefs.city}',
        ),
      );
    }

    // Property types
    if (prefs.propertyTypes.isNotEmpty) {
      items.add(
        _SummaryItem(
          icon: Icons.apartment_outlined,
          iconBg: const Color(0xFFFFF1EB),
          iconColor: AppColors.primary,
          label: 'Property Type: ${prefs.propertyTypesLabel}',
        ),
      );
    }

    // Bedrooms
    if (prefs.bedrooms.isNotEmpty) {
      items.add(
        _SummaryItem(
          icon: Icons.bed_outlined,
          iconBg: const Color(0xFFFFF8E1),
          iconColor: AppColors.warning,
          label: 'Bedrooms: ${prefs.bedroomsLabel}',
        ),
      );
    }

    return items;
  }
}

// ─── Summary Row ──────────────────────────────────────────────────────────────

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;

  const _SummaryRow({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: text13())),
        ],
      ),
    );
  }
}

// ─── Decorative Success Illustration ─────────────────────────────────────────

class _SuccessIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Stars / sparkles
          Positioned(
            top: 10,
            left: 30,
            child: _Star(color: const Color(0xFFEB5757), size: 14),
          ),
          Positioned(
            top: 0,
            right: 50,
            child: _Star(color: const Color(0xFF059AE4), size: 10),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: _Star(color: const Color(0xFFEB5757), size: 18),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: _Star(color: const Color(0xFF059AE4), size: 12),
          ),
          Positioned(
            bottom: 10,
            right: 30,
            child: _Star(color: const Color(0xFFEB5757), size: 10),
          ),
          // Plus decorations
          Positioned(
            top: 16,
            right: 80,
            child: _PlusIcon(color: AppColors.grey400),
          ),
          Positioned(
            bottom: 14,
            left: 60,
            child: _PlusIcon(color: AppColors.blue),
          ),
          // Check circle
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFE6F9F0),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.success.withOpacity(0.3),
                width: 6,
              ),
            ),
            child: const Icon(
              Icons.check_rounded,
              color: AppColors.success,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }
}

class _Star extends StatelessWidget {
  final Color color;
  final double size;
  const _Star({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.star_rounded, color: color, size: size);
  }
}

class _PlusIcon extends StatelessWidget {
  final Color color;
  const _PlusIcon({required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      '+',
      style: text16(fontWeight: FontWeight.w300, color: color),
    );
  }
}

// ─── Data model ───────────────────────────────────────────────────────────────

class _SummaryItem {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;

  _SummaryItem({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
  });
}
