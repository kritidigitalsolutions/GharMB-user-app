import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/project/provider/project_provider.dart';
import 'package:gharmb_app/features/project/views/project_filter_page.dart';
import 'package:gharmb_app/routes/app_page.dart';
import 'package:go_router/go_router.dart';

class ProjectListPage extends ConsumerWidget {
  final String city;
  const ProjectListPage({super.key, this.city = 'Meerut'});

  static const _filters = ['All', '2 BHK', '3 BHK', '4 BHK', 'Ready to Move'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(newProjectsProvider);
    final notifier = ref.read(newProjectsProvider.notifier);
    final filterState = ref.watch(projectFilterProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Bar ──────────────────────────────────────────────
            _TopBar(city: city),

            // ── Search + Filter Row ──────────────────────────────────
            _SearchFilterRow(
              activeFilterCount: filterState.activeCount,
              onFilterTap: () => ProjectFilterBottomSheet.show(context),
            ),

            // ── Filter Chips ─────────────────────────────────────────
            _FilterChipsRow(
              filters: _filters,
              selected: state.selectedFilter,
              onSelect: notifier.setFilter,
            ),
            const SizedBox(height: 8),

            // ── Projects List ─────────────────────────────────────────
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                itemCount: state.projects.length + 1,
                itemBuilder: (ctx, i) {
                  if (i == state.projects.length) {
                    return _LoadMoreButton(
                      isLoading: state.isLoading,
                      onTap: notifier.loadMore,
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _ProjectCard(
                      project: state.projects[i],
                      onTap: () {
                        ref.read(selectedProjectProvider.notifier).state =
                            state.projects[i];
                        context.pushNamed(AppPage.projectDetailName);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Top Bar ──────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final String city;
  const _TopBar({required this.city});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'New Projects in',
                  style: text13(color: AppColors.textSecondary),
                ),
                Text(city, style: text18(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              context.pushNamed(AppPage.notificationName);
            },
            child: Stack(
              children: [
                const Icon(
                  Icons.notifications_outlined,
                  color: AppColors.primary,
                  size: 22,
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.share_outlined,
              color: AppColors.primary,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Search + Filter Row ──────────────────────────────────────────────────────

class _SearchFilterRow extends StatelessWidget {
  final int activeFilterCount;
  final VoidCallback onFilterTap;

  const _SearchFilterRow({
    required this.activeFilterCount,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.grey200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: AppColors.hintText, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Search projects, builders, locality...',
                      overflow: TextOverflow.ellipsis,
                      style: text13(color: AppColors.hintText),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          // ── Filter Icon with active badge ────────────────────────
          GestureDetector(
            onTap: onFilterTap,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    color: activeFilterCount > 0
                        ? AppColors.primary.withOpacity(0.1)
                        : AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: activeFilterCount > 0
                          ? AppColors.primary
                          : AppColors.grey200,
                      width: activeFilterCount > 0 ? 1.5 : 1,
                    ),
                  ),
                  child: Icon(
                    Icons.tune,
                    color: activeFilterCount > 0
                        ? AppColors.primary
                        : AppColors.textSecondary,
                    size: 20,
                  ),
                ),
                // Badge showing active filter count
                if (activeFilterCount > 0)
                  Positioned(
                    top: -5,
                    right: -5,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '$activeFilterCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Filter Chips Row ─────────────────────────────────────────────────────────

class _FilterChipsRow extends StatelessWidget {
  final List<String> filters;
  final String selected;
  final ValueChanged<String> onSelect;

  const _FilterChipsRow({
    required this.filters,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final f = filters[i];
          final sel = f == selected;
          return GestureDetector(
            onTap: () => onSelect(f),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: sel ? AppColors.primary : AppColors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: sel ? AppColors.primary : AppColors.grey300,
                ),
              ),
              child: Center(
                child: Text(
                  f,
                  style: text13(
                    color: sel ? AppColors.white : AppColors.textSecondary,
                    fontWeight: sel ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── Project Card ─────────────────────────────────────────────────────────────

class _ProjectCard extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback onTap;

  const _ProjectCard({required this.project, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.grey100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero Image ──────────────────────────────────────────
            Stack(
              children: [
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    gradient: _gradientFor(project.imageGradientKey),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Image.asset(
                      'assets/builder.png',
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Center(
                        child: Icon(
                          Icons.apartment_rounded,
                          size: 72,
                          color: Colors.white.withOpacity(0.12),
                        ),
                      ),
                    ),
                  ),
                ),
                if (project.reraApproved)
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: _BadgeChip(
                      label: '✓ RERA Approved',
                      bg: AppColors.success,
                    ),
                  ),
                if (project.readyToMove)
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: _BadgeChip(
                      label: '⚡ Ready to Move',
                      bg: AppColors.yellow,
                    ),
                  ),
              ],
            ),

            // ── Card Body ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.name,
                          style: text16(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          project.location,
                          style: text12(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Starting',
                        style: text11(color: AppColors.textSecondary),
                      ),
                      Text(
                        project.startingPrice,
                        style: text16(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 14, 0),
              child: Row(
                children: [
                  const Icon(
                    Icons.person_outline,
                    size: 18,
                    color: AppColors.textPrimary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'By ${project.developer}',
                    style: text14(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: const Divider(height: 1, color: AppColors.grey100),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  _StatCell(
                    value: project.bhkTypes,
                    label: 'BHK',
                    icon: Icons.bed_outlined,
                  ),
                  _StatCell(
                    value: '${project.totalUnits}',
                    label: 'Units',
                    icon: Icons.domain_outlined,
                  ),
                  _StatCell(
                    value: project.possession,
                    label: 'Possession',
                    icon: Icons.calendar_today_outlined,
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
              child: Row(
                children: [
                  const Icon(
                    Icons.people_outline,
                    size: 14,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${project.interested} Interested',
                    style: text12(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.near_me_outlined,
                    size: 13,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    project.distance,
                    style: text11(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  LinearGradient _gradientFor(String key) {
    return switch (key) {
      'dark_blue' => const LinearGradient(
        colors: [Color(0xFF0D1B2A), Color(0xFF1B3A5C)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      'dark_teal' => const LinearGradient(
        colors: [Color(0xFF0B2027), Color(0xFF1B4332)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      _ => const LinearGradient(
        colors: [Color(0xFF1A1200), Color(0xFF3D2B00)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    };
  }
}

class _BadgeChip extends StatelessWidget {
  final String label;
  final Color bg;
  const _BadgeChip({required this.label, required this.bg});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(5),
    ),
    child: Text(
      label,
      style: text10(color: AppColors.white, fontWeight: FontWeight.bold),
    ),
  );
}

class _StatCell extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  const _StatCell({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) => Expanded(
    child: Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: text12(fontWeight: FontWeight.w600)),
            Text(label, style: text10(color: AppColors.textSecondary)),
          ],
        ),
      ],
    ),
  );
}

// ─── Load More Button ─────────────────────────────────────────────────────────

class _LoadMoreButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;
  const _LoadMoreButton({required this.isLoading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: GestureDetector(
        onTap: isLoading ? null : onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.grey300),
          ),
          child: isLoading
              ? const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  ),
                )
              : Center(
                  child: Text(
                    'Load More',
                    style: text14(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
