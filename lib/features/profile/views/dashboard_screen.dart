import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';

import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/developer/providers/register_provider.dart';
import 'package:gharmb_app/features/profile/models/dashboard_model.dart';
import 'package:gharmb_app/features/profile/models/models.dart';
import 'package:gharmb_app/features/profile/models/profile_model.dart';
import 'package:gharmb_app/features/profile/provider/dashboard_provider.dart';
import 'package:gharmb_app/features/profile/provider/profile_provider.dart'
    hide profileProvider;
import 'package:gharmb_app/features/property/repo/property_repo.dart';
import 'package:gharmb_app/routes/app_page.dart';
import 'package:gharmb_app/shared/button/custom_button.dart';
import 'package:gharmb_app/shared/snakebar/custom_snakebar.dart';
import 'package:gharmb_app/shared/widget/custom_shimmer.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardDataProvider);
    final user = ref.watch(userModelProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _handleDashboardListProperty(context, user),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: AppColors.white),
        label: Text(
          'List New Property',
          style: text13(color: AppColors.white, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: dashboardAsync.when(
          loading: () => const _DashboardLoading(),
          error: (error, _) => _DashboardError(
            message: error.toString(),
            onRetry: () => ref.invalidate(dashboardDataProvider),
          ),
          data: (response) {
            if (response == null || response.data == null) {
              return _DashboardError(
                message: 'Something went wrong. Please try again.',
                onRetry: () => ref.invalidate(dashboardDataProvider),
              );
            }
            return _DashboardBody();
          },
        ),
      ),
    );
  }
}

// ─── Body (rendered once data is loaded) ────────────────────────
class _DashboardBody extends ConsumerWidget {
  const _DashboardBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final stats = ref.watch(dashboardStatsProvider);
    final properties = ref.watch(propertiesProvider);
    final filter = ref.watch(dashboardPropertyFilterProvider);
    final filteredProperties = properties
        .where((property) => property.status == filter)
        .toList();

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(dashboardDataProvider);
        ref.invalidate(userProfileDataProvider);
        ref.invalidate(verificationStatusProvider);
        try {
          await Future.wait([
            ref.read(dashboardDataProvider.future),
            ref.read(userProfileDataProvider.future),
            ref.read(verificationStatusProvider.future),
          ]);
        } catch (_) {}
      },
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DashboardHeader(profile: profile),
                  const SizedBox(height: 20),
                  _AgentProfileCard(profile: profile),
                  const SizedBox(height: 20),
                  _StatsGrid(stats: stats),
                  const SizedBox(height: 16),
                  _TokenRequestBanner(count: stats.newTokenRequests),
                  const SizedBox(height: 24),
                  _PerformanceSection(stats: stats),
                  const SizedBox(height: 24),
                  _PropertiesHeader(),
                  const SizedBox(height: 10),
                  _StatusFilterBar(
                    selected: filter,
                    onChanged: (value) =>
                        ref
                                .read(dashboardPropertyFilterProvider.notifier)
                                .state =
                            value,
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          if (filteredProperties.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Text(
                    'No $filter properties yet',
                    style: text13(color: AppColors.textSecondary),
                  ),
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) => Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                  child: _PropertyCard(property: filteredProperties[i]),
                ),
                childCount: filteredProperties.length,
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

// ─── Loading / Error states ─────────────────────────────────────
class _DashboardLoading extends StatelessWidget {
  const _DashboardLoading();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: CustomShimmer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Card Shimmer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const ShimmerCircle(size: 60),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        ShimmerBox(width: 140, height: 18),
                        SizedBox(height: 6),
                        ShimmerBox(width: 100, height: 12),
                        SizedBox(height: 6),
                        ShimmerBox(width: 120, height: 12),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Stat Cards Shimmer
            Row(
              children: const [
                Expanded(child: ShimmerBox(height: 85, borderRadius: 14)),
                SizedBox(width: 12),
                Expanded(child: ShimmerBox(height: 85, borderRadius: 14)),
              ],
            ),
            const SizedBox(height: 16),

            // Performance Card Shimmer
            const ShimmerBox(
              width: double.infinity,
              height: 120,
              borderRadius: 16,
            ),
            const SizedBox(height: 20),

            // Properties Shimmer List
            const ShimmerBox(width: 130, height: 18),
            const SizedBox(height: 12),
            const PropertyListShimmer(itemCount: 3),
          ],
        ),
      ),
    );
  }
}

class _DashboardError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _DashboardError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: AppColors.error,
              size: 40,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: text13(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            CustomTextButton(title: 'Retry', onTap: onRetry),
          ],
        ),
      ),
    );
  }
}

// ─── Header ────────────────────────────────────────────────────
class _DashboardHeader extends StatelessWidget {
  final ProfileModel? profile;
  const _DashboardHeader({required this.profile});

