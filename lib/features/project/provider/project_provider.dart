import 'package:riverpod/legacy.dart';

// ─── Models ───────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

// ─── Models ───────────────────────────────────────────────────────────────────

class ProjectModel {
  final String id;
  final String name;
  final String location;
  final String developer;
  final String startingPrice;
  final String bhkTypes;
  final int totalUnits;
  final String openSpace;
  final String possession;
  final String distance;
  final int interested;
  final bool reraApproved;
  final bool readyToMove;
  final String imageGradientKey;

  const ProjectModel({
    required this.id,
    required this.name,
    required this.location,
    required this.developer,
    required this.startingPrice,
    required this.bhkTypes,
    required this.totalUnits,
    required this.openSpace,
    required this.possession,
    required this.distance,
    required this.interested,
    required this.reraApproved,
    required this.readyToMove,
    required this.imageGradientKey,
  });
}

class PriceUnit {
  final String bhk;
  final String area;
  final String priceRange;
  final String status;
  const PriceUnit({
    required this.bhk,
    required this.area,
    required this.priceRange,
    required this.status,
  });
}

class ScoreItem {
  final String label;
  final double score;
  final double maxScore;
  const ScoreItem(this.label, this.score, this.maxScore);
}

class NearbyPlace {
  final String name;
  final String distance;
  final String colorKey;
  const NearbyPlace(this.name, this.distance, this.colorKey);
}

class GalleryTab {
  final String label;
  final int count;
  const GalleryTab(this.label, this.count);
}

// ─── Filter State ─────────────────────────────────────────────────────────────

enum ProjectBHK { two, three, four, fourPlus }

enum PossessionFilter { immediate, within6Months, within1Year, moreThan1Year }

enum ProjectSortBy { relevance, priceLow, priceHigh, newest, possession }

class ProjectFilterState {
  final Set<ProjectBHK> bhk;
  final RangeValues budgetRange;
  final bool reraOnly;
  final bool readyToMoveOnly;
  final Set<PossessionFilter> possession;
  final ProjectSortBy sortBy;

  const ProjectFilterState({
    this.bhk = const {},
    this.budgetRange = const RangeValues(20, 500),
    this.reraOnly = false,
    this.readyToMoveOnly = false,
    this.possession = const {},
    this.sortBy = ProjectSortBy.relevance,
  });

  ProjectFilterState copyWith({
    Set<ProjectBHK>? bhk,
    RangeValues? budgetRange,
    bool? reraOnly,
    bool? readyToMoveOnly,
    Set<PossessionFilter>? possession,
    ProjectSortBy? sortBy,
  }) => ProjectFilterState(
    bhk: bhk ?? this.bhk,
    budgetRange: budgetRange ?? this.budgetRange,
    reraOnly: reraOnly ?? this.reraOnly,
    readyToMoveOnly: readyToMoveOnly ?? this.readyToMoveOnly,
    possession: possession ?? this.possession,
    sortBy: sortBy ?? this.sortBy,
  );

  bool get hasActiveFilters =>
      bhk.isNotEmpty ||
      reraOnly ||
      readyToMoveOnly ||
      possession.isNotEmpty ||
      sortBy != ProjectSortBy.relevance ||
      budgetRange.start != 20 ||
      budgetRange.end != 500;

  int get activeCount {
    int c = 0;
    if (bhk.isNotEmpty) c++;
    if (reraOnly) c++;
    if (readyToMoveOnly) c++;
    if (possession.isNotEmpty) c++;
    if (sortBy != ProjectSortBy.relevance) c++;
    if (budgetRange.start != 20 || budgetRange.end != 500) c++;
    return c;
  }
}

class ProjectFilterNotifier extends StateNotifier<ProjectFilterState> {
  ProjectFilterNotifier() : super(const ProjectFilterState());

  void toggleBHK(ProjectBHK v) {
    final s = Set<ProjectBHK>.from(state.bhk);
    s.contains(v) ? s.remove(v) : s.add(v);
    state = state.copyWith(bhk: s);
  }

  void setBudget(RangeValues v) => state = state.copyWith(budgetRange: v);
  void setReraOnly(bool v) => state = state.copyWith(reraOnly: v);
  void setReadyToMove(bool v) => state = state.copyWith(readyToMoveOnly: v);

  void togglePossession(PossessionFilter v) {
    final s = Set<PossessionFilter>.from(state.possession);
    s.contains(v) ? s.remove(v) : s.add(v);
    state = state.copyWith(possession: s);
  }

  void setSortBy(ProjectSortBy v) => state = state.copyWith(sortBy: v);

  void clearAll() => state = const ProjectFilterState();
}

final projectFilterProvider =
    StateNotifierProvider<ProjectFilterNotifier, ProjectFilterState>(
      (_) => ProjectFilterNotifier(),
    );

// ─── Extensions ───────────────────────────────────────────────────────────────

extension BHKLabel on ProjectBHK {
  String get label => switch (this) {
    ProjectBHK.two => '2 BHK',
    ProjectBHK.three => '3 BHK',
    ProjectBHK.four => '4 BHK',
    ProjectBHK.fourPlus => '4+ BHK',
  };
}

extension PossessionLabel on PossessionFilter {
  String get label => switch (this) {
    PossessionFilter.immediate => 'Immediate',
    PossessionFilter.within6Months => 'Within 6 Months',
    PossessionFilter.within1Year => 'Within 1 Year',
    PossessionFilter.moreThan1Year => 'After 1 Year',
  };
}

