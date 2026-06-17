import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/profile/provider/token_provider.dart';
import 'package:gharmb_app/routes/app_page.dart';
import 'package:gharmb_app/shared/button/custom_button.dart';
import 'package:go_router/go_router.dart';

class TokenRequestsPage extends ConsumerWidget {
  const TokenRequestsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(selectedTabProvider);
    final counts = ref.watch(tabCountsProvider);
    final filtered = ref.watch(filteredTokensProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  CustomBackButton(),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Token Requests',
                      style: text18(fontWeight: FontWeight.bold),
                    ),
                  ),
                  // Container(
                  //   padding: const EdgeInsets.all(8),
                  //   decoration: BoxDecoration(
                  //     border: Border.all(color: AppColors.grey200),
                  //     borderRadius: BorderRadius.circular(8),
                  //   ),
                  //   child: const Icon(
                  //     Icons.tune_rounded,
                  //     size: 20,
                  //     color: AppColors.primary,
                  //   ),
                  // ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Tabs ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _TabChip(
                      label: 'Pending',
                      count: counts[TokenStatus.pending] ?? 0,
                      isSelected: selectedTab == TokenStatus.pending,
                      onTap: () =>
                          ref.read(selectedTabProvider.notifier).state =
                              TokenStatus.pending,
                    ),
                    const SizedBox(width: 8),
                    _TabChip(
                      label: 'Accepted',
                      count: counts[TokenStatus.accepted] ?? 0,
                      isSelected: selectedTab == TokenStatus.accepted,
                      onTap: () =>
                          ref.read(selectedTabProvider.notifier).state =
                              TokenStatus.accepted,
                    ),
                    const SizedBox(width: 8),
                    _TabChip(
                      label: 'Rejected',
                      count: counts[TokenStatus.rejected] ?? 0,
                      isSelected: selectedTab == TokenStatus.rejected,
                      onTap: () =>
                          ref.read(selectedTabProvider.notifier).state =
                              TokenStatus.rejected,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── List ─────────────────────────────────────────
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                itemCount: filtered.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final token = filtered[i];
                  return _TokenCard(
                    token: token,
                    onView: () {
                      context.pushNamed(AppPage.tokenDetailsName);
                    },
                  );
                },
              ),
            ),

            // ── Bottom Note ──────────────────────────────────
            Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFFE082)),
              ),
              child: Text(
                'Note: Please review token requests and take action within 24–48 hours.',
                style: text12(color: const Color(0xFF8B6914)),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Tab Chip ──────────────────────────────────────────────────
class _TabChip extends StatelessWidget {
  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabChip({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.grey300,
          ),
        ),
        child: Text(
          '$label ($count)',
          style: text12(
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

// ─── Token Card ────────────────────────────────────────────────
class _TokenCard extends StatelessWidget {
  final TokenRequest token;
  final VoidCallback onView;

  const _TokenCard({required this.token, required this.onView});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              CircleAvatar(
                radius: 26,
                backgroundColor: AppColors.grey200,
                backgroundImage: token.imageUrl.isNotEmpty
                    ? NetworkImage(token.imageUrl)
                    : null,
                child: token.imageUrl.isEmpty
                    ? const Icon(
                        Icons.person,
                        color: AppColors.grey400,
                        size: 28,
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            token.name,
                            style: text14(fontWeight: FontWeight.w700),
                          ),
                        ),
                        _StatusBadge(status: token.status),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${token.profession} • ${token.familySize}',
                      style: text12(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.currency_rupee,
                          size: 11,
                          color: AppColors.textSecondary,
                        ),
                        Text(
                          '₹${token.tokenAmount} Token',
                          style: text11(color: AppColors.textSecondary),
                        ),
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 11,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          token.date,
                          style: text11(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),

                    SizedBox(
                      // width: double.infinity,
                      height: 30,
                      child: OutlinedButton(
                        onPressed: onView,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          //padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: Text(
                          'View',
                          style: text13(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Status Badge ──────────────────────────────────────────────
class _StatusBadge extends StatelessWidget {
  final TokenStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color text;
    String label;

    switch (status) {
      case TokenStatus.pending:
        bg = AppColors.warning.withOpacity(0.12);
        text = AppColors.warning;
        label = 'New';
        break;
      case TokenStatus.accepted:
        bg = AppColors.success.withOpacity(0.12);
        text = AppColors.success;
        label = 'Accepted';
        break;
      case TokenStatus.rejected:
        bg = AppColors.error.withOpacity(0.12);
        text = AppColors.error;
        label = 'Rejected';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: appTextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: text,
        ),
      ),
    );
  }
}
