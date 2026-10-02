import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/home/providers/filter_provider.dart';
import 'package:gharmb_app/features/home/views/filter_screen.dart';
import 'package:gharmb_app/features/real_state_news/providers/news_provider.dart';
import 'package:gharmb_app/routes/app_page.dart';
import 'package:go_router/go_router.dart';

import 'package:gharmb_app/features/home/providers/notification_provider.dart';
import '../../developer/providers/developer_provider.dart';
import '../../developer/providers/developer_provider.dart' as dev_provider;
import '../../property/models/response/near_properties_response.dart';
import '../../property/providers/property_listing_near_by_provider.dart';
import '../../real_state_news/models/news_response_model.dart';
import '../../wishlist/providers/wishlist_provider.dart';
import '../models/response/home_banner_response.dart';
import '../providers/banner_provider.dart';
import 'package:gharmb_app/shared/widget/custom_shimmer.dart';
import '../../commercial/providers/commercial_provider.dart';
import '../../project/provider/all_project_provider.dart';
import '../../project/provider/project_provider.dart' as proj_prov;

// ─── Commercial Category Model ────────────────────────────────────────────────

class _CommercialCategoryItem {
  final String name;
  final IconData icon;
  final CommercialCategory category;
  const _CommercialCategoryItem(this.name, this.icon, this.category);
}

// ─── Price Formatter Helper ───────────────────────────────────────────────────

String _formatPrice(int p) {
  if (p >= 10000000) {
    final cr = p / 10000000;
    return '₹${cr.toStringAsFixed(cr.truncateToDouble() == cr ? 0 : 2)} Cr';
  } else if (p >= 100000) {
    final l = p / 100000;
    return '₹${l.toStringAsFixed(l.truncateToDouble() == l ? 0 : 1)} L';
  } else if (p > 0) {
    return '₹$p';
  }
  return '₹ On Request';
}