extension SortLabel on ProjectSortBy {
  String get label => switch (this) {
    ProjectSortBy.relevance => 'Relevance',
    ProjectSortBy.priceLow => 'Price: Low to High',
    ProjectSortBy.priceHigh => 'Price: High to Low',
    ProjectSortBy.newest => 'Newest First',
    ProjectSortBy.possession => 'Earliest Possession',
  };
}

// ─── Projects Data ────────────────────────────────────────────────────────────

final _projects = [
  const ProjectModel(
    id: 'p1',
    name: 'Emerald Heights',
    location: '9 Shastri Nagar, Meerut',
    developer: 'XYZ Developers',
    startingPrice: '₹42 Lakh*',
    bhkTypes: '2/3/4',
    totalUnits: 240,
    openSpace: '70%',
    possession: 'Dec 2026',
    distance: '1.2 km from NH-58',
    interested: 128,
    reraApproved: true,
    readyToMove: true,
    imageGradientKey: 'dark_gold',
  ),
  const ProjectModel(
    id: 'p2',
    name: 'Silver Oak Residency',
    location: 'Sector 9, Meerut',
    developer: 'ABC Builders',
    startingPrice: '₹55 Lakh*',
    bhkTypes: '3/4',
    totalUnits: 180,
    openSpace: '65%',
    possession: 'Jun 2026',
    distance: '2.4 km from NH-58',
    interested: 108,
    reraApproved: false,
    readyToMove: true,
    imageGradientKey: 'dark_blue',
  ),
  const ProjectModel(
    id: 'p3',
    name: 'Green Valley Homes',
    location: 'Shastri Nagar, Meerut',
    developer: 'PQR Developers',
    startingPrice: '₹35 Lakh*',
    bhkTypes: '2/3',
    totalUnits: 320,
    openSpace: '60%',
    possession: 'Mar 2027',
    distance: '0.8 km from NH-58',
    interested: 145,
    reraApproved: true,
    readyToMove: false,
    imageGradientKey: 'dark_teal',
  ),
];

class NewProjectsState {
  final List<ProjectModel> projects;
  final bool isLoading;
  final String selectedFilter;

  const NewProjectsState({
    this.projects = const [],
    this.isLoading = false,
    this.selectedFilter = 'All',
  });

  NewProjectsState copyWith({
    List<ProjectModel>? projects,
    bool? isLoading,
    String? selectedFilter,
  }) => NewProjectsState(
    projects: projects ?? this.projects,
    isLoading: isLoading ?? this.isLoading,
    selectedFilter: selectedFilter ?? this.selectedFilter,
  );
}

class NewProjectsNotifier extends StateNotifier<NewProjectsState> {
  NewProjectsNotifier() : super(NewProjectsState(projects: _projects));

  void setFilter(String f) => state = state.copyWith(selectedFilter: f);

  Future<void> loadMore() async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 800));
    final more = _projects
        .map(
          (p) => ProjectModel(
            id: '${p.id}_extra',
            name: p.name,
            location: p.location,
            developer: p.developer,
            startingPrice: p.startingPrice,
            bhkTypes: p.bhkTypes,
            totalUnits: p.totalUnits,
            openSpace: p.openSpace,
            possession: p.possession,
            distance: p.distance,
            interested: p.interested,
            reraApproved: p.reraApproved,
            readyToMove: p.readyToMove,
            imageGradientKey: p.imageGradientKey,
          ),
        )
        .toList();
    state = state.copyWith(
      projects: [...state.projects, ...more],
      isLoading: false,
    );
  }
}

final newProjectsProvider =
    StateNotifierProvider<NewProjectsNotifier, NewProjectsState>(
      (_) => NewProjectsNotifier(),
    );

final selectedProjectProvider = StateProvider<ProjectModel?>((ref) => null);

// Detail page data
final scoreItems = [
  const ScoreItem('Connectivity', 9.2, 10),
  const ScoreItem('Rental Potential', 8.5, 10),
  const ScoreItem('Growth Potential', 9.1, 10),
  const ScoreItem('Family Living', 8.8, 10),
  const ScoreItem('Future Demand', 9.0, 10),
];

final priceUnits = [
  const PriceUnit(
    bhk: '2 BHK',
    area: '850 - 1050 sq ft',
    priceRange: '₹42L – ₹55L',
    status: 'Available',
  ),
  const PriceUnit(
    bhk: '2 BHK',
    area: '950 - 1250 sq ft',
    priceRange: '₹42L – ₹55L',
    status: 'Available',
  ),
  const PriceUnit(
    bhk: '2 BHK',
    area: '850 - 1050 sq ft',
    priceRange: '₹42L – ₹55L',
    status: 'Available',
  ),
];

final nearbyPlaces = [
  const NearbyPlace('DPS School', '0.8 km', 'blue'),
  const NearbyPlace('Metro Hospital', '1.2 km', 'red'),
  const NearbyPlace('Pacific Mall', '2.4 km', 'green'),
  const NearbyPlace('NH-58', '2.1 km', 'orange'),
];

final galleryTabs = [
  const GalleryTab('Photos', 24),
  const GalleryTab('Videos', 3),
  const GalleryTab('Drone View', 2),
  const GalleryTab('Floor Plan', 5),
];
