import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:gharmb_app/core/data/network/network_api_service.dart';
import 'package:gharmb_app/features/project/model/propert_response_mode.dart';
import 'package:gharmb_app/features/project/provider/project_provider.dart';
import 'package:gharmb_app/features/project/repo/project_repo.dart';

// Private to avoid collision with identically-named providers in other files
final _projectApiProvider = Provider<NetworkApiService>((ref) {
  return NetworkApiService();
});

final projectRepoProvider = Provider<ProjectRepo>((ref) {
  final api = ref.read(_projectApiProvider);
  return ProjectRepo(api);
});

// ─── Latest Projects State ────────────────────────────────────────────────────

class LatestProjectsState {
  final List<PropertyModel> properties;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final int page;
  final int total;
  final String? error;
  final String selectedCity;
  final String searchQuery;
  final String selectedChip;

  const LatestProjectsState({
    this.properties = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.page = 1,
    this.total = 0,
    this.error,
    this.selectedCity = 'All Cities',
    this.searchQuery = '',
    this.selectedChip = 'All',
  });

  LatestProjectsState copyWith({
    List<PropertyModel>? properties,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    int? page,
    int? total,
    String? error,
    bool clearError = false,
    String? selectedCity,
    String? searchQuery,
    String? selectedChip,
  }) {
    return LatestProjectsState(
      properties: properties ?? this.properties,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      total: total ?? this.total,
      error: clearError ? null : (error ?? this.error),
      selectedCity: selectedCity ?? this.selectedCity,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedChip: selectedChip ?? this.selectedChip,
    );
  }
}

// ─── Latest Projects Notifier ─────────────────────────────────────────────────

class LatestProjectsNotifier extends StateNotifier<LatestProjectsState> {
  final ProjectRepo _repo;
  final Ref _ref;

  LatestProjectsNotifier(this._repo, this._ref)
    : super(const LatestProjectsState()) {
    Future.microtask(() => fetchLatestProperties(refresh: true));
  }

