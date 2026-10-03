import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/developer/providers/register_provider.dart';
import 'package:gharmb_app/features/profile/models/profile_model.dart';
import 'package:gharmb_app/features/profile/provider/profile_provider.dart';
import 'package:gharmb_app/features/property/providers/property_add_provider.dart';
import 'package:gharmb_app/routes/app_page.dart';
import 'package:gharmb_app/shared/button/custom_button.dart';
import 'package:go_router/go_router.dart';

class PropertyListType extends ConsumerWidget {
  const PropertyListType({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(listPropertyProvider);
    final notifier = ref.read(listPropertyProvider.notifier);
    final user = ref.watch(userModelProvider);

    final isAgentUnderReview = user?.isAgentUnderReview == true;
    final isAgentVerified = user?.isAgentVerified == true;
    final isDeveloperUnderReview = user?.isBuilderUnderReview == true;
    final isDeveloperVerified = user?.isBuilderVerified == true;

    final isSelectedRoleUnderReview = (state.role == ListingRole.agentBroker && isAgentUnderReview) ||
        (state.role == ListingRole.developerBuilder && isDeveloperUnderReview);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            ref.invalidate(userProfileDataProvider);
            ref.invalidate(verificationStatusProvider);
            try {
              await Future.wait([
                ref.read(userProfileDataProvider.future),
                ref.read(verificationStatusProvider.future),
              ]);
            } catch (_) {}
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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
                    statusBadge: 'Instant Listing',
                    statusBadgeColor: AppColors.success,
                    onTap: () => notifier.setRole(ListingRole.owner),
                  ),
                  const SizedBox(height: 10),
                  _RoleTile(
                    icon: Icons.badge_outlined,
                    title: 'Agent / Broker',
                    subtitle: 'Listing on behalf of a client',
                    isSelected: state.role == ListingRole.agentBroker,
                    statusBadge: isAgentVerified
                        ? 'Verified'
                        : (isAgentUnderReview
                            ? 'Under Review'
                            : 'Docs Required'),
                    statusBadgeColor: isAgentVerified
                        ? AppColors.success
                        : (isAgentUnderReview
                            ? const Color(0xFFE65100)
                            : AppColors.primary),
                    onTap: () {
                      notifier.setRole(ListingRole.agentBroker);
                      if (isAgentUnderReview) {
                        _showUnderReviewModal(
                          context,
                          role: 'Agent / Broker',
                          message:
                              'Aapke Agent registration documents & RERA details review ke under hain. Admin verification approve hone ke baad hi aap property listing kar sakte hain.',
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  _RoleTile(
                    icon: Icons.domain_outlined,
                    title: 'Developer / Builder',
                    subtitle: 'New project or multiple units',
                    isSelected: state.role == ListingRole.developerBuilder,
                    statusBadge: isDeveloperVerified
                        ? 'Verified'
                        : (isDeveloperUnderReview
                            ? 'Under Review'
                            : 'Docs Required'),
                    statusBadgeColor: isDeveloperVerified
                        ? AppColors.success
                        : (isDeveloperUnderReview
                            ? const Color(0xFFE65100)
                            : AppColors.primary),
                    onTap: () {
                      notifier.setRole(ListingRole.developerBuilder);
                      if (isDeveloperUnderReview) {
                        _showUnderReviewModal(
                          context,
                          role: 'Developer / Builder',
                          message:
                              'Aapke Developer registration documents & RERA details review ke under hain. Admin verification approve hone ke baad hi aap projects & properties list kar sakte hain.',
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  // ── Under Review Warning (if applicable) ─────────────────
                  if (isSelectedRoleUnderReview) ...[
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8EC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.warning.withOpacity(0.5),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.hourglass_top_rounded,
                            color: AppColors.warning,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Document Verification In Progress',
                                  style: text13(
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFB75500),
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  'Aapke documents abhi review mai hain. Verification complete hone ke baad hi aap property listing kar sakte hain.',
                                  style: text11(
                                    color: AppColors.textSecondary,
                                  ).copyWith(height: 1.4),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ] else ...[
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
                  ],

                  // ── CTA button ───────────────────────────────────────────
                  AppButton(
                    title: isSelectedRoleUnderReview
                        ? 'Check Verification Status'
                        : "Continue as ${_roleLabel(state.role)}",
                    color: isSelectedRoleUnderReview
                        ? AppColors.warning
                        : AppColors.primary,
                    onTap: () => _handleNavigation(context, state.role, user),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

  // ── Navigation logic with Under Review Guard ──────────────────────────────
  void _handleNavigation(
    BuildContext context,
    ListingRole role,
    UserModel? user,
  ) {
    if (role == ListingRole.agentBroker) {
      // 1. If Agent is verified -> proceed
      if (user?.isAgentVerified == true) {
        context.pushNamed(AppPage.basicDetailsName);
        return;
      }

      // 2. If Agent document is Under Review or registered as agent -> Block listing
      if (user?.isAgentUnderReview == true || user?.role?.toLowerCase() == 'agent') {
        _showUnderReviewModal(
          context,
          role: 'Agent / Broker',
          message:
              'Aapke Agent registration documents & RERA details review ke under hain. Admin verification approve hone ke baad hi aap property listing kar sakte hain.',
        );
        return;
      }

      // 3. If Agent has not submitted docs -> Send to registration
      context.pushNamed(
        AppPage.devRegisterStep1Name,
        extra: RegistrationType.agent,
      );
      return;
    } else if (role == ListingRole.developerBuilder) {
      // 1. If Developer is verified -> proceed
      if (user?.isBuilderVerified == true) {
        context.pushNamed(AppPage.basicDetailsName);
        return;
      }

      // 2. If Developer document is Under Review or registered as developer -> Block listing
      final r = user?.role?.toLowerCase();
      if (user?.isBuilderUnderReview == true || r == 'builder' || r == 'developer') {
        _showUnderReviewModal(
          context,
          role: 'Developer / Builder',
          message:
              'Aapke Developer registration documents & RERA details review ke under hain. Admin verification approve hone ke baad hi aap projects & properties list kar sakte hain.',
        );
        return;
      }

      // 3. If Developer has not submitted docs -> Send to registration
      context.pushNamed(
        AppPage.devRegisterStep1Name,
        extra: RegistrationType.developer,
      );
      return;
    }

    // Owner proceeds directly to listing flow
    context.pushNamed(AppPage.basicDetailsName);
  }

  void _showUnderReviewModal(
    BuildContext context, {
    required String role,
    required String message,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalCtx) => Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.hourglass_top_rounded,
                color: AppColors.warning,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '$role Verification Under Review',
              style: text18(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.warning.withOpacity(0.4)),
              ),
              child: Text(
                'Status: Under Review (24-48 hrs)',
                style: text12(
                  color: const Color(0xFFE65100),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              message,
              style: text13(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(modalCtx).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: AppColors.grey300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Close',
                      style: text13(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(modalCtx).pop();
                      context.pushNamed(AppPage.myHomeName, extra: 4);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'View Profile',
                      style: text13(
                        color: AppColors.white,
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
    );
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
  final String? statusBadge;
  final Color? statusBadgeColor;
  final VoidCallback onTap;

  const _RoleTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    this.statusBadge,
    this.statusBadgeColor,
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
                  Row(
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
                      if (statusBadge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white.withOpacity(0.25)
                                : (statusBadgeColor ?? AppColors.primary)
                                    .withOpacity(0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            statusBadge!,
                            style: text10(
                              color: isSelected
                                  ? AppColors.white
                                  : (statusBadgeColor ?? AppColors.primary),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
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
