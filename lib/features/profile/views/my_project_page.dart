import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/profile/models/dashboard_model.dart';
import 'package:gharmb_app/features/profile/provider/dashboard_provider.dart';
import 'package:gharmb_app/features/profile/provider/profile_provider.dart';
import 'package:gharmb_app/routes/app_page.dart';
import 'package:gharmb_app/shared/snakebar/custom_snakebar.dart';
import 'package:gharmb_app/shared/widget/custom_shimmer.dart';
import 'package:go_router/go_router.dart';

class MyProjectPage extends ConsumerStatefulWidget {
  const MyProjectPage({super.key});

  @override
  ConsumerState<MyProjectPage> createState() => _MyProjectPageState();
}

class _MyProjectPageState extends ConsumerState<MyProjectPage> {
  String _filter = 'Live'; // 'Live', 'Pending', 'Rejected'

  @override
  Widget build(BuildContext context) {
    final dashboardAsync = ref.watch(dashboardDataProvider);
    final user = ref.watch(userModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: context.pop,
          child: Container(
            margin: const EdgeInsets.all(10),
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
        title: Text(
          'My Projects & Properties',
          style: text16(fontWeight: FontWeight.bold),
        ),
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          ref.invalidate(dashboardDataProvider);
          ref.invalidate(userProfileDataProvider);
          try {
            await ref.read(dashboardDataProvider.future);
          } catch (_) {}
        },
        child: dashboardAsync.when(
          loading: () => ListView(
            padding: const EdgeInsets.all(16),
            children: const [
              ShimmerBox(width: double.infinity, height: 180, borderRadius: 14),
              SizedBox(height: 18),
              ShimmerBox(width: 140, height: 20),
              SizedBox(height: 12),
              PropertyListShimmer(itemCount: 3),
            ],
          ),
          error: (err, _) => ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const SizedBox(height: 60),
              const Center(
                child: Icon(
                  Icons.error_outline,
                  size: 48,
                  color: AppColors.error,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'Failed to load projects: $err',
                  textAlign: TextAlign.center,
                  style: text14(color: AppColors.textSecondary),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () => ref.invalidate(dashboardDataProvider),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: Text('Retry', style: text14(color: AppColors.white)),
                ),
              ),
            ],
          ),
          data: (dashboardResponse) {
            final data = dashboardResponse?.data;
            final profile = data?.profile;
            final myProperties = data?.myProperties;

            List<PropertyDashboardItem> items = [];
            if (_filter == 'Live') {
              items = myProperties?.live ?? [];
            } else if (_filter == 'Pending') {
              items = myProperties?.pending ?? [];
            } else if (_filter == 'Rejected') {
              items = myProperties?.rejected ?? [];
            } else {
              items = [
                ...(myProperties?.live ?? []),
                ...(myProperties?.pending ?? []),
                ...(myProperties?.rejected ?? []),
              ];
            }

            final totalLive = myProperties?.live?.length ?? 0;
            final totalPending = myProperties?.pending?.length ?? 0;
            final totalRejected = myProperties?.rejected?.length ?? 0;

            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
              children: [
                // Real Developer/User Profile Card
                _DeveloperCard(
                  profile: profile,
                  user: user,
                  totalProjects:
                      (data?.counters?.totalListings ??
                      (totalLive + totalPending + totalRejected)),
                ),
                const SizedBox(height: 20),

                // Section Header with Add Project action
                Row(
                  children: [
                    Text(
                      'Listed Projects (${items.length})',
                      style: text16(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () =>
                          context.pushNamed(AppPage.basicDetailsName),
                      icon: const Icon(
                        Icons.add_circle_outline,
                        size: 18,
                        color: AppColors.primary,
                      ),
                      label: Text(
                        'Add Project',
                        style: text13(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Status Filter Bar
                _ProjectFilterBar(
                  selected: _filter,
                  liveCount: totalLive,
                  pendingCount: totalPending,
                  rejectedCount: totalRejected,
                  onChanged: (value) => setState(() => _filter = value),
                ),
                const SizedBox(height: 14),

                if (items.isEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 48,
                      horizontal: 20,
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.grey200),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.apartment_outlined,
                          size: 48,
                          color: AppColors.grey400,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No $_filter projects found',
                          style: text14(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'You do not have any properties listed under $_filter status.',
                          textAlign: TextAlign.center,
                          style: text12(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () =>
                              context.pushNamed(AppPage.basicDetailsName),
                          icon: const Icon(
                            Icons.add,
                            size: 16,
                            color: AppColors.white,
                          ),
                          label: Text(
                            'Post New Project',
                            style: text13(color: AppColors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ...items.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _RealProjectCard(
                        item: item,
                        onTap: () => _showProjectSheet(context, item),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ─── Real Developer Profile Card ──────────────────────────────────────────────

class _DeveloperCard extends StatelessWidget {
  final ProfileModel? profile;
  final dynamic user;
  final int totalProjects;

  const _DeveloperCard({
    required this.profile,
    required this.user,
    required this.totalProjects,
  });

  @override
  Widget build(BuildContext context) {
    final name = profile?.name ?? user?.name ?? 'User Profile';
    final location =
        profile?.address?.formattedAddress ??
        profile?.address?.city ??
        user?.address?.fullAddress ??
        'Location Not Specified';
    final phone = profile?.phone ?? user?.phone ?? '—';
    final email = profile?.email ?? user?.email ?? '—';
    final role = profile?.role ?? user?.role ?? 'Developer';
    final isVerified = profile?.isVerified ?? user?.isVerified ?? false;

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
                  Icons.business_rounded,
                  color: AppColors.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: text16(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      location,
                      style: text12(color: AppColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _Badge(label: role.toUpperCase()),
                        if (isVerified)
                          const _Badge(
                            label: 'Verified',
                            color: AppColors.success,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _DeveloperStat(value: '$totalProjects', label: 'Total Projects'),
              _SmallDivider(),
              _DeveloperStat(
                value: isVerified ? 'Verified' : 'Pending',
                label: 'Status',
              ),
              _SmallDivider(),
              _DeveloperStat(value: 'All-Time', label: 'Overview'),
            ],
          ),
          const SizedBox(height: 14),
          if (phone.isNotEmpty && phone != '—') ...[
            _InfoRow(icon: Icons.call_outlined, text: phone),
            const SizedBox(height: 6),
          ],
          if (email.isNotEmpty && email != '—')
            _InfoRow(icon: Icons.mail_outline, text: email),
        ],
      ),
    );
  }
}

// ─── Real Project Card (API Driven) ──────────────────────────────────────────

class _RealProjectCard extends StatelessWidget {
  final PropertyDashboardItem item;
  final VoidCallback onTap;

  const _RealProjectCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final status = item.statusDisplay;
    final statusColor = item.statusColor;
    final imageUrl = (item.images != null && item.images!.isNotEmpty)
        ? item.images!.first
        : '';
    final title = item.title ?? 'Untitled Project';
    final location = (item.locality?.isNotEmpty == true)
        ? '${item.locality}, ${item.city ?? ''}'
        : (item.city ?? '—');
    final price = item.formattedPrice;
    final bhk = (item.bedrooms != null && item.bedrooms!.isNotEmpty)
        ? '${item.bedrooms} BHK'
        : (item.propertyType ?? 'Property');

    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            // Banner / Image
            SizedBox(
              height: 130,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(14),
                    ),
                    child: imageUrl.isNotEmpty
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: const Color(0xFF263238),
                              child: const Icon(
                                Icons.apartment_rounded,
                                color: Colors.white24,
                                size: 48,
                              ),
                            ),
                          )
                        : Container(
                            color: const Color(0xFF263238),
                            child: const Icon(
                              Icons.apartment_rounded,
                              color: Colors.white24,
                              size: 48,
                            ),
                          ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        status,
                        style: text10(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  if (item.submissionId != null &&
                      item.submissionId!.isNotEmpty)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item.submissionId!,
                          style: text10(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: text15(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 3),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  size: 14,
                                  color: AppColors.textSecondary,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    location,
                                    style: text12(
                                      color: AppColors.textSecondary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        price,
                        style: text15(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: AppColors.grey200),
                  const SizedBox(height: 10),

                  // Stats row
                  Row(
                    children: [
                      _MiniStat(label: 'Type', value: bhk),
                      _SmallDivider(),
                      _MiniStat(
                        label: 'Carpet Area',
                        value: item.formattedArea,
                      ),
                      _SmallDivider(),
                      _MiniStat(
                        label: 'Views',
                        value: '${item.viewsCount ?? 0}',
                      ),
                      _SmallDivider(),
                      _MiniStat(
                        label: 'Tokens',
                        value: '${item.tokensCount ?? 0}',
                      ),
                    ],
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

// ─── Filter Bar ───────────────────────────────────────────────────────────────

class _ProjectFilterBar extends StatelessWidget {
  final String selected;
  final int liveCount;
  final int pendingCount;
  final int rejectedCount;
  final ValueChanged<String> onChanged;

  const _ProjectFilterBar({
    required this.selected,
    required this.liveCount,
    required this.pendingCount,
    required this.rejectedCount,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildChip('Live', liveCount),
          const SizedBox(width: 8),
          _buildChip('Pending', pendingCount),
          const SizedBox(width: 8),
          _buildChip('Rejected', rejectedCount),
          const SizedBox(width: 8),
          _buildChip('All', liveCount + pendingCount + rejectedCount),
        ],
      ),
    );
  }

  Widget _buildChip(String label, int count) {
    final isSelected = selected == label;
    return GestureDetector(
      onTap: () => onChanged(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.grey300,
          ),
        ),
        child: Text(
          '$label ($count)',
          style: text12(
            color: isSelected ? AppColors.white : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

// ─── Project Bottom Sheet ────────────────────────────────────────────────────

void _showProjectSheet(BuildContext context, PropertyDashboardItem item) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (ctx) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              item.title ?? 'Project Details',
              style: text18(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              '${item.locality ?? ''}, ${item.city ?? ''}',
              style: text13(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Price', style: text13(color: AppColors.textSecondary)),
                Text(
                  item.formattedPrice,
                  style: text15(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Status', style: text13(color: AppColors.textSecondary)),
                Text(
                  item.statusDisplay,
                  style: text13(
                    fontWeight: FontWeight.bold,
                    color: item.statusColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Submission ID',
                  style: text13(color: AppColors.textSecondary),
                ),
                Text(
                  item.submissionId ?? '—',
                  style: text13(fontWeight: FontWeight.w600),
                ),
              ],
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
                child: Text('Close', style: text14(color: AppColors.white)),
              ),
            ),
          ],
        ),
      );
    },
  );
}

// ─── Helpers ─────────────────────────────────────────────────────────────────

class _DeveloperStat extends StatelessWidget {
  final String value;
  final String label;

  const _DeveloperStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: text14(fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(label, style: text11(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;

  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: text10(color: AppColors.textSecondary)),
          const SizedBox(height: 2),
          Text(
            value,
            style: text12(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: text12(color: AppColors.textSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _SmallDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 30, color: AppColors.grey200);
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, this.color = AppColors.primary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: text10(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