  Future<void> fetchLatestProperties({
    bool refresh = false,
    ProjectFilterState? customFilter,
  }) async {
    if (refresh) {
      state = state.copyWith(
        isLoading: true,
        page: 1,
        hasMore: true,
        clearError: true,
      );
    } else {
      if (state.isLoading || state.isLoadingMore || !state.hasMore) return;
      state = state.copyWith(isLoadingMore: true, clearError: true);
    }

    try {
      final pageToFetch = refresh ? 1 : state.page + 1;
      final filter = customFilter ?? _ref.read(projectFilterProvider);

      // Determine category from selected chip
      String? category;
      if (state.selectedChip == 'Commercial') {
        category = 'Commercial';
      } else if (state.selectedChip == 'Residential') {
        category = 'Residential';
      }

      // Min/Max Price from budgetRange (in Lakhs: 10L to 500L)
      double? minPrice;
      double? maxPrice;
      if (filter!.budgetRange.start > 10) {
        minPrice = filter.budgetRange.start * 100000;
      }
      if (filter.budgetRange.end < 500) {
        maxPrice = filter.budgetRange.end * 100000;
      }

      // City filter — prefer local chip city, then filter state city
      String? cityParam;
      final citySource =
          state.selectedCity.isNotEmpty &&
              state.selectedCity.toLowerCase() != 'all' &&
              state.selectedCity.toLowerCase() != 'all cities'
          ? state.selectedCity
          : (filter.city.isNotEmpty &&
                    filter.city.toLowerCase() != 'all' &&
                    filter.city.toLowerCase() != 'all cities'
                ? filter.city
                : null);
      if (citySource != null) cityParam = citySource;

      // Search query
      final String? searchParam = state.searchQuery.trim().isNotEmpty
          ? state.searchQuery.trim()
          : null;

      final response = await _repo.getLatestProperties(
        page: pageToFetch,
        limit: 10,
        category: category,
        city: cityParam,
        minPrice: minPrice,
        maxPrice: maxPrice,
        search: searchParam,
      );

      if (response != null &&
          (response.status.toLowerCase() == 'success' ||
              response.data.properties.isNotEmpty)) {
        var newProps = List<PropertyModel>.from(response.data.properties);

        // Client-side chip filters
        if (state.selectedChip == 'Ready to Move' || filter.readyToMoveOnly) {
          newProps = newProps.where((p) => p.isReadyToMove).toList();
        }
        if (state.selectedChip == '2 BHK') {
          newProps = newProps
              .where(
                (p) => p.bedrooms.contains('2') || p.bhkLabel.contains('2'),
              )
              .toList();
        } else if (state.selectedChip == '3 BHK') {
          newProps = newProps
              .where(
                (p) => p.bedrooms.contains('3') || p.bhkLabel.contains('3'),
              )
              .toList();
        } else if (state.selectedChip == '4 BHK') {
          newProps = newProps
              .where(
                (p) => p.bedrooms.contains('4') || p.bhkLabel.contains('4'),
              )
              .toList();
        }

        // BHK filter set
        if (filter.bhk.isNotEmpty) {
          final bhkNumbers = filter.bhk
              .map((b) => b.label.replaceAll(RegExp(r'[^0-9]'), ''))
              .where((s) => s.isNotEmpty)
              .toList();
          if (bhkNumbers.isNotEmpty) {
            newProps = newProps.where((p) {
              return bhkNumbers.any(
                (n) => p.bedrooms.contains(n) || p.bhkLabel.contains(n),
              );
            }).toList();
          }
        }

        // RERA filter
        if (filter.reraOnly) {
          newProps = newProps.where((p) => p.isReraApproved).toList();
        }

        // Price range client-side filter
        if (minPrice != null) {
          newProps = newProps.where((p) => p.price >= minPrice!).toList();
        }
        if (maxPrice != null) {
          newProps = newProps.where((p) => p.price <= maxPrice!).toList();
        }

        // Sort
        if (filter.sortBy == ProjectSortBy.priceLow) {
          newProps.sort((a, b) => a.price.compareTo(b.price));
        } else if (filter.sortBy == ProjectSortBy.priceHigh) {
          newProps.sort((a, b) => b.price.compareTo(a.price));
        } else if (filter.sortBy == ProjectSortBy.newest) {
          newProps.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        }

        final allProps = refresh
            ? newProps
            : [...state.properties, ...newProps];
        final totalCount = response.total ?? allProps.length;
        final hasMoreItems =
            response.hasMore ?? (response.data.properties.length >= 10);

        state = state.copyWith(
          properties: allProps,
          isLoading: false,
          isLoadingMore: false,
          page: pageToFetch,
          total: totalCount,
          hasMore: hasMoreItems,
          clearError: true,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          isLoadingMore: false,
          error: 'Failed to load projects',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        error: e.toString(),
      );
    }
  }

  void setCity(String city) {
    if (state.selectedCity == city) return;
    state = state.copyWith(selectedCity: city);
    fetchLatestProperties(refresh: true);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    fetchLatestProperties(refresh: true);
  }

  void setSelectedChip(String chip) {
    if (state.selectedChip == chip) return;
    state = state.copyWith(selectedChip: chip);
    fetchLatestProperties(refresh: true);
  }

  void applyFilterState([ProjectFilterState? filterState]) {
    fetchLatestProperties(refresh: true, customFilter: filterState);
  }

  void resetFilters() {
    state = state.copyWith(
      selectedCity: 'All Cities',
      searchQuery: '',
      selectedChip: 'All',
    );
    _ref.read(projectFilterProvider.notifier).clearAll();
    fetchLatestProperties(refresh: true);
  }
}

// ─── Providers ────────────────────────────────────────────────────────────────

final latestProjectsProvider =
    StateNotifierProvider<LatestProjectsNotifier, LatestProjectsState>((ref) {
      final repo = ref.watch(projectRepoProvider);
      return LatestProjectsNotifier(repo, ref);
    });

// Controller for backward compatibility
final projectControllerProvider =
    AsyncNotifierProvider<ProjectController, PropertyResponse?>(
      ProjectController.new,
    );

class ProjectController extends AsyncNotifier<PropertyResponse?> {
  late final ProjectRepo _repo;

  @override
  Future<PropertyResponse?> build() async {
    _repo = ref.read(projectRepoProvider);
    return _repo.allProperties();
  }

  Future<void> loadAllProperties() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.allProperties());
  }
}
