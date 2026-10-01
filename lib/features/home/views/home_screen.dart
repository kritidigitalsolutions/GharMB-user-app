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
import '../../property/models/response/near_properties_response.dart';
import '../../property/providers/property_listing_near_by_provider.dart';
import '../../real_state_news/models/news_response_model.dart';

// ─── Dummy Data Models ────────────────────────────────────────────────────────

class DeveloperModel {
  final String name;
  final String logoAsset;
  DeveloperModel(this.name, this.logoAsset);
}

class PropertyModel {
  final String name;
  final String tag;
  final String price;
  final String location;
  final String beds;
  final String area;
  final String imageAsset;
  PropertyModel({
    required this.name,
    required this.tag,
    required this.price,
    required this.location,
    required this.beds,
    required this.area,
    required this.imageAsset,
  });
}

class CommercialModel {
  final String name;
  final IconData icon;
  CommercialModel(this.name, this.icon);
}

class ProjectModel {
  final String name;
  final String location;
  final String tag;
  final String imageAsset;
  ProjectModel({
    required this.name,
    required this.location,
    required this.tag,
    required this.imageAsset,
  });
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

  static final _commercials = [
    CommercialModel('Shop', Icons.storefront_outlined),
    CommercialModel('Office Space', Icons.business_center_outlined),
    CommercialModel('Showroom', Icons.car_repair_outlined),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latestNewsAsync = ref.watch(filteredNewsProvider); // add this
    final nearPropertiesAsync = ref.watch(nearPropertiesProvider);
    final filterState = ref.watch(filterProvider);

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
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hero search
                        _HeroSearch(onFilterTap: () => _openFilter(context)),
                        const SizedBox(height: 14),
                        const _HomeBannerCarousel(),
                        const SizedBox(height: 14),
                        // Property type chips
                        _PropertyTypeChips(types: _propertyTypes),

                        // Top Developers
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColors.primary.withValues(alpha: 0.04),
                          ),
                          child: Column(
                            children: [
                              _SectionHeader(
                                title: 'Top developers',
                                onSeeAll: () {
                                  context.pushNamed(AppPage.topDevelopersName);
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
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
                          title: 'Properties Near Me',
                          onSeeAll: () {
                            context.pushNamed(AppPage.propertyListName);
                          },
                        ),
                        const SizedBox(height: 12),
                        nearPropertiesAsync.when(
                          loading: () => const SizedBox(
                            height: 200,
                            child: Center(child: CircularProgressIndicator()),
                          ),
                          error: (err, stack) => const SizedBox(
                            height: 200,
                            child: Center(
                              child: Text('Failed to load properties'),
                            ),
                          ),
                          data: (response) {
                            final allProperties = response?.data.properties ?? [];
                            if (allProperties.isEmpty) {
                              return const SizedBox(
                                height: 100,
                                child: Center(
                                  child: Text('No properties found nearby'),
                                ),
                              );
                            }
                            final filteredProperties = ref.watch(filteredPropertiesProvider);
                            if (filteredProperties.isEmpty) {
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 16),
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: AppColors.grey50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.grey200),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.search_off, size: 36, color: AppColors.grey),
                                    const SizedBox(height: 8),
                                    Text(
                                      'No properties match your search/filter',
                                      style: text13(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 10),
                                    ElevatedButton(
                                      onPressed: () {
                                        ref.read(searchQueryProvider.notifier).state = '';
                                        ref.read(filterProvider.notifier).clearAll();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: Text(
                                        'Reset Filters',
                                        style: text12(color: AppColors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return _PropertiesList(properties: filteredProperties);
                          },
                        ),
                        const SizedBox(height: 20),

                        // Commercial Spaces
                        _SectionHeader(
                          title: 'Commercial spaces',
                          subtitle: 'Buy all your needs for your place',
                          onSeeAll: () {
                            context.pushNamed(AppPage.commercialSpacesName);
                          },
                        ),
                        const SizedBox(height: 12),
                        _CommercialList(items: _commercials),
                        const SizedBox(height: 20),

                        // New Projects
                        _SectionHeader(
                          title: 'New Projects in Noida',
                          onSeeAll: () {
                            context.pushNamed(AppPage.myHomeName, extra: 3);
                          },
                        ),
                        const SizedBox(height: 12),
                        _NewProjectCard(),
                        const SizedBox(height: 20),

                        // Quick Access
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          loading: () => const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: SizedBox(
                              height: 200,
                              child: Center(child: CircularProgressIndicator()),
                            ),
                          ),
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
                                          .state =
                                      article.id;
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

class _HomeBannerCarousel extends StatefulWidget {
  const _HomeBannerCarousel();

  @override
  State<_HomeBannerCarousel> createState() => _HomeBannerCarouselState();
}

class _HomeBannerCarouselState extends State<_HomeBannerCarousel> {
  int _currentIndex = 0;

  static const _banners = [
    'assets/builder.png',
    'assets/builder.png',
    'assets/builder.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: _banners.length,
          itemBuilder: (context, index, realIndex) {
            return _BannerCard(
              imageAsset: _banners[index],
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
            _banners.length,
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

// ─── Top Bar ──────────────────────────────────────────────────────────────────

class _TopBar extends ConsumerWidget {
  final int filterCount;
  const _TopBar({required this.filterCount});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCount = ref.watch(unreadCountProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: AppColors.primary, size: 18),
          const SizedBox(width: 4),
          Text(
            'Noida, UP',
            style: text14(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const Icon(Icons.expand_more, color: AppColors.textPrimary, size: 18),
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
          // Container(
          //   padding: const EdgeInsets.all(8),
          //   decoration: BoxDecoration(
          //     color: AppColors.blue.withOpacity(0.12),
          //     shape: BoxShape.circle,
          //   ),
          //   child: const Icon(
          //     Icons.person_outline,
          //     color: AppColors.blue,
          //     size: 20,
          //   ),
          // ),
        ],
      ),
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
                  notifier.setPropertyTypes(sel ? {} : {PropertyType.apartment});
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
      loading: () => const SizedBox(
        height: 70,
        child: Center(child: CircularProgressIndicator()),
      ),
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
                  // Navigate to detail page – pass the developer ID
                  context.pushNamed(
                    AppPage.developerDetailName,
                    extra: dev.id, // or pathParameters
                  );
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
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        color: isSelected ? AppColors.primary : AppColors.textPrimary,
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
    final allProperties = ref.watch(nearPropertiesProvider).value?.data.properties ?? [];

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
      height: 200,
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

class _PropertyCard extends StatelessWidget {
  final Property property;
  const _PropertyCard({required this.property});

  @override
  Widget build(BuildContext context) {
    final isRent = property.listingFor.toLowerCase().contains('rent');
    final tagLabel = isRent ? 'For Rent' : 'For Sale';
    final tagBg = isRent ? AppColors.success : AppColors.blue;
    final area = property.carpetArea > 0
        ? property.carpetArea
        : property.builtUpArea;
    final priceSuffix = isRent ? '/mo' : '';
    final imageUrl = property.images.isNotEmpty ? property.images.first : null;

    return GestureDetector(
      onTap: () {
        context.pushNamed(AppPage.propertyDetailsName, extra: property.id);
      },
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.white,
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
            Stack(
              children: [
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    gradient: LinearGradient(
                      colors: _gradientForIndex(property.id),
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: imageUrl != null
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (_, _, _) => Image.asset(
                              "assets/builder.png",
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          )
                        : Image.asset(
                            "assets/builder.png",
                            fit: BoxFit.cover,
                            width: double.infinity,
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
                Positioned(
                  bottom: 6,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.favorite_border,
                      size: 14,
                      color: AppColors.textSecondary,
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
                    '₹${property.price}$priceSuffix',
                    style: text14(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    property.title,
                    style: text12(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    property.locality,
                    style: text10(color: AppColors.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (int.tryParse(property.bedrooms) != null &&
                          int.parse(property.bedrooms) > 0) ...[
                        Icon(
                          Icons.bed_outlined,
                          size: 11,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          property.bedrooms,
                          style: text10(color: AppColors.textSecondary),
                        ),
                        const SizedBox(width: 6),
                      ],
                      Icon(
                        Icons.crop_square,
                        size: 11,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '$area sqft',
                        style: text10(color: AppColors.textSecondary),
                      ),
                      const SizedBox(width: 6),
                      if (int.tryParse(property.bathrooms) != null &&
                          int.parse(property.bathrooms) > 0) ...[
                        Icon(
                          Icons.bathtub_outlined,
                          size: 11,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          property.bathrooms,
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
}
// ─── Commercial Spaces ────────────────────────────────────────────────────────

class _CommercialList extends StatelessWidget {
  final List<CommercialModel> items;
  const _CommercialList({required this.items});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, i) => GestureDetector(
          onTap: () {
            context.pushNamed(AppPage.commercialListingsName);
          },
          child: Column(
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: AppColors.primary,
                child: CircleAvatar(
                  radius: 34,
                  backgroundImage: AssetImage("assets/builder.png"),
                ),
              ),

              const SizedBox(height: 6),
              Text(
                items[i].name,
                style: text11(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── New Projects ─────────────────────────────────────────────────────────────

class _NewProjectCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () {
          context.pushNamed(AppPage.projectDetailName);
        },
        child: Container(
          height: 180,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadiusGeometry.vertical(
                        top: Radius.circular(12),
                      ),
                      child: Image.asset(
                        width: double.infinity,
                        fit: BoxFit.cover,
                        "assets/builder.png",
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'RERA Approved',
                          style: text10(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.warning,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Ready to move',
                          style: text10(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Emerald Heights',
                            style: text14(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 15,
                                color: AppColors.textSecondary,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Sector 62, Noida',
                                style: text11(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.textSecondary,
                      size: 14,
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
