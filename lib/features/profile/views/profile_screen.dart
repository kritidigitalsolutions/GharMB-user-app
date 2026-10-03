import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/core/utils/local_storage/auth_storage.dart';
import 'package:gharmb_app/features/developer/providers/register_provider.dart';
import 'package:gharmb_app/features/profile/models/profile_model.dart';
import 'package:gharmb_app/features/profile/provider/user_profile_provider.dart';
import 'package:gharmb_app/features/profile/views/about_us_page.dart';
import 'package:gharmb_app/features/profile/views/contact_us_page.dart';
import 'package:gharmb_app/features/profile/views/privacy_policy_page.dart';
import 'package:gharmb_app/features/profile/views/term_and_condtion_page.dart';
import 'package:gharmb_app/routes/app_page.dart';
import 'package:go_router/go_router.dart';

// ─── Data model ───────────────────────────────────────────────
class _ToolItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;

  const _ToolItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
  });
}

// ─── Main Page ─────────────────────────────────────────────────
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userModelProvider);

    final isDeveloper = userAsync?.isBuilder == true;
    final isAgent = userAsync?.isAgent == true;
    final isDeveloperVerified = userAsync?.isBuilderVerified == true;
    final isAgentVerified = userAsync?.isAgentVerified == true;

    final List<_ToolItem> tools = [
      if (isDeveloper) ...[
        const _ToolItem(
          title: 'My Project',
          subtitle: 'Manage developer projects',
          icon: Icons.apartment_outlined,
          iconColor: Color(0xFF6C63FF),
          bgColor: Color(0xFFF0EEFF),
        ),
        const _ToolItem(
          title: 'Dashboard',
          subtitle: 'Developer overview & analytics',
          icon: Icons.dashboard_outlined,
          iconColor: Color(0xFF6C63FF),
          bgColor: Color(0xFFF0EEFF),
        ),
      ] else if (isAgent) ...[
        const _ToolItem(
          title: 'Dashboard',
          subtitle: 'Agent overview & analytics',
          icon: Icons.dashboard_outlined,
          iconColor: Color(0xFF6C63FF),
          bgColor: Color(0xFFF0EEFF),
        ),
      ] else ...[
        const _ToolItem(
          title: 'Register as Developer',
          subtitle: 'List projects & commercial properties (RERA)',
          icon: Icons.domain_outlined,
          iconColor: Color(0xFF1D9E75),
          bgColor: Color(0xFFE8F8F2),
        ),
        const _ToolItem(
          title: 'Register as Agent',
          subtitle: 'Become a certified RERA agent',
          icon: Icons.badge_outlined,
          iconColor: Color(0xFF6C63FF),
          bgColor: Color(0xFFF0EEFF),
        ),
      ],
      const _ToolItem(
        title: 'Site Visits',
        subtitle: 'Manage & track property visits',
        icon: Icons.calendar_month_outlined,
        iconColor: Color(0xFF00897B),
        bgColor: Color(0xFFE0F2F1),
      ),
      const _ToolItem(
        title: 'Loan Calculator',
        subtitle: 'Calculate your home loan',
        icon: Icons.calculate_outlined,
        iconColor: Color(0xFFF35402),
        bgColor: Color(0xFFFFF3EE),
      ),
      const _ToolItem(
        title: 'Unit Converter',
        subtitle: 'Area, length & more',
        icon: Icons.swap_horiz_rounded,
        iconColor: Color(0xFF059AE4),
        bgColor: Color(0xFFE8F5FF),
      ),
      const _ToolItem(
        title: 'News & Insights',
        subtitle: 'Real estate updates',
        icon: Icons.campaign_outlined,
        iconColor: Color(0xFFEB5757),
        bgColor: Color(0xFFFFEEEE),
      ),
      const _ToolItem(
        title: 'Invite Friends',
        subtitle: 'Refer & earn rewards',
        icon: Icons.person_add_outlined,
        iconColor: Color(0xFF059AE4),
        bgColor: Color(0xFFE8F5FF),
      ),
      const _ToolItem(
        title: 'About us',
        subtitle: 'About us',
        icon: Icons.info,
        iconColor: Color(0xFF059AE4),
        bgColor: Color(0xFFE8F5FF),
      ),
      const _ToolItem(
        title: 'Privacy policy',
        subtitle: 'Privacy policy',
        icon: Icons.security,
        iconColor: Colors.red,
        bgColor: Color(0xFFE8F5FF),
      ),
      const _ToolItem(
        title: 'Terms and conditions',
        subtitle: 'Terms and conditions',
        icon: Icons.description,
        iconColor: Colors.orange,
        bgColor: Color(0xFFE8F5FF),
      ),
      const _ToolItem(
        title: 'Contact us',
        subtitle: 'Contact us',
        icon: Icons.support_agent_rounded,
        iconColor: Colors.purple,
        bgColor: Color(0xFFE8F5FF),
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 96,
        title: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.25),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: ClipOval(
                child:
                    (userAsync?.profilePicture != null &&
                        userAsync!.profilePicture!.isNotEmpty)
                    ? Image.network(
                        userAsync.profilePicture!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Text(
                          userAsync.name?.isNotEmpty == true
                              ? userAsync.name![0].toUpperCase()
                              : 'N',
                          style: text16(
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                      )
                    : Text(
                        userAsync?.name?.isNotEmpty == true
                            ? userAsync!.name![0].toUpperCase()
                            : 'N',
                        style: text16(
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          userAsync?.name ?? 'No Name',
                          style: text16(
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          userAsync?.verificationStatus ?? 'Buyer',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    userAsync?.address?.fullAddress ??
                        userAsync?.phone ??
                        'No Address',
                    style: text12(color: AppColors.white.withOpacity(0.85)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                context.pushNamed(AppPage.profileEditName);
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.edit_outlined,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
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
        color: AppColors.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Verification Banner ───────────────────
              if ((isDeveloper && !isDeveloperVerified) ||
                  (isAgent && !isAgentVerified)) ...[
                Builder(
                  builder: (context) {
                    final isUnderReview =
                        (isDeveloper &&
                            userAsync?.isBuilderUnderReview == true) ||
                        (isAgent && userAsync?.isAgentUnderReview == true);
                    final roleName = isDeveloper ? 'Developer' : 'Agent';

                    return Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isUnderReview
                            ? const Color(0xFFF0F7FF)
                            : const Color(0xFFFFF8EC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isUnderReview
                              ? AppColors.primary.withOpacity(0.3)
                              : AppColors.warning.withOpacity(0.5),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                isUnderReview
                                    ? Icons.hourglass_top_rounded
                                    : Icons.assignment_late_outlined,
                                color: isUnderReview
                                    ? AppColors.primary
                                    : AppColors.warning,
                                size: 22,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isUnderReview
                                          ? '$roleName Documents Under Review'
                                          : '$roleName Documents Not Uploaded',
                                      style: text13(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      isUnderReview
                                          ? 'Your uploaded RERA & identity documents are currently being reviewed by admin.'
                                          : 'You have not uploaded any RERA or KYC documents yet. Complete registration to verify your account.',
                                      style: text11(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if (!isUnderReview) ...[
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                onTap: () {
                                  context.pushNamed(
                                    AppPage.devRegisterStep1Name,
                                    extra: isDeveloper
                                        ? RegistrationType.developer
                                        : RegistrationType.agent,
                                  );
                                },
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Upload Documents',
                                    style: text12(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ],

              Text('My tools', style: text20(fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),

              ...List.generate(tools.length, (i) {
                final tool = tools[i];
                return _ToolCard(
                  tool: tool,
                  onTap: () => _handleToolTap(context, tool.title, userAsync),
                );
              }),

              const SizedBox(height: 28),

              // ── Logout Button ──────────────────────────
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _showLogoutDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    elevation: 0,
                  ),
                  child: Text(
                    'Log Out',
                    style: text15(
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ── Safety note ────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6FFF9),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.grey300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.shield_outlined,
                      color: AppColors.success,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your data is safe with us',
                          style: text13(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'We never share your information',
                          style: text12(color: AppColors.textSecondary),
                        ),
                      ],
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

// ─── Logout Dialog ─────────────────────────────────────────────
void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.45),
    builder: (_) => const _LogoutDialog(),
  );
}

class _LogoutDialog extends StatelessWidget {
  const _LogoutDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Icon ──────────────────────────────────────────
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: AppColors.error,
                size: 30,
              ),
            ),
            const SizedBox(height: 18),

            // ── Title ──────────────────────────────────────────
            Text('Log Out?', style: text20(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            // ── Subtitle ───────────────────────────────────────
            Text(
              'Are you sure you want to log out of your GharMB account?',
              style: text13(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),

            // ── Buttons ────────────────────────────────────────
            Row(
              children: [
                // Cancel
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.grey300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      'Cancel',
                      style: text14(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Log Out
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await LocalStorageService.clearAuthData();
                      context.goNamed(AppPage.loginName);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                    ),
                    child: Text(
                      'Log Out',
                      style: text14(
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
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
}

// ─── Tool tap handler with Navigation Guard ────────────────────────
void _handleToolTap(BuildContext context, String title, UserModel? user) {
  switch (title) {
    case 'Register as Developer':
      if (user?.isBuilderUnderReview == true) {
        _showStatusModal(
          context,
          title: 'Developer Verification in Progress',
          message:
              'Your developer documents & RERA details have already been submitted and are currently under review by our admin team.',
          status: 'Under Review',
          isUnderReview: true,
        );
        return;
      } else if (user?.isBuilderVerified == true) {
        _showStatusModal(
          context,
          title: 'Developer Account Verified',
          message:
              'You are already a certified, verified developer on GharMB. You can manage your projects from My Projects & Dashboard.',
          status: 'Verified',
          isUnderReview: false,
        );
        return;
      }
      context.pushNamed(
        AppPage.devRegisterStep1Name,
        extra: RegistrationType.developer,
      );
      break;

    case 'Register as Agent':
      if (user?.isAgentUnderReview == true) {
        _showStatusModal(
          context,
          title: 'Agent Verification in Progress',
          message:
              'Your agent documents & RERA certification have already been submitted and are currently being reviewed by our admin team.',
          status: 'Under Review',
          isUnderReview: true,
        );
        return;
      } else if (user?.isAgentVerified == true) {
        _showStatusModal(
          context,
          title: 'Agent Account Verified',
          message:
              'You are already a certified, verified agent on GharMB. You can post and manage your listings from your Dashboard.',
          status: 'Verified',
          isUnderReview: false,
        );
        return;
      }
      context.pushNamed(
        AppPage.devRegisterStep1Name,
        extra: RegistrationType.agent,
      );
      break;

    case 'Dashboard':
      context.pushNamed(AppPage.dashboardName);
      break;
    case 'My Project':
      context.pushNamed(AppPage.myProjectName);
      break;
    case 'Invite Friends':
      context.pushNamed(AppPage.inviteFriendsName);
      break;
    case 'Site Visits':
      context.pushNamed(AppPage.siteVisitsName);
      break;
    case 'Loan Calculator':
      context.pushNamed(AppPage.loanCalculatorName);
      break;
    case 'Unit Converter':
      context.pushNamed(AppPage.unitConverterName);
      break;
    case 'News & Insights':
      context.pushNamed(AppPage.newsListName);
      break;
    case 'About us':
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: ((context) => AboutUsPage())));
      break;
    case 'Contact us':
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: ((context) => ContactUsPage())));
      break;
    case 'Terms and conditions':
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: ((context) => TermsConditionPage())));
      break;
    case 'Privacy policy':
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: ((context) => PrivacyPolicyPage())));
      break;
  }
}

void _showStatusModal(
  BuildContext context, {
  required String title,
  required String message,
  required String status,
  required bool isUnderReview,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isUnderReview
                    ? AppColors.warning.withOpacity(0.12)
                    : AppColors.success.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isUnderReview
                    ? Icons.hourglass_top_rounded
                    : Icons.verified_user_rounded,
                color: isUnderReview ? AppColors.warning : AppColors.success,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: text16(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isUnderReview
                    ? AppColors.warning.withOpacity(0.1)
                    : AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status,
                style: text11(
                  color: isUnderReview ? AppColors.warning : AppColors.success,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: text13(
                color: AppColors.textSecondary,
              ).copyWith(height: 1.45),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Understood',
                  style: text14(color: AppColors.white),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

// ─── Tool Card ─────────────────────────────────────────────────
class _ToolCard extends StatelessWidget {
  final _ToolItem tool;
  final VoidCallback onTap;

  const _ToolCard({required this.tool, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.grey200),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: tool.bgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(tool.icon, color: tool.iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tool.title, style: text14(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(
                    tool.subtitle,
                    style: text12(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