  @override
  Widget build(BuildContext context) {
    final name = profile?.name?.trim();
    final firstName = (name != null && name.isNotEmpty)
        ? name.split(' ').first
        : 'there';

    return Row(
      children: [
        CustomBackButton(),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('My dashboard', style: text18(fontWeight: FontWeight.bold)),
            Text(
              'Welcome back, $firstName',
              style: text12(color: AppColors.textSecondary),
            ),
          ],
        ),
      ],
    );
  }
}

class _AgentProfileCard extends StatelessWidget {
  final ProfileModel? profile;
  const _AgentProfileCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    final name = (profile?.name?.isNotEmpty ?? false) ? profile!.name! : '—';
    final phone = (profile?.phone?.isNotEmpty ?? false) ? profile!.phone! : '—';
    final email = (profile?.email?.isNotEmpty ?? false) ? profile!.email! : '—';

    final address = profile?.address;
    final location = (address?.formattedAddress?.isNotEmpty ?? false)
        ? address!.formattedAddress!
        : [address?.city, address?.state].where((e) => e != null).join(', ');
    final displayLocation = location.isNotEmpty ? location : '—';

    final isVerified = profile?.isVerified ?? false;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.person_pin_circle_outlined,
                  color: AppColors.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: text16(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color:
                                (isVerified
                                        ? AppColors.success
                                        : AppColors.warning)
                                    .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            isVerified ? 'Verified' : 'Unverified',
                            style: text10(
                              color: isVerified
                                  ? AppColors.success
                                  : AppColors.warning,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      profile?.role != null
                          ? '${_capitalize(profile!.role!)} Profile'
                          : 'Profile',
                      style: text12(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _AgentInfoRow(icon: Icons.call_outlined, text: phone),
          const SizedBox(height: 8),
          _AgentInfoRow(icon: Icons.mail_outline, text: email),
          const SizedBox(height: 8),
          _AgentInfoRow(
            icon: Icons.location_on_outlined,
            text: displayLocation,
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => context.pushNamed(AppPage.profileEditName),
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: Text(
                'Edit Profile',
                style: text13(fontWeight: FontWeight.w700),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
}

class _AgentInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _AgentInfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textSecondary, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text, style: text12(color: AppColors.textSecondary)),
        ),
      ],
    );
  }
}

