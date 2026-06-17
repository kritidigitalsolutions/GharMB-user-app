import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/features/profile/provider/profile_provider.dart';
import 'package:gharmb_app/routes/app_page.dart';
import 'package:go_router/go_router.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';

class MyPropertyPage extends ConsumerStatefulWidget {
  const MyPropertyPage({super.key});

  @override
  ConsumerState<MyPropertyPage> createState() => _MyPropertyPageState();
}

class _MyPropertyPageState extends ConsumerState<MyPropertyPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final properties = ref.watch(myPropertiesProvider);

    final live = properties
        .where((p) => p.status == MyPropertyStatus.live)
        .toList();
    final pending = properties
        .where((p) => p.status == MyPropertyStatus.pending)
        .toList();
    final rejected = properties
        .where((p) => p.status == MyPropertyStatus.rejected)
        .toList();

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
            Text('My Properties', style: text16(fontWeight: FontWeight.bold)),
            Text(
              '${properties.length} listings',
              style: text11(color: AppColors.textSecondary),
            ),
          ],
        ),
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(right: 16),
        //     child: GestureDetector(
        //       onTap: () => context.pushNamed('listProperty'),
        //       child: Container(
        //         padding: const EdgeInsets.symmetric(
        //           horizontal: 14,
        //           vertical: 8,
        //         ),
        //         decoration: BoxDecoration(
        //           color: AppColors.primary,
        //           borderRadius: BorderRadius.circular(8),
        //         ),
        //         child: Row(
        //           children: [
        //             const Icon(Icons.add, color: AppColors.white, size: 16),
        //             const SizedBox(width: 4),
        //             Text(
        //               'Add',
        //               style: text12(
        //                 color: AppColors.white,
        //                 fontWeight: FontWeight.w600,
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ),
        // ],
        bottom: TabBar(
          controller: _tabCtrl,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
          tabs: [
            Tab(text: 'Live (${live.length})'),
            Tab(text: 'Pending (${pending.length})'),
            Tab(text: 'Rejected (${rejected.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: [
          _PropertyList(properties: live),
          _PropertyList(properties: pending),
          _PropertyList(properties: rejected),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed('listProperty'),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: AppColors.white),
        label: Text(
          'List New Property',
          style: text13(color: AppColors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

// ─── Property List ────────────────────────────────────────────────────────────

class _PropertyList extends StatelessWidget {
  final List<MyPropertyModel> properties;
  const _PropertyList({required this.properties});

  @override
  Widget build(BuildContext context) {
    if (properties.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home_outlined, size: 64, color: AppColors.grey300),
            const SizedBox(height: 16),
            Text(
              'No properties here',
              style: text16(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 6),
            Text(
              'Tap + Add to list a new property',
              style: text13(color: AppColors.hintText),
            ),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: properties.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (_, i) => _MyPropertyCard(property: properties[i]),
    );
  }
}

// ─── My Property Card ─────────────────────────────────────────────────────────

class _MyPropertyCard extends StatelessWidget {
  final MyPropertyModel property;
  const _MyPropertyCard({required this.property});

  @override
  Widget build(BuildContext context) {
    final statusColor = switch (property.status) {
      MyPropertyStatus.live => AppColors.success,
      MyPropertyStatus.pending => AppColors.warning,
      MyPropertyStatus.rejected => AppColors.error,
    };
    final statusLabel = switch (property.status) {
      MyPropertyStatus.live => 'Live',
      MyPropertyStatus.pending => 'Pending Review',
      MyPropertyStatus.rejected => 'Rejected',
    };
    final statusIcon = switch (property.status) {
      MyPropertyStatus.live => Icons.check_circle_outline,
      MyPropertyStatus.pending => Icons.access_time_rounded,
      MyPropertyStatus.rejected => Icons.cancel_outlined,
    };

    return GestureDetector(
      onTap: () {
        context.pushNamed(AppPage.myPropertyDetailsName);
      },
      child: Container(
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
          children: [
            // ── Image + Status ─────────────────────────────────────────
            Stack(
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    gradient: _gradient(property.gradientKey),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.apartment_rounded,
                      size: 60,
                      color: Colors.white.withOpacity(0.12),
                    ),
                  ),
                ),
                // Status badge
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Icon(statusIcon, color: AppColors.white, size: 12),
                        const SizedBox(width: 4),
                        Text(
                          statusLabel,
                          style: text10(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Action menu
                Positioned(
                  top: 10,
                  right: 10,
                  child: PopupMenuButton<String>(
                    onSelected: (v) {},
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            const Icon(Icons.edit_outlined, size: 16),
                            const SizedBox(width: 8),
                            Text('Edit listing', style: text13()),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'boost',
                        child: Row(
                          children: [
                            const Icon(
                              Icons.rocket_launch_outlined,
                              size: 16,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Boost listing',
                              style: text13(color: AppColors.primary),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            const Icon(
                              Icons.delete_outline,
                              size: 16,
                              color: AppColors.error,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Delete',
                              style: text13(color: AppColors.error),
                            ),
                          ],
                        ),
                      ),
                    ],
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.more_vert,
                        color: AppColors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ── Details ─────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          property.title,
                          style: text15(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        property.price,
                        style: text14(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 13,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        property.location,
                        style: text12(color: AppColors.textSecondary),
                      ),
                      const Spacer(),
                      Text(
                        property.type,
                        style: text11(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Stats (only for live)
                  if (property.status == MyPropertyStatus.live) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.grey50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.grey100),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _StatBadge(
                            icon: Icons.visibility_outlined,
                            value: '${property.views}',
                            label: 'Views',
                          ),
                          _VDivider(),
                          _StatBadge(
                            icon: Icons.message_outlined,
                            value: '${property.enquiries}',
                            label: 'Enquiries',
                          ),
                          _VDivider(),
                          _StatBadge(
                            icon: Icons.toll_outlined,
                            value: '${property.tokens}',
                            label: 'Tokens',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Rejected reason
                  if (property.status == MyPropertyStatus.rejected) ...[
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.error.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            size: 15,
                            color: AppColors.error,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Rejected: Missing documents. Please re-submit with updated docs.',
                              style: text11(
                                color: AppColors.error,
                              ).copyWith(height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Posted on
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Row(
                      children: [
                        Text(
                          'Posted: ${property.postedOn}',
                          style: text11(color: AppColors.hintText),
                        ),
                        const Spacer(),
                        if (property.status == MyPropertyStatus.live)
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.rocket_launch_outlined,
                                    size: 13,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Boost',
                                    style: text11(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (property.status == MyPropertyStatus.rejected)
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Re-submit',
                                style: text11(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  LinearGradient _gradient(String key) => switch (key) {
    'teal' => const LinearGradient(
      colors: [Color(0xFF0B2027), Color(0xFF1B4332)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    'gold' => const LinearGradient(
      colors: [Color(0xFF3A2A00), Color(0xFF7A5A00)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    _ => const LinearGradient(
      colors: [Color(0xFF0D1B2A), Color(0xFF1B3A5C)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  };
}

class _StatBadge extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _StatBadge({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Row(
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(value, style: text13(fontWeight: FontWeight.bold)),
        ],
      ),
      const SizedBox(height: 2),
      Text(label, style: text10(color: AppColors.textSecondary)),
    ],
  );
}

class _VDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 28, color: AppColors.grey200);
}
