import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/features/profile/provider/profile_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';

class InviteFriendsPage extends ConsumerWidget {
  const InviteFriendsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invite = ref.watch(inviteProvider);
    final notifier = ref.read(inviteProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.arrow_back,
              color: AppColors.white,
              size: 18,
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Invite Friends', style: text16(fontWeight: FontWeight.bold)),
            Text(
              'Earn rewards together',
              style: text11(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Column(
          children: [
            // ── Hero Banner ───────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF5F00), Color(0xFFFF8C42)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Gift icon
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.card_giftcard_outlined,
                      color: AppColors.white,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Invite & Earn ₹250',
                    style: text22Bold(color: AppColors.white),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Get ₹250 in GharMB coins for every\nfriend who joins and posts a listing',
                    style: text13(
                      color: Colors.white.withOpacity(0.9),
                    ).copyWith(height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Stats row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _HeroBadge(
                        value: '${invite.friendsInvited}',
                        label: 'Friends\nInvited',
                      ),
                      Container(
                        width: 1,
                        height: 36,
                        color: Colors.white.withOpacity(0.3),
                      ),
                      _HeroBadge(
                        value: '₹${invite.coinsEarned}',
                        label: 'Coins\nEarned',
                      ),
                      Container(
                        width: 1,
                        height: 36,
                        color: Colors.white.withOpacity(0.3),
                      ),
                      _HeroBadge(value: '₹250', label: 'Per\nReferral'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Referral Code Card ────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Referral Code',
                    style: text14(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
                    decoration: BoxDecoration(
                      color: AppColors.grey50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: invite.isCopied
                            ? AppColors.success
                            : AppColors.grey200,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            invite.referralCode,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(
                              ClipboardData(text: invite.referralCode),
                            );
                            notifier.setCopied();
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: invite.isCopied
                                  ? AppColors.success
                                  : AppColors.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  invite.isCopied
                                      ? Icons.check
                                      : Icons.copy_outlined,
                                  color: AppColors.white,
                                  size: 15,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  invite.isCopied ? 'Copied!' : 'Copy',
                                  style: text12(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Share Buttons ─────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Share via', style: text14(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _ShareOption(
                        icon: Icons.chat_outlined,
                        label: 'WhatsApp',
                        color: const Color(0xFF25D366),
                        onTap: () {},
                      ),
                      _ShareOption(
                        icon: Icons.message_outlined,
                        label: 'SMS',
                        color: AppColors.blue,
                        onTap: () {},
                      ),
                      _ShareOption(
                        icon: Icons.email_outlined,
                        label: 'Email',
                        color: const Color(0xFFEA4335),
                        onTap: () {},
                      ),
                      _ShareOption(
                        icon: Icons.share_outlined,
                        label: 'More',
                        color: AppColors.textSecondary,
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── How it works ──────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How it works',
                    style: text14(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _HowItWorksStep(
                    step: 1,
                    icon: Icons.share_outlined,
                    title: 'Share your code',
                    subtitle:
                        'Send your referral code to friends via WhatsApp, SMS or any channel',
                  ),
                  _HowItWorksStep(
                    step: 2,
                    icon: Icons.person_add_outlined,
                    title: 'Friend signs up',
                    subtitle:
                        'Your friend downloads GharMB and registers using your code',
                  ),
                  _HowItWorksStep(
                    step: 3,
                    icon: Icons.home_outlined,
                    title: 'They list a property',
                    subtitle:
                        'Once your friend posts their first verified listing, you both earn',
                  ),
                  _HowItWorksStep(
                    step: 4,
                    icon: Icons.currency_rupee_outlined,
                    title: 'You both get ₹250',
                    subtitle:
                        'Coins are credited within 48 hours and can be used for premium features',
                    isLast: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Terms ─────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.grey50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.grey200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Terms & Conditions',
                    style: text12(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  ...const [
                    '• Referral valid only for new users',
                    '• Friend must post a verified listing',
                    '• Coins expire after 6 months',
                    '• GharMB reserves the right to modify the program',
                  ].map(
                    (t) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        t,
                        style: text11(color: AppColors.textSecondary),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Invite CTA ────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.send_outlined,
                  color: AppColors.white,
                  size: 18,
                ),
                label: Text(
                  'Invite Friends Now',
                  style: text15(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Hero Badge ───────────────────────────────────────────────────────────────

class _HeroBadge extends StatelessWidget {
  final String value;
  final String label;
  const _HeroBadge({required this.value, required this.label});

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        value,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.white,
        ),
      ),
      const SizedBox(height: 3),
      Text(
        label,
        style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.85)),
        textAlign: TextAlign.center,
      ),
    ],
  );
}

// ─── Share Option ─────────────────────────────────────────────────────────────

class _ShareOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ShareOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Column(
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 6),
        Text(label, style: text11(color: AppColors.textSecondary)),
      ],
    ),
  );
}

// ─── How It Works Step ────────────────────────────────────────────────────────

class _HowItWorksStep extends StatelessWidget {
  final int step;
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isLast;

  const _HowItWorksStep({
    required this.step,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) => IntrinsicHeight(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$step',
                  style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            if (!isLast)
              Expanded(
                child: Container(
                  width: 2,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  color: AppColors.grey200,
                ),
              ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 16, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text(title, style: text13(fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: text12(
                    color: AppColors.textSecondary,
                  ).copyWith(height: 1.4),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

// helper
TextStyle text22Bold({Color color = AppColors.textPrimary}) =>
    TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color);
