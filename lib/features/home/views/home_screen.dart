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

  static final _propertyTypes = ['Buy', 'Rent', 'Sell', 'Apartment', 'Villa'];

  static final _properties = [
    PropertyModel(
      name: 'Skyline Heights',
      tag: 'RSBL',
      price: '₹82L',
      location: 'Sector 21, Noida',
      beds: '2 BHK',
      area: '1250 sqft',
      imageAsset: '',
    ),
    PropertyModel(
      name: 'Street Valley Vills',
      tag: '31.1Cr',
      price: '₹82L',
      location: 'Sector 44, Noida',
      beds: '3 BHK',
      area: '1800 sqft',
      imageAsset: '',
    ),
    PropertyModel(
      name: 'Skyline Heights',
      tag: 'RSBL',
      price: '₹82L',
      location: 'Sec 62, Noida',
      beds: '2 BHK',
      area: '1100 sqft',
      imageAsset: '',
    ),
  ];

  static final _commercials = [
    CommercialModel('Shop', Icons.storefront_outlined),
    CommercialModel('Office Space', Icons.business_center_outlined),
    CommercialModel('Showroom', Icons.car_repair_outlined),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                          margin: EdgeInsets.symmetric(horizontal: 12),
                          padding: EdgeInsets.symmetric(vertical: 10),
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
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: AppColors.success,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    SizedBox(width: 2),
                                    Text("Verified ·", style: text12()),
                                    SizedBox(width: 2),
                                    Text(
                                      "RERA registered · trusted",
                                      style: text12(),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              _TopDevelopersList(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        _FilterSortRow(),
                        const SizedBox(height: 16),

                        // Properties Near Me
                        _SectionHeader(
                          title: 'Properties Near Me',
                          onSeeAll: () {
                            context.pushNamed(AppPage.propertyListName);
                          },
                        ),
                        const SizedBox(height: 12),
                        _PropertiesList(properties: _properties),
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
                        _SectionHeader(
                          title: 'Real estate news',
                          subtitle: 'Stay ahead of the market',
                          onSeeAll: () {
                            context.pushNamed(AppPage.newsListName);
                          },
                        ),
                        const SizedBox(height: 12),
                        _NewsCard(),
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

class _TopBar extends StatelessWidget {
  final int filterCount;
  const _TopBar({required this.filterCount});

  @override
  Widget build(BuildContext context) {
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

class _HeroSearch extends StatelessWidget {
  final VoidCallback onFilterTap;
  const _HeroSearch({required this.onFilterTap});

  @override
  Widget build(BuildContext context) {
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
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
                      Icon(Icons.search, color: AppColors.grey, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Search localities...',
                        style: text13(color: AppColors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: onFilterTap,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.tune,
                    color: AppColors.white,
                    size: 20,
                  ),
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

class _PropertyTypeChips extends StatefulWidget {
  final List<String> types;
  const _PropertyTypeChips({required this.types});

  @override
  State<_PropertyTypeChips> createState() => _PropertyTypeChipsState();
}

class _PropertyTypeChipsState extends State<_PropertyTypeChips> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(widget.types.length, (i) {
            final sel = i == _selected;
            return GestureDetector(
              onTap: () => setState(() => _selected = i),
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
                  widget.types[i],
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

class _TopDevelopersList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 4,

        itemBuilder: (_, i) => GestureDetector(
          onTap: () {
            context.pushNamed(AppPage.developerDetailName);
          },
          child: Container(
            padding: EdgeInsets.only(right: 10),
            width: 100,
            height: 65,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),

            child: Image.asset("assets/auth/1.png", fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}

// ─── Filter Sort Row ──────────────────────────────────────────────────────────

class _FilterSortRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _SmallChip(
            label: 'Filter',
            icon: Icons.tune,
            isActive: true,
            onTap: () => _openFilter(context),
          ),
          const SizedBox(width: 8),
          _SmallChip(label: 'Sort by', icon: Icons.sort, onTap: () {}),
          const Spacer(),
          Text('1284 (2785)', style: text11(color: AppColors.textSecondary)),
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
  final List<PropertyModel> properties;
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
  final PropertyModel property;
  const _PropertyCard({required this.property});

  @override
  Widget build(BuildContext context) {
    //final idx = property.name.hashCode % 3;
    return GestureDetector(
      onTap: () {
        context.pushNamed(AppPage.propertyDetailsName);
      },
      child: Container(
        width: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.grey200),
          boxShadow: [
            // BoxShadow(
            //   color: Colors.black.withOpacity(0.08),
            //   blurRadius: 10,
            //   spreadRadius: 1,
            //   offset: const Offset(2, 0), // shadow नीचे की तरफ
            // ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      height: double.infinity,
                      "assets/builder.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.price,
                    style: text13(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    property.name,
                    style: text11(color: AppColors.textPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    property.location,
                    style: text10(color: AppColors.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.bed_outlined,
                        size: 11,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        property.beds,
                        style: text10(color: AppColors.textSecondary),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.crop_square,
                        size: 11,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        property.area,
                        style: text10(color: AppColors.textSecondary),
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

class _NewsCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () {
          final articles = ref.watch(filteredNewsProvider);
          // ref.read(selectedArticleProvider.notifier).state = articles[1];
          context.pushNamed(AppPage.newsDetailsName);
        },
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
                  borderRadius: BorderRadiusGeometry.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Image.asset(
                    width: double.infinity,
                    fit: BoxFit.cover,
                    "assets/builder.png",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'RBI holds repo rate at 6.5% — home loan EMIs will stay stable this quarter',
                      style: text12(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '3 hrs ago · 2 min read',
                      style: text10(color: AppColors.textSecondary),
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
