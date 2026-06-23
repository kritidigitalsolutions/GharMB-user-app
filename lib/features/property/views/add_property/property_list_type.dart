import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/developer/providers/register_provider.dart';
import 'package:gharmb_app/features/property/providers/property_add_provider.dart';
import 'package:gharmb_app/routes/app_page.dart';
import 'package:gharmb_app/shared/button/custom_button.dart';
import 'package:go_router/go_router.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';

class PropertyListType extends ConsumerWidget {
  const PropertyListType({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(listPropertyProvider);
    final notifier = ref.read(listPropertyProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 12),

                  // ── Hero icon ────────────────────────────────────────────
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.apartment_rounded,
                      color: AppColors.white,
                      size: 44,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Text(
                    'List your property',
                    style: text20(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Every listing is verified by our admin team\nbefore going live. Genuine buyers only',
                    style: text13(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),

                  // ── Role label ───────────────────────────────────────────
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'You are listing as',
                      style: text13(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ── Role tiles ───────────────────────────────────────────
                  _RoleTile(
                    icon: Icons.person_outline,
                    title: 'Owner',
                    subtitle: 'Direct sale or rent from owner',
                    isSelected: state.role == ListingRole.owner,
                    onTap: () => notifier.setRole(ListingRole.owner),
                  ),
                  const SizedBox(height: 10),
                  _RoleTile(
                    icon: Icons.badge_outlined,
                    title: 'Agent / Broker',
                    subtitle: 'Listing on behalf of a client',
                    isSelected: state.role == ListingRole.agentBroker,
                    onTap: () => notifier.setRole(ListingRole.agentBroker),
                  ),
                  const SizedBox(height: 10),
                  _RoleTile(
                    icon: Icons.domain_outlined,
                    title: 'Developer / Builder',
                    subtitle: 'New project or multiple units',
                    isSelected: state.role == ListingRole.developerBuilder,
                    onTap: () => notifier.setRole(ListingRole.developerBuilder),
                  ),
                  const SizedBox(height: 20),

                  // ── Verification note ────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.success.withOpacity(0.25),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.verified_user_outlined,
                          color: AppColors.success,
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Our admin will verify your identity and property documents before your listing goes live. This ensures only genuine deals reach buyers.',
                            style: text12(
                              color: AppColors.textSecondary,
                            ).copyWith(height: 1.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── CTA button ───────────────────────────────────────────
                  AppButton(
                    title: "Continue as ${_roleLabel(state.role)}",
                    onTap: () => _handleNavigation(context, state.role),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Navigation logic ──────────────────────────────────────────────────────
  void _handleNavigation(BuildContext context, ListingRole role) {
    switch (role) {
      case ListingRole.owner:
        // Owner → direct to property listing flow
        context.pushNamed(AppPage.basicDetailsName);
        break;

      case ListingRole.agentBroker:
        context.pushNamed(
          AppPage.devRegisterStep1Name,
          extra: RegistrationType.agent,
        );

        break;

      case ListingRole.developerBuilder:
        context.pushNamed(
          AppPage.devRegisterStep1Name,
          extra: RegistrationType.developer,
        );

        break;
    }
  }

  String _roleLabel(ListingRole r) => switch (r) {
    ListingRole.owner => 'Owner',
    ListingRole.agentBroker => 'Agent',
    ListingRole.developerBuilder => 'Developer',
  };
}

// ─── Role Tile ────────────────────────────────────────────────────────────────

class _RoleTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.grey50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.grey200,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.2)
                    : AppColors.grey200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 22,
                color: isSelected ? AppColors.white : AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: text14(
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppColors.white
                          : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: text12(
                      color: isSelected
                          ? Colors.white.withOpacity(0.8)
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected ? AppColors.white : AppColors.grey400,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