// ─── Stats Grid ────────────────────────────────────────────────
class _StatsGrid extends StatelessWidget {
  final DashboardStats stats;
  const _StatsGrid({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatTile(
          value: stats.totalListings.toString(),
          label: 'Total\nListings',
          color: AppColors.textPrimary,
        ),
        _StatTile(
          value: stats.liveListings.toString(),
          label: 'Live\nListings',
          color: AppColors.success,
        ),
        _StatTile(
          value: stats.pendingTokens.toString(),
          label: 'Pending\nTokens',
          color: AppColors.warning,
        ),
        _StatTile(
          value: stats.acceptedTokens.toString(),
          label: 'Accepted\nTokens',
          color: AppColors.info,
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  const _StatTile({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.grey200),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: text18(fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: text10(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Token Request Banner ──────────────────────────────────────
class _TokenRequestBanner extends StatelessWidget {
  final int count;
  const _TokenRequestBanner({required this.count});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(AppPage.tokenRequestedName);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.people_outline,
                color: AppColors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$count new token requests',
                    style: text14(
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                  Text(
                    'Awaiting your decision',
                    style: text11(color: AppColors.white.withOpacity(0.85)),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.white,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Performance Section ───────────────────────────────────────
class _PerformanceSection extends ConsumerWidget {
  final DashboardStats stats;
  const _PerformanceSection({required this.stats});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final period = ref.watch(selectedPeriodProvider);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Performance This Month',
              style: text14(fontWeight: FontWeight.w600),
            ),
            GestureDetector(
              onTap: () {},
              child: Row(
                children: [
                  Text(
                    period,
                    style: text12(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.primary,
                    size: 18,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            _PerfTile(
              icon: Icons.remove_red_eye_outlined,
              value: stats.views.toString(),
              label: 'Views',
              color: const Color(0xFF2D9CDB),
            ),
            _PerfTile(
              icon: Icons.favorite_border,
              value: stats.shortlisted.toString(),
              label: 'Shortlisted',
              color: AppColors.error,
            ),
            _PerfTile(
              icon: Icons.chat_bubble_outline,
              value: stats.inquiries.toString(),
              label: 'Inquiries',
              color: AppColors.info,
            ),
            _PerfTile(
              icon: Icons.monetization_on_outlined,
              value: stats.tokenReceived.toString(),
              label: 'Token\nReceived',
              color: AppColors.warning,
            ),
          ],
        ),
      ],
    );
  }
}

class _PerfTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  const _PerfTile({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.grey200),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(value, style: text16(fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Text(
              label,
              style: text10(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Properties Header ─────────────────────────────────────────
class _PropertiesHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('My Properties', style: text15(fontWeight: FontWeight.w700));
  }
}

// ─── Status Filter Bar ──────────────────────────────────────────
class _StatusFilterBar extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const _StatusFilterBar({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: ['Live', 'Pending', 'Rejected'].map((status) {
        final isSelected = selected == status;
        return GestureDetector(
          onTap: () => onChanged(status),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.grey300,
              ),
            ),
            child: Text(
              status,
              style: text12(
                color: isSelected ? AppColors.white : AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─── Property Card ─────────────────────────────────────────────
// ─── Property Card ─────────────────────────────────────────────
class _PropertyCard extends ConsumerStatefulWidget {
  final PropertyModel property;
  const _PropertyCard({required this.property});

  @override
  ConsumerState<_PropertyCard> createState() => _PropertyCardState();
}

class _PropertyCardState extends ConsumerState<_PropertyCard> {
  late bool _keyHandover;
  bool _isToggling = false;

  @override
  void initState() {
    super.initState();
    _keyHandover = widget.property.keyHandover;
  }

  @override
  void didUpdateWidget(covariant _PropertyCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.property.keyHandover != widget.property.keyHandover) {
      _keyHandover = widget.property.keyHandover;
    }
  }

  Future<void> _toggleKeyHandover() async {
    if (_isToggling) return;
    final newValue = !_keyHandover;
    setState(() {
      _isToggling = true;
      _keyHandover = newValue;
    });

    final success = await PropertyRepo().toggleKeyHandover(
      propertyId: widget.property.id,
      keyHandover: newValue,
    );

    if (mounted) {
      setState(() {
        _isToggling = false;
        if (!success) {
          _keyHandover = !newValue; // revert
        }
      });

      if (success) {
        AppSnackBar.showSuccess(
          context,
          title: 'Key Handover',
          message: newValue
              ? 'Key Handover is now Ready.'
              : 'Key Handover disabled.',
        );
      } else {
        AppSnackBar.showError(
          context,
          title: 'Update Failed',
          message: 'Failed to update Key Handover.',
        );
      }

      if (success) {
        ref.invalidate(dashboardDataProvider);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          AppPage.myPropertyDetailsName,
          extra: widget.property.id,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
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
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: widget.property.imageUrl.isNotEmpty
                      ? Image.network(
                          widget.property.imageUrl,
                          width: 80,
                          height: 70,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => _placeholderImage(),
                        )
                      : _placeholderImage(),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.property.title,
                              style: text13(fontWeight: FontWeight.w600),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          _PropertyStatusBadge(status: widget.property.status),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.property.location,
                        style: text11(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _PropStat(
                            icon: Icons.remove_red_eye_outlined,
                            value: widget.property.views.toString(),
                          ),
                          const SizedBox(width: 12),
                          _PropStat(
                            icon: Icons.favorite_border,
                            value: '${widget.property.shortlisted} Shortlisted',
                          ),
                          const SizedBox(width: 12),
                          _PropStat(
                            icon: Icons.people_outline,
                            value: '${widget.property.tokens} Tokens',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 16, color: AppColors.grey200),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.vpn_key_rounded,
                      size: 16,
                      color: _keyHandover
                          ? AppColors.primary
                          : AppColors.grey500,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Key Handover Ready',
                      style: text12(
                        fontWeight: FontWeight.w600,
                        color: _keyHandover
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: _keyHandover,
                    activeColor: AppColors.primary,
                    onChanged: _isToggling ? null : (_) => _toggleKeyHandover(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      width: 80,
      height: 70,
      color: AppColors.grey200,
      child: const Icon(Icons.apartment_outlined, color: AppColors.grey400),
    );
  }
}

class _PropStat extends StatelessWidget {
  final IconData icon;
  final String value;
  const _PropStat({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 12, color: AppColors.textSecondary),
        const SizedBox(width: 3),
        Text(value, style: text10(color: AppColors.textSecondary)),
      ],
    );
  }
}

class _PropertyStatusBadge extends StatelessWidget {
  final String status;

  const _PropertyStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      'Live' => AppColors.success,
      'Pending' => AppColors.warning,
      _ => AppColors.error,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: text10(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}

void _handleDashboardListProperty(BuildContext context, UserModel? user) {
  if (user?.isBuilderUnderReview == true) {
    _showDashboardUnderReviewModal(
      context,
      role: 'Developer / Builder',
      message:
          'Aapke Developer documents review ke under hain. Admin verification approve hone ke baad hi aap projects & property listing kar sakte hain.',
    );
    return;
  }
  if (user?.isAgentUnderReview == true) {
    _showDashboardUnderReviewModal(
      context,
      role: 'Agent / Broker',
      message:
          'Aapke Agent documents review ke under hain. Admin verification approve hone ke baad hi aap properties list kar sakte hain.',
    );
    return;
  }
  if (user?.isBuilderVerified != true && user?.isAgentVerified != true) {
    context.pushNamed(
      AppPage.devRegisterStep1Name,
      extra: RegistrationType.developer,
    );
    return;
  }
  context.pushNamed(AppPage.basicDetailsName);
}

void _showDashboardUnderReviewModal(
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
            style: text13(color: AppColors.textSecondary),
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
                    context.pushNamed(AppPage.myHome);
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
