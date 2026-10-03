import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/home/providers/notification_provider.dart';
import 'package:gharmb_app/features/project/model/propert_response_mode.dart';
import 'package:gharmb_app/features/project/provider/all_project_provider.dart';
import 'package:gharmb_app/features/project/provider/project_provider.dart';
import 'package:gharmb_app/features/project/views/project_filter_page.dart';
import 'package:gharmb_app/routes/app_page.dart';
import 'package:gharmb_app/shared/widget/custom_shimmer.dart';
import 'package:go_router/go_router.dart';

class ProjectListPage extends ConsumerStatefulWidget {
  final String city;
  const ProjectListPage({super.key, this.city = 'All Cities'});

  @override
  ConsumerState<ProjectListPage> createState() => _ProjectListPageState();
}

class _ProjectListPageState extends ConsumerState<ProjectListPage> {
  static const _chips = [
    'All',
    '2 BHK',
    '3 BHK',
    '4 BHK',
    'Ready to Move',
    'Commercial',
    'Residential',
  ];

  late final ScrollController _scrollController;
  late final TextEditingController _searchController;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _searchController = TextEditingController();

    // If a specific city is passed on initial entry
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.city.isNotEmpty && widget.city != 'All Cities') {
        ref.read(latestProjectsProvider.notifier).setCity(widget.city);
        ref.read(projectFilterProvider.notifier).setCity(widget.city);
      }
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = ref.read(latestProjectsProvider);
      if (state.hasMore && !state.isLoadingMore && !state.isLoading) {
        ref.read(latestProjectsProvider.notifier).fetchLatestProperties();
      }
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      ref.read(latestProjectsProvider.notifier).setSearchQuery(query);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _showCitySelector() {
    final popularCities = [
      'All Cities',
      'Meerut',
      'Delhi',
      'Noida',
      'Greater Noida',
      'Gurgaon',
      'Agra',
      'Ghaziabad',
      'Faridabad',
      'Lucknow',
      'Jaipur',
      'Mumbai',
      'Bangalore',
      'Pune',
      'Hyderabad',
      'Chandigarh',
      'Ahmedabad',
      'Kolkata',
      'Chennai',
    ];

    final searchCtrl = TextEditingController();
    String searchQuery = '';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final currentCity = ref.watch(latestProjectsProvider).selectedCity;

            final filteredCities = popularCities.where((c) {
              if (searchQuery.isEmpty) return true;
              return c.toLowerCase().contains(searchQuery.toLowerCase());
            }).toList();

            return Container(
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: EdgeInsets.fromLTRB(
                20,
                16,
                20,
                MediaQuery.of(ctx).viewInsets.bottom +
                    MediaQuery.of(ctx).padding.bottom +
                    16,
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
                  Row(
                    children: [
                      const Icon(
                        Icons.location_city_rounded,
                        color: AppColors.primary,
                        size: 22,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Select City / Location',
                        style: text18(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => Navigator.pop(ctx),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Search & Custom Location TextField
                  Container(
                    height: 46,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.grey100,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.grey200),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.search,
                          color: AppColors.grey,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: searchCtrl,
                            autofocus: false,
                            onChanged: (val) =>
                                setModalState(() => searchQuery = val.trim()),
                            onSubmitted: (val) {
                              final text = val.trim();
                              if (text.isNotEmpty) {
                                ref
                                    .read(latestProjectsProvider.notifier)
                                    .setCity(text);
                                ref
                                    .read(projectFilterProvider.notifier)
                                    .setCity(text);
                                Navigator.pop(ctx);
                              }
                            },
                            decoration: const InputDecoration(
                              hintText: 'Search or type any city name...',
                              hintStyle: TextStyle(
                                color: AppColors.grey,
                                fontSize: 13,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                            style: text13(color: AppColors.textPrimary),
                          ),
                        ),
                        if (searchQuery.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              searchCtrl.clear();
                              setModalState(() => searchQuery = '');
                            },
                            child: const Icon(
                              Icons.close,
                              size: 18,
                              color: AppColors.grey,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // If user typed a custom city that isn't directly in popular list
                  if (searchQuery.isNotEmpty && filteredCities.isEmpty) ...[
                    Text(
                      'Custom Location',
                      style: text13(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () {
                        ref
                            .read(latestProjectsProvider.notifier)
                            .setCity(searchQuery);
                        ref
                            .read(projectFilterProvider.notifier)
                            .setCity(searchQuery);
                        Navigator.pop(ctx);
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.primary),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 16,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Select "$searchQuery"',
                              style: text13(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],

                  Text(
                    'Popular Cities',
                    style: text13(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),

                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(ctx).size.height * 0.35,
                    ),
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: filteredCities.map((c) {
                          final isSel =
                              currentCity.toLowerCase() == c.toLowerCase() ||
                              (currentCity.isEmpty && c == 'All Cities');
                          return GestureDetector(
                            onTap: () {
                              ref
                                  .read(latestProjectsProvider.notifier)
                                  .setCity(c);
                              ref
                                  .read(projectFilterProvider.notifier)
                                  .setCity(c);
                              Navigator.pop(ctx);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 9,
                              ),
                              decoration: BoxDecoration(
                                color: isSel
                                    ? AppColors.primary
                                    : AppColors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSel
                                      ? AppColors.primary
                                      : AppColors.grey300,
                                  width: 1.2,
                                ),
                              ),
                              child: Text(
                                c,
                                style: text13(
                                  color: isSel
                                      ? AppColors.white
                                      : AppColors.textPrimary,
                                  fontWeight: isSel
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(latestProjectsProvider);
    final notifier = ref.read(latestProjectsProvider.notifier);
    final filterState = ref.watch(projectFilterProvider);

    final properties = state.properties;
    final isLoading = state.isLoading;
    final isLoadingMore = state.isLoadingMore;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Bar ──────────────────────────────────────────────
            _TopBar(
              city: state.selectedCity,
              totalCount: state.total,
              onCityTap: _showCitySelector,
            ),

            // ── Search + Filter Row ──────────────────────────────────
            _SearchFilterRow(
              controller: _searchController,
              onChanged: _onSearchChanged,
              onClear: () {
                _searchController.clear();
                notifier.setSearchQuery('');
              },
              activeFilterCount: filterState.activeCount,
              onFilterTap: () => ProjectFilterBottomSheet.show(context),
            ),

            // ── Filter Chips ─────────────────────────────────────────
            _FilterChipsRow(
              filters: _chips,
              selected: state.selectedChip,
              onSelect: (f) => notifier.setSelectedChip(f),
            ),
            const SizedBox(height: 10),

            // ── Projects List / Shimmer / Empty ──────────────────────
            Expanded(
              child: isLoading && properties.isEmpty
                  ? const PropertyListShimmer()
                  : RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: () =>
                          notifier.fetchLatestProperties(refresh: true),
                      child: properties.isEmpty
                          ? ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.55,
                                  child: _EmptyState(
                                    error: state.error,
                                    onRetry: () => notifier
                                        .fetchLatestProperties(refresh: true),
                                    onClearFilters: () {
                                      _searchController.clear();
                                      notifier.resetFilters();
                                    },
                                  ),
                                ),
                              ],
                            )
                          : ListView.builder(
                              controller: _scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                              itemCount:
                                  properties.length +
                                  (isLoadingMore || state.error != null
                                      ? 1
                                      : 0),
                              itemBuilder: (ctx, i) {
                                if (i == properties.length) {
                                  if (isLoadingMore) {
                                    return const Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      child: Center(
                                        child: SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  if (state.error != null) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: GestureDetector(
                                        onTap: () =>
                                            notifier.fetchLatestProperties(
                                              refresh: false,
                                            ),
                                        child: Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: AppColors.white,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            border: Border.all(
                                              color: AppColors.grey300,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Failed to load more. Tap to retry',
                                              style: text13(
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                }

                                final property = properties[i];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: _ProjectCard(
                                    property: property,
                                    onTap: () {
                                      final ownerName =
                                          property.owner.name.isNotEmpty
                                          ? property.owner.name
                                          : (property.listingAs.isNotEmpty
                                                ? property.listingAs
                                                : 'Verified Developer');
                                      ref
                                          .read(
                                            selectedProjectProvider.notifier,
                                          )
                                          .state = ProjectModel(
                                        id: property.id.isNotEmpty
                                            ? property.id
                                            : property.mongoId,
                                        name: property.title.isNotEmpty
                                            ? property.title
                                            : '${property.bedrooms} BHK ${property.propertyType}',
                                        location: property.locationLabel,
                                        developer: ownerName,
                                        startingPrice:
                                            property.startingPriceLabel,
                                        bhkTypes: property.bhkLabel,
                                        totalUnits: property.tokensCount > 0
                                            ? property.tokensCount
                                            : (property.builtUpArea > 0
                                                  ? property.builtUpArea
                                                  : 100),
                                        openSpace: '70%',
                                        possession: property.possessionLabel,
                                        distance: property.locality.isNotEmpty
                                            ? property.locality
                                            : property.city,
                                        interested:
                                            property.shortlistedCount > 0
                                            ? property.shortlistedCount
                                            : property.viewsCount,
                                        reraApproved: property.isReraApproved,
                                        readyToMove: property.isReadyToMove,
                                        imageGradientKey: property.gradientKey,
                                        imageUrl: property.images.isNotEmpty
                                            ? property.images.first
                                            : null,
                                        images: property.images,
                                        amenities: property.amenities,
                                        description: property.description,
                                        ownerId: property.owner.id,
                                        ownerPhone: property.owner.phone,
                                        fullAddress: property.fullAddress,
                                        price: property.price,
                                        bathrooms: property.bathrooms,
                                        carpetArea: property.carpetArea,
                                        builtUpArea: property.builtUpArea,
                                        furnishing: property.furnishing,
                                        facing: property.facingDirection,
                                        parking: property.parking,
                                        totalFloors: property.totalFloors,
                                        floorNo: property.floorNo,
                                        allowInstallments:
                                            property.allowInstallments,
                                        installmentDetails:
                                            property.installmentDetails,
                                        tokenAmount: property.tokenAmount,
                                        isVerified: property.isVerified,
                                        property: property.toProperty(),
                                      );
                                      context.pushNamed(
                                        AppPage.projectDetailName,
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Empty state ───────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final String? error;
  final VoidCallback? onRetry;
  final VoidCallback onClearFilters;

  const _EmptyState({this.error, this.onRetry, required this.onClearFilters});

  @override
  Widget build(BuildContext context) {
    final isError = error != null && error!.isNotEmpty;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: (isError ? AppColors.error : AppColors.primary)
                    .withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isError
                    ? Icons.error_outline_rounded
                    : Icons.apartment_outlined,
                size: 48,
                color: isError ? AppColors.error : AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isError ? 'Unable to load projects' : 'No projects found',
              style: text16(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              isError
                  ? (error ??
                        'Something went wrong. Please check your connection and retry.')
                  : 'Try changing your city, search keywords or filters to see available projects.',
              style: text13(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isError && onRetry != null) ...[
                  ElevatedButton.icon(
                    icon: const Icon(
                      Icons.refresh,
                      size: 16,
                      color: AppColors.white,
                    ),
                    label: Text(
                      'Retry',
                      style: text13(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                    ),
                    onPressed: onRetry,
                  ),
                  const SizedBox(width: 10),
                ],
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.grey300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                  ),
                  onPressed: onClearFilters,
                  child: Text(
                    'Reset Filters',
                    style: text13(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
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

// ─── Top Bar ──────────────────────────────────────────────────────────────────

class _TopBar extends ConsumerWidget {
  final String city;
  final int totalCount;
  final VoidCallback onCityTap;

  const _TopBar({
    required this.city,
    required this.totalCount,
    required this.onCityTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCount = ref.watch(unreadCountProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onCityTap,
              behavior: HitTestBehavior.opaque,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'New Projects in',
                        style: text12(color: AppColors.textSecondary),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 16,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 18,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          city.isEmpty ? 'All Cities' : city,
                          style: text18(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (totalCount > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$totalCount',
                            style: text11(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              context.pushNamed(AppPage.notificationName);
            },
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.grey100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.notifications_outlined,
                    color: AppColors.textPrimary,
                    size: 20,
                  ),
                ),
                if (unreadCount > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
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

// ─── Search + Filter Row ──────────────────────────────────────────────────────

class _SearchFilterRow extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final int activeFilterCount;
  final VoidCallback onFilterTap;

  const _SearchFilterRow({
    required this.controller,
    required this.onChanged,
    required this.onClear,
    required this.activeFilterCount,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.grey200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: AppColors.hintText, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      onChanged: onChanged,
                      decoration: InputDecoration(
                        hintText: 'Search projects, builders, locality...',
                        hintStyle: text13(color: AppColors.hintText),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  if (controller.text.isNotEmpty)
                    GestureDetector(
                      onTap: onClear,
                      child: const Icon(
                        Icons.close,
                        color: AppColors.grey400,
                        size: 18,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
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
                    borderRadius: BorderRadius.circular(12),
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
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final f = filters[i];
          final sel = f.toLowerCase() == selected.toLowerCase();
          return GestureDetector(
            onTap: () => onSelect(f),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
  final PropertyModel property;
  final VoidCallback onTap;

  const _ProjectCard({required this.property, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final ownerName = property.owner.name.isNotEmpty
        ? property.owner.name
        : (property.listingAs.isNotEmpty
              ? property.listingAs
              : 'Verified Builder');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.grey100),
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
            // ── Hero Image ──────────────────────────────────────────
            Stack(
              children: [
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    gradient: _gradientFor(property.gradientKey),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: property.imageUrl.isNotEmpty
                        ? Image.network(
                            property.imageUrl,
                            width: double.infinity,
                            height: 180,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return Center(
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white.withOpacity(0.6),
                                    value: progress.expectedTotalBytes != null
                                        ? progress.cumulativeBytesLoaded /
                                              progress.expectedTotalBytes!
                                        : null,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (_, _, _) => Center(
                              child: Icon(
                                Icons.apartment_rounded,
                                size: 72,
                                color: Colors.white.withOpacity(0.15),
                              ),
                            ),
                          )
                        : Center(
                            child: Icon(
                              Icons.apartment_rounded,
                              size: 72,
                              color: Colors.white.withOpacity(0.15),
                            ),
                          ),
                  ),
                ),
                if (property.isReraApproved)
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: _BadgeChip(
                      label: '✓ Verified / RERA',
                      bg: AppColors.success,
                    ),
                  ),
                if (property.isReadyToMove)
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: _BadgeChip(
                      label: '⚡ Ready to Move',
                      bg: AppColors.warning,
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
                          property.title,
                          style: text16(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          property.locationLabel,
                          style: text12(color: AppColors.textSecondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Starting',
                        style: text10(color: AppColors.textSecondary),
                      ),
                      Text(
                        property.startingPriceLabel,
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
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
              child: Row(
                children: [
                  const Icon(
                    Icons.business_outlined,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'By $ownerName',
                      style: text13(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
                    value: property.bhkLabel,
                    label: 'Type',
                    icon: Icons.bed_outlined,
                  ),
                  _StatCell(
                    value: property.carpetArea > 0
                        ? '${property.carpetArea} sqft'
                        : (property.tokensCount > 0
                              ? '${property.tokensCount} Units'
                              : 'Standard'),
                    label: 'Area / Units',
                    icon: Icons.domain_outlined,
                  ),
                  _StatCell(
                    value: property.possessionLabel,
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
                    '${property.shortlistedCount > 0 ? property.shortlistedCount : property.viewsCount} Views / Interested',
                    style: text12(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 12,
                    color: AppColors.grey400,
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: text12(fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                label,
                style: text10(color: AppColors.textSecondary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