// ─── Home Page ────────────────────────────────────────────────────────────────

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  static final _propertyTypes = [
    'All',
    'Buy',
    'Rent',
    'Sell',
    'Apartment',
    'Villa',
    'House',
  ];

  static final _commercialCategories = [
    _CommercialCategoryItem(
      'Shop / Retail',
      Icons.storefront_outlined,
      CommercialCategory.shop,
    ),
    _CommercialCategoryItem(
      'Office Space',
      Icons.business_center_outlined,
      CommercialCategory.officeSpace,
    ),
    _CommercialCategoryItem(
      'Showroom',
      Icons.car_repair_outlined,
      CommercialCategory.showroom,
    ),
    _CommercialCategoryItem(
      'Warehouse',
      Icons.warehouse_outlined,
      CommercialCategory.warehouse,
    ),
    _CommercialCategoryItem(
      'Co-working',
      Icons.groups_outlined,
      CommercialCategory.coWorking,
    ),
    _CommercialCategoryItem(
      'Industrial',
      Icons.factory_outlined,
      CommercialCategory.industrialPlot,
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latestNewsAsync = ref.watch(filteredNewsProvider);
    final nearPropertiesAsync = ref.watch(nearPropertiesProvider);
    final filterState = ref.watch(filterProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final currentLocation = ref.watch(userLocationProvider);
    final filteredProperties = ref.watch(filteredPropertiesProvider);
    final isSearchOrFilterActive =
        searchQuery.trim().isNotEmpty || filterState.activeFilterCount > 0;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(filterCount: filterState.activeFilterCount),

            // ── Scrollable Content ─────────────────────────────────────
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: () async {
                      await Future.wait([
                        Future(() => ref.refresh(homeBannersProvider)),
                        Future(() => ref.refresh(allDevelopersDataProvider)),
                        ref.read(nearPropertiesProvider.notifier).refresh(),
                        ref
                            .read(commercialProvider.notifier)
                            .fetchCommercialSpaces(refresh: true),
                        ref
                            .read(latestProjectsProvider.notifier)
                            .fetchLatestProperties(refresh: true),
                        Future(() => ref.refresh(allNewsProvider)),
                      ]);
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Hero search
                          _HeroSearch(onFilterTap: () => _openFilter(context)),
                          const SizedBox(height: 12),

                          // If Search or Filter is active, display the results immediately
                          if (isSearchOrFilterActive) ...[
                            // Property type chips
                            _PropertyTypeChips(types: _propertyTypes),
                            const SizedBox(height: 8),
                            const _FilterSortRow(),
                            const SizedBox(height: 14),

                            // Search & Filter Results Header
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        searchQuery.trim().isNotEmpty
                                            ? 'Search Results'
                                            : 'Filtered Properties',
                                        style: text16(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${filteredProperties.length} properties found',
                                        style: text12(
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  TextButton.icon(
                                    onPressed: () {
                                      ref
                                              .read(
                                                searchQueryProvider.notifier,
                                              )
                                              .state =
                                          '';
                                      ref
                                          .read(filterProvider.notifier)
                                          .clearAll();
                                    },
                                    icon: const Icon(
                                      Icons.clear_all,
                                      size: 16,
                                      color: AppColors.error,
                                    ),
                                    label: Text(
                                      'Clear All',
                                      style: text12(
                                        color: AppColors.error,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),

                            if (filteredProperties.isEmpty)
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                padding: const EdgeInsets.all(28),
                                decoration: BoxDecoration(
                                  color: AppColors.grey50,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: AppColors.grey200),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.search_off,
                                        size: 48,
                                        color: AppColors.grey,
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'No properties match your search/filter',
                                        style: text14(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'Try searching with different keywords or clearing filters',
                                        style: text12(
                                          color: AppColors.textSecondary,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 16),
                                      ElevatedButton(
                                        onPressed: () {
                                          ref
                                                  .read(
                                                    searchQueryProvider
                                                        .notifier,
                                                  )
                                                  .state =
                                              '';
                                          ref
                                              .read(filterProvider.notifier)
                                              .clearAll();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primary,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 10,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          'Reset Search & Filters',
                                          style: text12(color: AppColors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            else
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                itemCount: filteredProperties.length,
                                separatorBuilder: (_, _) =>
                                    const SizedBox(height: 14),
                                itemBuilder: (_, i) => _SearchResultCard(
                                  property: filteredProperties[i],
                                ),
                              ),
                            const SizedBox(height: 20),
                          ] else ...[
                            // Normal Home Discovery Flow
                            const _HomeBannerCarousel(),
                            const SizedBox(height: 14),
                            // Property type chips
                            _PropertyTypeChips(types: _propertyTypes),

                            // Top Developers
                            Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: AppColors.primary.withValues(
                                  alpha: 0.04,
                                ),
                              ),
                              child: Column(
                                children: [
                                  _SectionHeader(
                                    title: 'Top developers',
                                    onSeeAll: () {
                                      context.pushNamed(
                                        AppPage.topDevelopersName,
                                      );
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: const BoxDecoration(
                                            color: AppColors.success,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 2),
                                        Text("Verified ·", style: text12()),
                                        const SizedBox(width: 2),
                                        Text(
                                          "RERA registered · trusted",
                                          style: text12(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  const _TopDevelopersList(),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            const _FilterSortRow(),
                            const SizedBox(height: 16),

                            // Properties Near Me
                            _SectionHeader(
                              title: 'Properties near ${currentLocation.city}',
                              subtitle: 'Verified listings near your location',
                              onSeeAll: () {
                                context.pushNamed(AppPage.propertyListName);
                              },
                            ),
                            const SizedBox(height: 12),
                            nearPropertiesAsync.when(
                              loading: () => SizedBox(
                                height: 235,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  itemCount: 3,
                                  itemBuilder: (_, __) =>
                                      const PropertyCardShimmer(),
                                ),
                              ),
                              error: (err, stack) => Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.grey50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.grey200),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.error_outline,
                                      color: AppColors.error,
                                      size: 28,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Could not load nearby properties',
                                            style: text13(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            'Please check connection or try again',
                                            style: text11(
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => ref
                                          .read(nearPropertiesProvider.notifier)
                                          .refresh(),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 8,
                                        ),
                                        minimumSize: Size.zero,
                                      ),
                                      child: Text(
                                        'Retry',
                                        style: text11(color: AppColors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              data: (response) {
                                final allProperties =
                                    response?.data.properties ?? [];
                                if (allProperties.isEmpty) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    padding: const EdgeInsets.all(18),
                                    decoration: BoxDecoration(
                                      color: AppColors.grey50,
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: AppColors.grey200,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        const Icon(
                                          Icons.location_city_outlined,
                                          size: 36,
                                          color: AppColors.grey,
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          'No properties found in ${currentLocation.city}',
                                          style: text13(
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Try selecting another city or explore all available properties',
                                          style: text11(
                                            color: AppColors.textSecondary,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            OutlinedButton.icon(
                                              onPressed: () =>
                                                  _openLocationPicker(context),
                                              icon: const Icon(
                                                Icons.edit_location_alt,
                                                size: 14,
                                              ),
                                              label: Text(
                                                'Change City',
                                                style: text11(),
                                              ),
                                              style: OutlinedButton.styleFrom(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 6,
                                                    ),
                                                minimumSize: Size.zero,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            ElevatedButton(
                                              onPressed: () =>
                                                  context.pushNamed(
                                                    AppPage.propertyListName,
                                                  ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.primary,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 6,
                                                    ),
                                                minimumSize: Size.zero,
                                              ),
                                              child: Text(
                                                'All Properties',
                                                style: text11(
                                                  color: AppColors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                return _PropertiesList(
                                  properties: allProperties,
                                );
                              },
                            ),
                            const SizedBox(height: 20),

                            // Commercial Spaces
                            _SectionHeader(
                              title: 'Commercial spaces',
                              subtitle:
                                  'Shops, offices, showrooms & co-working',
                              onSeeAll: () {
                                context.pushNamed(AppPage.commercialSpacesName);
                              },
                            ),
                            const SizedBox(height: 12),
                            const _CommercialCategoryList(),
                            const SizedBox(height: 12),
                            const _FeaturedCommercialSpacesList(),
                            const SizedBox(height: 20),

                            // Home Middle Banner (from API)
                            const _HomeMiddleBanner(),
                            const SizedBox(height: 20),

                            // New Projects
                            _SectionHeader(
                              title: 'New Projects in ${currentLocation.city}',
                              subtitle: 'Upcoming RERA registered projects',
                              onSeeAll: () {
                                context.pushNamed(AppPage.myHomeName, extra: 3);
                              },
                            ),
                            const SizedBox(height: 12),
                            const _DynamicNewProjectsSection(),
                            const SizedBox(height: 20),
                          ],

                          // Quick Access
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Quick Access',
                                        style: text15(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      Text(
                                        'Everything you need for your property journey',
                                        style: text12(
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 12),
                          _QuickAccessGrid(),
                          const SizedBox(height: 20),

                          // Real Estate News
                          // Real Estate News
                          _SectionHeader(
                            title: 'Real estate news',
                            subtitle: 'Stay ahead of the market',
                            onSeeAll: () {
                              context.pushNamed(AppPage.newsListName);
                            },
                          ),
                          const SizedBox(height: 12),
                          latestNewsAsync.when(
                            loading: () => const NewsCardShimmer(),
                            error: (_, _) => const SizedBox.shrink(),
                            data: (articles) {
                              if (articles.isEmpty) {
                                return const SizedBox.shrink();
                              }
                              final article = articles.first;
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: _NewsCard(
                                  article: article,
                                  onTap: () {
                                    ref
                                        .read(selectedNewsIdProvider.notifier)
                                        .state = article
                                        .id;
                                    context.pushNamed(AppPage.newsDetailsName);
                                  },
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary, width: 2),
        ),
        child: ClipOval(
          child: Material(
            color: AppColors.white,
            child: InkWell(
              onTap: () {
                context.pushNamed(AppPage.searchOnMapName);
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset("assets/map.png", fit: BoxFit.contain),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeBannerCarousel extends ConsumerStatefulWidget {
  const _HomeBannerCarousel();

  @override
  ConsumerState<_HomeBannerCarousel> createState() =>
      _HomeBannerCarouselState();
}

class _HomeBannerCarouselState extends ConsumerState<_HomeBannerCarousel> {
  int _currentIndex = 0;

  static const _fallbackBanners = [
    'assets/builder.png',
    'assets/builder.png',
    'assets/builder.png',
  ];

  void _onBannerTap(BannerItem banner) {
    ref.read(bannerRepoProvider).trackBannerClick(banner.id);

    final linkType = banner.linkType.toLowerCase().trim();
    final linkValue = banner.linkValue.trim();

    if (linkType == 'category') {
      if (linkValue.toLowerCase() == 'commercial') {
        context.pushNamed(AppPage.commercialSpacesName);
      } else {
        context.pushNamed(AppPage.propertyListName);
      }
    } else if (linkType == 'screen') {
      if (linkValue == 'PostPropertyScreen' ||
          linkValue.toLowerCase().contains('post')) {
        context.pushNamed(AppPage.myHomeName, extra: 2);
      } else if (linkValue == 'CommercialListingsScreen' ||
          linkValue.toLowerCase().contains('commercial')) {
        context.pushNamed(AppPage.commercialListingsName);
      } else {
        context.pushNamed(AppPage.propertyListName);
      }
    } else {
      if (banner.title.toLowerCase().contains('commercial') ||
          banner.subtitle.toLowerCase().contains('commercial')) {
        context.pushNamed(AppPage.commercialSpacesName);
      } else {
        context.pushNamed(AppPage.propertyListName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bannersAsync = ref.watch(homeBannersProvider);

    return bannersAsync.when(
      loading: () => Container(
        height: 155,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.grey100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (_, __) => _buildFallback(),
      data: (response) {
        final heroBanners = response?.data.heroBanners ?? [];
        if (heroBanners.isEmpty) {
          return _buildFallback();
        }

        final bannerCount = heroBanners.length;
        final safeIndex = _currentIndex >= bannerCount ? 0 : _currentIndex;

        return Column(
          children: [
            CarouselSlider.builder(
              itemCount: bannerCount,
              itemBuilder: (context, index, realIndex) {
                final banner = heroBanners[index];
                return _RemoteBannerCard(
                  banner: banner,
                  onTap: () => _onBannerTap(banner),
                );
              },
              options: CarouselOptions(
                height: 155,
                viewportFraction: 0.92,
                enlargeCenterPage: true,
                enlargeFactor: 0.16,
                autoPlay: bannerCount > 1,
                autoPlayInterval: const Duration(seconds: 4),
                onPageChanged: (index, reason) {
                  setState(() => _currentIndex = index);
                },
              ),
            ),
            if (bannerCount > 1) ...[
              const SizedBox(height: 9),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  bannerCount,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: safeIndex == index ? 18 : 6,
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: safeIndex == index
                          ? AppColors.primary
                          : AppColors.grey200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildFallback() {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: _fallbackBanners.length,
          itemBuilder: (context, index, realIndex) {
            return _BannerCard(
              imageAsset: _fallbackBanners[index],
              onTap: () => context.pushNamed(AppPage.propertyListName),
            );
          },
          options: CarouselOptions(
            height: 150,
            viewportFraction: 0.92,
            enlargeCenterPage: true,
            enlargeFactor: 0.18,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            onPageChanged: (index, reason) {
              setState(() => _currentIndex = index);
            },
          ),
        ),
        const SizedBox(height: 9),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _fallbackBanners.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: _currentIndex == index ? 18 : 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: _currentIndex == index
                    ? AppColors.primary
                    : AppColors.grey200,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RemoteBannerCard extends StatelessWidget {
  final BannerItem banner;
  final VoidCallback onTap;

  const _RemoteBannerCard({required this.banner, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final imageUrl = banner.effectiveImage;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Material(
        color: AppColors.primary,
        child: InkWell(
          onTap: onTap,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (imageUrl.isNotEmpty)
                Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Image.asset('assets/builder.png', fit: BoxFit.cover),
                )
              else
                Image.asset('assets/builder.png', fit: BoxFit.cover),

              // Subtle Gradient Overlay for Text Readability
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.6),
                      Colors.black.withOpacity(0.2),
                      Colors.black.withOpacity(0.65),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),

              // Banner Content (Title, Subtitle, CTA Button)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (banner.title.isNotEmpty)
                          Text(
                            banner.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: text16(
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                        if (banner.subtitle.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            banner.subtitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: text11(color: Colors.white.withOpacity(0.9)),
                          ),
                        ],
                      ],
                    ),
                    if (banner.buttonText.isNotEmpty)
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                banner.buttonText,
                                style: text11(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.arrow_forward_rounded,
                                size: 12,
                                color: AppColors.white,
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
      ),
    );
  }
}

class _HomeMiddleBanner extends ConsumerWidget {
  const _HomeMiddleBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bannersAsync = ref.watch(homeBannersProvider);

    return bannersAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (response) {
        final middleBanners = response?.data.middleBanners ?? [];
        if (middleBanners.isEmpty) return const SizedBox.shrink();

        final banner = middleBanners.first;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            height: 140,
            child: _RemoteBannerCard(
              banner: banner,
              onTap: () {
                ref.read(bannerRepoProvider).trackBannerClick(banner.id);
                final linkType = banner.linkType.toLowerCase().trim();
                final linkValue = banner.linkValue.trim();

                if (linkType == 'screen' &&
                    (linkValue == 'PostPropertyScreen' ||
                        linkValue.toLowerCase().contains('post'))) {
                  context.pushNamed(AppPage.myHomeName, extra: 2);
                } else if (linkType == 'category' &&
                    linkValue.toLowerCase() == 'commercial') {
                  context.pushNamed(AppPage.commercialSpacesName);
                } else {
                  context.pushNamed(AppPage.propertyListName);
                }
              },
            ),
          ),
        );
      },
    );
  }
}

class _BannerCard extends StatelessWidget {
  final String imageAsset;
  final VoidCallback onTap;

  const _BannerCard({required this.imageAsset, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Material(
        color: AppColors.primary,
        child: InkWell(
          onTap: onTap,
          child: Image.asset(
            imageAsset,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

void _openFilter(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const FilterBottomSheet(),
  );
}

void _openLocationPicker(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _LocationBottomSheet(),
  );
}

// ─── Location Picker Bottom Sheet ─────────────────────────────────────────────

class _LocationBottomSheet extends ConsumerStatefulWidget {
  const _LocationBottomSheet();

  @override
  ConsumerState<_LocationBottomSheet> createState() =>
      _LocationBottomSheetState();
}

class _LocationBottomSheetState extends ConsumerState<_LocationBottomSheet> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';
  bool _isDetectingGps = false;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentLocation = ref.watch(userLocationProvider);
    final locationNotifier = ref.read(userLocationProvider.notifier);

    final filteredCities = _searchQuery.isEmpty
        ? kPopularCities
        : kPopularCities
              .where(
                (c) =>
                    c.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                    c.state.toLowerCase().contains(_searchQuery.toLowerCase()),
              )
              .toList();

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Select Location',
                style: text18(fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.grey),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Search Box
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
                const Icon(Icons.search, color: AppColors.grey, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _searchCtrl,
                    onChanged: (val) =>
                        setState(() => _searchQuery = val.trim()),
                    onSubmitted: (val) {
                      if (val.trim().isNotEmpty) {
                        locationNotifier.searchAndSelectCustomLocation(
                          val.trim(),
                        );
                        Navigator.pop(context);
                      }
                    },
                    decoration: const InputDecoration(
                      hintText: 'Search city, state, or locality...',
                      hintStyle: TextStyle(color: AppColors.grey, fontSize: 13),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    style: text13(color: AppColors.textPrimary),
                  ),
                ),
                if (_searchQuery.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      _searchCtrl.clear();
                      setState(() => _searchQuery = '');
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
          const SizedBox(height: 14),

          // Use Current Location GPS button
          InkWell(
            onTap: _isDetectingGps
                ? null
                : () async {
                    setState(() => _isDetectingGps = true);
                    final success = await locationNotifier
                        .detectLocationFromGps();
                    if (mounted) {
                      setState(() => _isDetectingGps = false);
                      if (success) {
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Could not detect location. Please check GPS & permissions.',
                            ),
                            backgroundColor: AppColors.error,
                          ),
                        );
                      }
                    }
                  },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  _isDetectingGps
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primary,
                          ),
                        )
                      : const Icon(
                          Icons.my_location,
                          color: AppColors.primary,
                          size: 20,
                        ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Use Current Location',
                          style: text13(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          'Using device GPS',
                          style: text11(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  if (currentLocation.isGps)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Active',
                        style: text11(
                          color: AppColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          Text(
            'Popular Cities',
            style: text13(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),

          // Cities Grid/Wrap
          Expanded(
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (_searchQuery.isNotEmpty && filteredCities.isEmpty)
                    InkWell(
                      onTap: () {
                        locationNotifier.searchAndSelectCustomLocation(
                          _searchQuery,
                        );
                        Navigator.pop(context);
                      },
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
                              Icons.location_city,
                              size: 16,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Search "$_searchQuery"',
                              style: text12(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ...filteredCities.map((cityPreset) {
                    final isSelected =
                        currentLocation.city.toLowerCase() ==
                        cityPreset.name.toLowerCase();
                    return GestureDetector(
                      onTap: () {
                        locationNotifier.selectCity(cityPreset);
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.grey50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.grey200,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isSelected) ...[
                              const Icon(
                                Icons.check,
                                size: 14,
                                color: AppColors.white,
                              ),
                              const SizedBox(width: 4),
                            ],
                            Text(
                              cityPreset.name,
                              style: text12(
                                color: isSelected
                                    ? AppColors.white
                                    : AppColors.textPrimary,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Top Bar ──────────────────────────────────────────────────────────────────

class _TopBar extends ConsumerWidget {
  final int filterCount;
  const _TopBar({required this.filterCount});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCount = ref.watch(unreadCountProvider);
    final location = ref.watch(userLocationProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _openLocationPicker(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.location_on,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 4),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 180),
                  child: Text(
                    location.displayName,
                    style: text14(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.textPrimary,
                  size: 20,
                ),
              ],
            ),
          ),
          const Spacer(),
          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  context.pushNamed(AppPage.notificationName);
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.notifications_outlined,
                    color: AppColors.yellow,
                    size: 20,
                  ),
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
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

// ─── Search Result Card ───────────────────────────────────────────────────────

class _SearchResultCard extends ConsumerWidget {
  final Property property;
  const _SearchResultCard({required this.property});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistState = ref.watch(wishlistProvider);
    final isWishlisted = wishlistState.items.any(
      (item) =>
          item.id == property.id ||
          (item.property != null && item.property!.id == property.id),
    );

    final isRent = property.listingFor.toLowerCase().contains('rent');
    final tagLabel = isRent ? 'For Rent' : 'For Sale';
    final tagBg = isRent ? AppColors.success : AppColors.blue;
    final area = property.carpetArea > 0
        ? property.carpetArea
        : property.builtUpArea;
    final priceSuffix = isRent ? '/month' : '';
    final imageUrl = property.images.isNotEmpty ? property.images.first : null;

    String formatPrice(int p) {
      if (p >= 10000000) {
        return '₹${(p / 10000000).toStringAsFixed(2)} Cr';
      } else if (p >= 100000) {
        return '₹${(p / 100000).toStringAsFixed(2)} L';
      } else {
        return '₹$p';
      }
    }

    return GestureDetector(
      onTap: () {
        context.pushNamed(AppPage.propertyDetailsName, extra: property.id);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.grey200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Stack
            Stack(
              children: [
                SizedBox(
                  height: 160,
                  width: double.infinity,
                  child: imageUrl != null && imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: _gradientForIndex(property.id),
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.apartment,
                                size: 48,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: _gradientForIndex(property.id),
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.apartment,
                              size: 48,
                              color: Colors.white,
                            ),
                          ),
                        ),
                ),
                // For Rent / For Sale Chip
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: tagBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      tagLabel,
                      style: text11(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Wishlist Toggle Button
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () async {
                      final success = await ref
                          .read(wishlistProvider.notifier)
                          .toggleWishlist(propertyId: property.id);
                      if (context.mounted && success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              !isWishlisted
                                  ? 'Added to wishlist!'
                                  : 'Removed from wishlist!',
                            ),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Icon(
                        isWishlisted ? Icons.favorite : Icons.favorite_border,
                        color: isWishlisted
                            ? AppColors.error
                            : AppColors.textSecondary,
                        size: 18,
                      ),
                    ),
                  ),
                ),
                if (property.owner.isVerified ||
                    property.approvalStatus.toLowerCase() == 'approved')
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.65),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.verified,
                            color: AppColors.yellow,
                            size: 13,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Verified',
                            style: text11(
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

            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${formatPrice(property.price)}$priceSuffix',
                        style: text16(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      if (property.propertyType.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            property.propertyType,
                            style: text11(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    property.title,
                    style: text14(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: AppColors.grey,
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          property.locality.isNotEmpty
                              ? '${property.locality}, ${property.city}'
                              : (property.city.isNotEmpty
                                    ? property.city
                                    : property.fullAddress),
                          style: text12(color: AppColors.textSecondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(height: 1, color: AppColors.grey100),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (property.bedrooms.isNotEmpty) ...[
                        _SearchFeatureItem(
                          icon: Icons.bed_outlined,
                          label: property.bedrooms.contains('BHK')
                              ? property.bedrooms
                              : '${property.bedrooms} BHK',
                        ),
                        const SizedBox(width: 14),
                      ],
                      if (area > 0) ...[
                        _SearchFeatureItem(
                          icon: Icons.square_foot_outlined,
                          label: '$area sq ft',
                        ),
                        const SizedBox(width: 14),
                      ],
                      if (property.furnishing.isNotEmpty)
                        _SearchFeatureItem(
                          icon: Icons.chair_outlined,
                          label: property.furnishing,
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

class _SearchFeatureItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SearchFeatureItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(label, style: text12(color: AppColors.textSecondary)),
      ],
    );
  }
}

// ─── Hero Search ──────────────────────────────────────────────────────────────

class _HeroSearch extends ConsumerStatefulWidget {
  final VoidCallback onFilterTap;
  const _HeroSearch({required this.onFilterTap});

  @override
  ConsumerState<_HeroSearch> createState() => _HeroSearchState();
}

class _HeroSearchState extends ConsumerState<_HeroSearch> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: ref.read(searchQueryProvider));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<String>(searchQueryProvider, (previous, next) {
      if (_controller.text != next) {
        _controller.text = next;
      }
    });

    final filterState = ref.watch(filterProvider);
    final currentQuery = ref.watch(searchQueryProvider);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Find your dream\nproperty today',
            style: text24(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.15),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: AppColors.grey, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          onChanged: (val) {
                            ref.read(searchQueryProvider.notifier).state = val;
                          },
                          decoration: const InputDecoration(
                            hintText: 'Search localities, properties, city...',
                            hintStyle: TextStyle(
                              color: AppColors.grey,
                              fontSize: 13,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          style: text13(color: AppColors.textPrimary),
                        ),
                      ),
                      if (currentQuery.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            _controller.clear();
                            ref.read(searchQueryProvider.notifier).state = '';
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(4),
                            child: Icon(
                              Icons.close,
                              size: 18,
                              color: AppColors.grey,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: widget.onFilterTap,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.tune,
                        color: AppColors.white,
                        size: 22,
                      ),
                    ),
                    if (filterState.activeFilterCount > 0)
                      Positioned(
                        right: -3,
                        top: -3,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.yellow,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          child: Center(
                            child: Text(
                              '${filterState.activeFilterCount}',
                              style: const TextStyle(
                                color: Colors.black,
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
        ],
      ),
    );
  }
}

// ─── Property Type Chips ──────────────────────────────────────────────────────

class _PropertyTypeChips extends ConsumerWidget {
  final List<String> types;
  const _PropertyTypeChips({required this.types});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(filterProvider);
    final notifier = ref.read(filterProvider.notifier);

    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(types.length, (i) {
            final type = types[i];
            final bool sel;
            if (type == 'All') {
              sel = filter.lookingFor.isEmpty && filter.propertyTypes.isEmpty;
            } else if (type == 'Buy') {
              sel = filter.lookingFor.contains(LookingFor.buy);
            } else if (type == 'Rent') {
              sel = filter.lookingFor.contains(LookingFor.rent);
            } else if (type == 'Sell') {
              sel = filter.lookingFor.contains(LookingFor.sell);
            } else if (type == 'Apartment') {
              sel = filter.propertyTypes.contains(PropertyType.apartment);
            } else if (type == 'Villa') {
              sel = filter.propertyTypes.contains(PropertyType.villa);
            } else if (type == 'House') {
              sel = filter.propertyTypes.contains(PropertyType.house);
            } else {
              sel = false;
            }

            return GestureDetector(
              onTap: () {
                if (type == 'All') {
                  notifier.setLookingFor({});
                  notifier.setPropertyTypes({});
                } else if (type == 'Buy') {
                  notifier.setLookingFor(sel ? {} : {LookingFor.buy});
                } else if (type == 'Rent') {
                  notifier.setLookingFor(sel ? {} : {LookingFor.rent});
                } else if (type == 'Sell') {
                  notifier.setLookingFor(sel ? {} : {LookingFor.sell});
                } else if (type == 'Apartment') {
                  notifier.setPropertyTypes(
                    sel ? {} : {PropertyType.apartment},
                  );
                } else if (type == 'Villa') {
                  notifier.setPropertyTypes(sel ? {} : {PropertyType.villa});
                } else if (type == 'House') {
                  notifier.setPropertyTypes(sel ? {} : {PropertyType.house});
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: sel ? AppColors.primary : AppColors.grey100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  type,
                  style: text13(
                    fontWeight: FontWeight.w500,
                    color: sel ? AppColors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

// ─── Section Header ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback onSeeAll;

  const _SectionHeader({
    required this.title,
    this.subtitle,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: text15(fontWeight: FontWeight.bold)),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: text12(color: AppColors.textSecondary),
                  ),
              ],
            ),
          ),
          TextButton(
            onPressed: onSeeAll,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'See All',
              style: text12(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Top Developers ───────────────────────────────────────────────────────────

class _TopDevelopersList extends ConsumerWidget {
  const _TopDevelopersList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(allDevelopersDataProvider);

    return asyncValue.when(
      loading: () => const DeveloperListShimmer(isHorizontal: true),
      error: (err, stack) => const SizedBox(
        height: 70,
        child: Center(
          child: Text(
            'Failed to load developers',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      ),
      data: (response) {
        final developers = response?.data.developers ?? [];
        final top = developers.take(4).toList();

        if (top.isEmpty) {
          return const SizedBox(
            height: 70,
            child: Center(
              child: Text(
                'No developers found',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          );
        }

        return SizedBox(
          height: 70,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: top.length,
            itemBuilder: (_, i) {
              final dev = top[i];
              return GestureDetector(
                onTap: () {
                  // Set the selected developer then navigate to detail page
                  ref
                      .read(selectedDeveloperProvider.notifier)
                      .state = dev_provider.DeveloperModel(
                    id: dev.id,
                    name: dev.companyName.isNotEmpty
                        ? dev.companyName
                        : dev.name,
                    coverage:
                        '${dev.cityOfOperation} · ${dev.projectCountDisplay}',
                    projects: dev.projectCount,
                    rating: dev.rating,
                    reviewCount: '${dev.reviewCount} reviews',
                    reraApproved: true,
                    isoCertified: true,
                    bseListed: false,
                    established: 'Est. ${dev.yearsInBusiness}',
                    unitsDelivered: 0,
                    cities: 1,
                    about:
                        '${dev.name} has been delivering quality projects across ${dev.cityOfOperation} for ${dev.yearsInBusiness}.',
                    reviews: const [],
                  );
                  context.pushNamed(AppPage.developerDetailName, extra: dev.id);
                },
                child: Container(
                  padding: const EdgeInsets.only(right: 10),
                  width: 100,
                  height: 65,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: dev.logo.isNotEmpty
                        ? Image.network(
                            dev.logo,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) =>
                                const _ConstructionLogoPlaceholder(),
                          )
                        : const _ConstructionLogoPlaceholder(),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// ─── Placeholder ────────────────────────────────────────────────────────
class _ConstructionLogoPlaceholder extends StatelessWidget {
  const _ConstructionLogoPlaceholder();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F0E8),
      child: const Center(
        child: Icon(Icons.construction, color: Color(0xFF8B6914), size: 28),
      ),
    );
  }
}
// ─── Filter Sort Row ──────────────────────────────────────────────────────────

class _FilterSortRow extends ConsumerWidget {
  const _FilterSortRow();

  void _showSortSheet(BuildContext context, WidgetRef ref) {
    final currentSort = ref.read(sortByProvider);
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: Text(
                    'Sort By',
                    style: text16(fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(),
                ...SortOption.values.map((opt) {
                  final isSelected = opt == currentSort;
                  return ListTile(
                    title: Text(
                      opt.label,
                      style: text14(
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textPrimary,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check, color: AppColors.primary)
                        : null,
                    onTap: () {
                      ref.read(sortByProvider.notifier).state = opt;
                      Navigator.pop(ctx);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(filterProvider);
    final sortBy = ref.watch(sortByProvider);
    final filteredList = ref.watch(filteredPropertiesProvider);
    final allProperties =
        ref.watch(nearPropertiesProvider).value?.data.properties ?? [];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _SmallChip(
            label: filterState.activeFilterCount > 0
                ? 'Filter (${filterState.activeFilterCount})'
                : 'Filter',
            icon: Icons.tune,
            isActive: filterState.activeFilterCount > 0,
            onTap: () => _openFilter(context),
          ),
          const SizedBox(width: 8),
          _SmallChip(
            label: sortBy == SortOption.defaultSort ? 'Sort by' : sortBy.label,
            icon: Icons.sort,
            isActive: sortBy != SortOption.defaultSort,
            onTap: () => _showSortSheet(context, ref),
          ),
          const Spacer(),
          Text(
            '${filteredList.length} (${allProperties.length})',
            style: text11(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _SmallChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _SmallChip({
    required this.label,
    required this.icon,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withOpacity(0.1)
              : AppColors.grey100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppColors.primary : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 14,
              color: isActive ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: text12(
                color: isActive ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Properties List ──────────────────────────────────────────────────────────

class _PropertiesList extends StatelessWidget {
  final List<Property> properties;
  const _PropertiesList({required this.properties});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 235,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: properties.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, i) => _PropertyCard(property: properties[i]),
      ),
    );
  }
}

class _PropertyCard extends ConsumerWidget {
  final Property property;
  const _PropertyCard({required this.property});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRent = property.listingFor.toLowerCase().contains('rent');
    final tagLabel = isRent ? 'For Rent' : 'For Sale';
    final tagBg = isRent ? AppColors.success : AppColors.blue;
    final area = property.carpetArea > 0
        ? property.carpetArea
        : property.builtUpArea;
    final priceSuffix = isRent ? '/mo' : '';
    final imageUrl = property.images.isNotEmpty ? property.images.first : null;

    final wishlistState = ref.watch(wishlistProvider);
    final isWishlisted = wishlistState.items.any(
      (item) => item.property?.id == property.id || item.id == property.id,
    );

    final displayLocality = property.locality.isNotEmpty
        ? (property.city.isNotEmpty
              ? '${property.locality}, ${property.city}'
              : property.locality)
        : (property.city.isNotEmpty ? property.city : property.fullAddress);

    return GestureDetector(
      onTap: () {
        context.pushNamed(AppPage.propertyDetailsName, extra: property.id);
      },
      child: Container(
        width: 175,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: AppColors.white,
          border: Border.all(color: AppColors.grey200.withOpacity(0.8)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 110,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _gradientForIndex(property.id),
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: imageUrl != null && imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (_, _, _) => Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: _gradientForIndex(property.id),
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.apartment,
                                size: 36,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: _gradientForIndex(property.id),
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.apartment,
                              size: 36,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: tagBg,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      tagLabel,
                      style: text10(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                if (property.owner.isVerified ||
                    property.approvalStatus.toLowerCase() == 'approved')
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.65),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.verified,
                            color: AppColors.yellow,
                            size: 11,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            'Verified',
                            style: text10(
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 6,
                  right: 8,
                  child: GestureDetector(
                    onTap: () async {
                      final added = await ref
                          .read(wishlistProvider.notifier)
                          .toggleWishlist(propertyId: property.id);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              added
                                  ? 'Added to wishlist!'
                                  : 'Removed from wishlist!',
                            ),
                            duration: const Duration(seconds: 1),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: added
                                ? AppColors.primary
                                : AppColors.textPrimary,
                          ),
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        isWishlisted ? Icons.favorite : Icons.favorite_border,
                        size: 14,
                        color: isWishlisted
                            ? AppColors.error
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_formatPrice(property.price)}$priceSuffix',
                    style: text14(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    property.title,
                    style: text12(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 1),
                  Text(
                    displayLocality,
                    style: text10(color: AppColors.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      if (property.bedrooms.isNotEmpty &&
                          property.bedrooms != '0') ...[
                        const Icon(
                          Icons.bed_outlined,
                          size: 12,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          property.bedrooms.contains('BHK')
                              ? property.bedrooms
                              : '${property.bedrooms} BHK',
                          style: text10(color: AppColors.textSecondary),
                        ),
                        const SizedBox(width: 8),
                      ],
                      if (area > 0) ...[
                        const Icon(
                          Icons.crop_square,
                          size: 12,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '$area sqft',
                          style: text10(color: AppColors.textSecondary),
                        ),
                      ],
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

List<Color> _gradientForIndex(String id) {
  final idx = id.hashCode % 6;
  const gradients = [
    [Color(0xFF1A3A5C), Color(0xFF2D6A9F)],
    [Color(0xFF1B4332), Color(0xFF40916C)],
    [Color(0xFF4A1942), Color(0xFF9B2335)],
    [Color(0xFF1A1A4E), Color(0xFF3D3DAA)],
    [Color(0xFF3B2F00), Color(0xFF8B6914)],
    [Color(0xFF002B36), Color(0xFF004D5E)],
  ];
  return gradients[idx.abs()].map((c) => c).toList();
}

// ─── Commercial Categories List ───────────────────────────────────────────────

class _CommercialCategoryList extends ConsumerWidget {
  const _CommercialCategoryList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = HomePage._commercialCategories;

    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (context, i) {
          final item = categories[i];
          return GestureDetector(
            onTap: () {
              ref.read(commercialProvider.notifier).setCategory(item.category);
              context.pushNamed(AppPage.commercialSpacesName);
            },
            child: Column(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.18),
                    ),
                  ),
                  child: Center(
                    child: Icon(item.icon, color: AppColors.primary, size: 26),
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: 72,
                  child: Text(
                    item.name,
                    style: text11(
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─── Featured Commercial Spaces List ─────────────────────────────────────────

class _FeaturedCommercialSpacesList extends ConsumerWidget {
  const _FeaturedCommercialSpacesList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commercialState = ref.watch(commercialProvider);

    if (commercialState.isLoading) {
      return SizedBox(
        height: 175,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: 3,
          itemBuilder: (_, __) => const Padding(
            padding: EdgeInsets.only(right: 12),
            child: PropertyCardShimmer(),
          ),
        ),
      );
    }

    final spaces = commercialState.properties;
    if (spaces.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 185,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: spaces.length.clamp(0, 6),
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final space = spaces[i];
          final area = space.carpetArea > 0
              ? space.carpetArea
              : space.builtUpArea;
          final isRent = space.listingFor.toLowerCase().contains('rent');
          final priceSuffix = isRent ? '/mo' : '';
          final imageUrl = space.images.isNotEmpty ? space.images.first : null;

          return GestureDetector(
            onTap: () {
              ref.read(selectedCommercialPropertyProvider.notifier).state =
                  space;
              context.pushNamed(
                AppPage.commercialPropertyDetailName,
                extra: space.id,
              );
            },
            child: Container(
              width: 160,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.grey200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 90,
                        width: double.infinity,
                        color: AppColors.grey100,
                        child: imageUrl != null && imageUrl.isNotEmpty
                            ? Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => Container(
                                  color: AppColors.primary.withOpacity(0.08),
                                  child: const Center(
                                    child: Icon(
                                      Icons.storefront,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                color: AppColors.primary.withOpacity(0.08),
                                child: const Center(
                                  child: Icon(
                                    Icons.storefront,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                      ),
                      Positioned(
                        top: 6,
                        left: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            space.propertyType.isNotEmpty
                                ? space.propertyType
                                : (isRent ? 'For Rent' : 'For Sale'),
                            style: text10(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_formatPrice(space.price)}$priceSuffix',
                          style: text13(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          space.title,
                          style: text11(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          space.locality.isNotEmpty
                              ? space.locality
                              : space.city,
                          style: text10(color: AppColors.textSecondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (area > 0) ...[
                          const SizedBox(height: 2),
                          Text(
                            '$area sq ft',
                            style: text10(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── Dynamic New Projects Section ────────────────────────────────────────────

class _DynamicNewProjectsSection extends ConsumerWidget {
  const _DynamicNewProjectsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectState = ref.watch(latestProjectsProvider);

    if (projectState.isLoading) {
      return Container(
        height: 190,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.grey100,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 2,
          ),
        ),
      );
    }

    final projects = projectState.properties;

    if (projects.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.grey200),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.domain,
                color: AppColors.primary,
                size: 28,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Explore New Projects',
                    style: text14(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Discover premier verified residential projects',
                    style: text11(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => context.pushNamed(AppPage.myHomeName, extra: 3),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('View', style: text11(color: AppColors.white)),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 220,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: projects.length.clamp(0, 6),
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (context, i) {
          final project = projects[i];
          final imageUrl = project.imageUrl;

          return GestureDetector(
            onTap: () {
              ref
                  .read(proj_prov.selectedProjectProvider.notifier)
                  .state = proj_prov.ProjectModel(
                id: project.id,
                name: project.title,
                location: project.locationLabel,
                developer: project.owner.name.isNotEmpty
                    ? project.owner.name
                    : 'GharMB Verified Partner',
                startingPrice: project.startingPriceLabel,
                bhkTypes: project.bhkLabel,
                totalUnits: project.carpetArea > 0 ? project.carpetArea : 100,
                openSpace: '70%',
                possession: project.possessionLabel,
                distance: project.locality,
                interested: project.shortlistedCount > 0
                    ? project.shortlistedCount
                    : (project.viewsCount > 0 ? project.viewsCount : 12),
                reraApproved: project.isReraApproved,
                readyToMove: project.isReadyToMove,
                imageGradientKey: project.gradientKey,
              );
              context.pushNamed(AppPage.projectDetailName);
            },
            child: Container(
              width: 250,
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.grey200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 120,
                        width: double.infinity,
                        color: AppColors.grey100,
                        child: imageUrl.isNotEmpty
                            ? Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: _gradientForIndex(project.id),
                                    ),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.apartment,
                                      size: 36,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: _gradientForIndex(project.id),
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.apartment,
                                    size: 36,
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                      ),
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Row(
                          children: [
                            if (project.isReraApproved) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.success,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  'RERA',
                                  style: text10(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                            ],
                            if (project.isReadyToMove)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.warning,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  'Ready to Move',
                                  style: text10(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            project.startingPriceLabel,
                            style: text11(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.title,
                          style: text13(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 13,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 3),
                            Expanded(
                              child: Text(
                                project.locationLabel,
                                style: text10(color: AppColors.textSecondary),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              project.bhkLabel,
                              style: text10(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
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
        },
      ),
    );
  }
}

// ─── Quick Access ─────────────────────────────────────────────────────────────

class _QuickAccessGrid extends StatelessWidget {
  const _QuickAccessGrid();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            quickAccessCard("Home Loan", "assets/quick_access/1.png", () {
              context.pushNamed(AppPage.homeLoanName);
            }),
            quickAccessCard("Interior Design", "assets/quick_access/2.png", () {
              context.pushNamed(AppPage.interiorDesignName);
            }),
            quickAccessCard("Legal Advise", "assets/quick_access/3.png", () {
              context.pushNamed(AppPage.legalAdviseName);
            }),
            quickAccessCard(
              "Packers & movers",
              "assets/quick_access/4.png",
              () {
                context.pushNamed(AppPage.packersMoverName);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget quickAccessCard(String title, String image, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: AppColors.primary,
            child: CircleAvatar(
              radius: 34,
              backgroundColor: AppColors.white,

              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: ClipOval(child: Image.asset(image, fit: BoxFit.contain)),
              ),
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 64,
            child: Text(
              title,
              style: text10(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── News Card ────────────────────────────────────────────────────────────────

// ─── News Card ─────────────────────────────────────────────────
class _NewsCard extends StatelessWidget {
  final News article;
  final VoidCallback onTap;

  const _NewsCard({required this.article, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: article.image.isNotEmpty
                    ? Image.network(
                        article.image,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) =>
                            const _NewsImagePlaceholder(),
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        },
                      )
                    : const _NewsImagePlaceholder(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.shortTitle,
                    style: text12(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${article.formattedPublishedAt} · ${article.readTimeDisplay}',
                    style: text10(color: AppColors.textSecondary),
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

class _NewsImagePlaceholder extends StatelessWidget {
  const _NewsImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A1035), Color(0xFF4A2060), Color(0xFFE8956D)],
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'THE NEW',
                style: text16(
                  fontWeight: FontWeight.w900,
                  color: AppColors.white.withOpacity(0.9),
                ),
              ),
              Text(
                'BUSINESS',
                style: text20(
                  fontWeight: FontWeight.w900,
                  color: AppColors.white.withOpacity(0.9),
                ),
              ),
              Text(
                'Era',
                style: appTextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w300,
                  color: AppColors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
