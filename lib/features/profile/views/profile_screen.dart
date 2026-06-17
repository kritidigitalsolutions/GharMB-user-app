import 'package:flutter/material.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
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

const List<_ToolItem> _tools = [
  _ToolItem(
    title: 'Loan Calculator',
    subtitle: 'Calculate your home loan',
    icon: Icons.calculate_outlined,
    iconColor: Color(0xFFF35402),
    bgColor: Color(0xFFFFF3EE),
  ),
  _ToolItem(
    title: 'Unit Converter',
    subtitle: 'Area, length & more',
    icon: Icons.swap_horiz_rounded,
    iconColor: Color(0xFF059AE4),
    bgColor: Color(0xFFE8F5FF),
  ),
  _ToolItem(
    title: 'My Properties',
    subtitle: 'Manage your properties',
    icon: Icons.home_outlined,
    iconColor: Color(0xFFF35402),
    bgColor: Color(0xFFFFF3EE),
  ),
  _ToolItem(
    title: 'News & Insights',
    subtitle: 'Real estate updates',
    icon: Icons.campaign_outlined,
    iconColor: Color(0xFFEB5757),
    bgColor: Color(0xFFFFEEEE),
  ),
  _ToolItem(
    title: 'Dashboard',
    subtitle: 'Overview & analytics',
    icon: Icons.dashboard_outlined,
    iconColor: Color(0xFF6C63FF),
    bgColor: Color(0xFFF0EEFF),
  ),
  _ToolItem(
    title: 'Invite Friends',
    subtitle: 'Refer & earn rewards',
    icon: Icons.person_add_outlined,
    iconColor: Color(0xFF059AE4),
    bgColor: Color(0xFFE8F5FF),
  ),
];

// ─── Main Page ─────────────────────────────────────────────────
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 90,

        title: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.25),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                'SD',
                style: text14(
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rahul Sharma',
                    style: text16(
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Meerut, Uttar Pradesh',
                    style: text12(color: AppColors.white.withOpacity(0.85)),
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('My tools', style: text20(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 16),

                  ...List.generate(_tools.length, (i) {
                    final tool = _tools[i];
                    return _ToolCard(
                      tool: tool,
                      onTap: () => _handleToolTap(context, tool.title),
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
        ],
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
                    onPressed: () {
                      Navigator.of(context).pop();
                      // TODO: clear session & navigate to login
                      // context.goNamed(AppPage.loginName);
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

// ─── Tool tap handler ──────────────────────────────────────────
void _handleToolTap(BuildContext context, String title) {
  switch (title) {
    case 'Dashboard':
      context.pushNamed(AppPage.dashboardName);
      break;
    case 'My Properties':
      context.pushNamed(AppPage.myPropertyName);
      break;
    case 'Invite Friends':
      context.pushNamed(AppPage.inviteFriendsName);
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
  }
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
