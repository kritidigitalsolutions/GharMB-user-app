import 'package:flutter/foundation.dart';
import 'package:riverpod/legacy.dart';
import 'package:gharmb_app/features/property/models/response/near_properties_response.dart';
import 'package:gharmb_app/features/property/repo/property_repo.dart';

// ─── State ────────────────────────────────────────────────────────────────────

class VerifiedPropertiesState {
  final List<Property> properties;
  final bool isLoading;
  final bool isMoreLoading;
  final bool hasMore;
  final int page;
  final int total;
  final String? error;
  final String? category;
  final String? listingFor;
  final String? propertyType;
  final String? city;
  final String? locality;
  final double? minPrice;
  final double? maxPrice;
  final String? search;

  const VerifiedPropertiesState({
    this.properties = const [],
    this.isLoading = false,
    this.isMoreLoading = false,
    this.hasMore = true,
    this.page = 1,
    this.total = 0,
    this.error,
    this.category,
    this.listingFor,
    this.propertyType,
    this.city,
    this.locality,
    this.minPrice,
    this.maxPrice,
    this.search,
  });

  VerifiedPropertiesState copyWith({
    List<Property>? properties,
    bool? isLoading,
    bool? isMoreLoading,
    bool? hasMore,
    int? page,
    int? total,
    String? error,
    bool clearError = false,
    String? category,
    String? listingFor,
    String? propertyType,
    String? city,
    String? locality,
    double? minPrice,
    double? maxPrice,
    String? search,
    bool clearCategory = false,
    bool clearListingFor = false,
    bool clearPropertyType = false,
    bool clearCity = false,
    bool clearLocality = false,
    bool clearPrice = false,
    bool clearSearch = false,
  }) {
    return VerifiedPropertiesState(
      properties: properties ?? this.properties,
      isLoading: isLoading ?? this.isLoading,
      isMoreLoading: isMoreLoading ?? this.isMoreLoading,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      total: total ?? this.total,
      error: clearError ? null : (error ?? this.error),
      category: clearCategory ? null : (category ?? this.category),
      listingFor: clearListingFor ? null : (listingFor ?? this.listingFor),
      propertyType: clearPropertyType
          ? null
          : (propertyType ?? this.propertyType),
      city: clearCity ? null : (city ?? this.city),
      locality: clearLocality ? null : (locality ?? this.locality),
      minPrice: clearPrice ? null : (minPrice ?? this.minPrice),
      maxPrice: clearPrice ? null : (maxPrice ?? this.maxPrice),
      search: clearSearch ? null : (search ?? this.search),
    );
  }
}

// ─── Notifier ─────────────────────────────────────────────────────────────────

class VerifiedPropertiesNotifier
    extends StateNotifier<VerifiedPropertiesState> {
  final PropertyRepo _repo = PropertyRepo();

  VerifiedPropertiesNotifier() : super(const VerifiedPropertiesState()) {
    fetchProperties(refresh: true);
  }

  Future<void> fetchProperties({bool refresh = false}) async {
    if (refresh) {
      state = state.copyWith(
        isLoading: true,
        page: 1,
        hasMore: true,
        clearError: true,
      );
    } else {
      if (state.isMoreLoading || !state.hasMore) return;
      state = state.copyWith(isMoreLoading: true, clearError: true);
    }

    try {
      final targetPage = refresh ? 1 : state.page + 1;
      const limit = 20;

      final res = await _repo.getVerifiedProperties(
        page: targetPage,
        limit: limit,
        category: state.category,
        listingFor: state.listingFor,
        propertyType: state.propertyType,
        city: state.city,
        locality: state.locality,
        minPrice: state.minPrice,
        maxPrice: state.maxPrice,
        search: state.search,
      );

      final newItems = res?.data.properties ?? [];
      final total = res?.totalCount ?? res?.results ?? newItems.length;

      final updatedList = refresh
          ? newItems
          : [...state.properties, ...newItems];
      final hasMore = newItems.isNotEmpty && updatedList.length < total;

      state = state.copyWith(
        isLoading: false,
        isMoreLoading: false,
        properties: updatedList,
        page: targetPage,
        total: total,
        hasMore: hasMore,
      );
    } catch (e) {
      debugPrint('❌ [VerifiedPropertiesNotifier] Error: $e');
      state = state.copyWith(
        isLoading: false,
        isMoreLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadMore() async {
    await fetchProperties(refresh: false);
  }

  Future<void> refresh() async {
    await fetchProperties(refresh: true);
  }

  void setSearch(String query) {
    state = state.copyWith(
      search: query.isEmpty ? null : query,
      clearSearch: query.isEmpty,
    );
    fetchProperties(refresh: true);
  }

  void setCategory(String? cat) {
    state = state.copyWith(
      category: cat,
      clearCategory: cat == null || cat.isEmpty,
    );
    fetchProperties(refresh: true);
  }

  void setListingFor(String? type) {
    state = state.copyWith(
      listingFor: type,
      clearListingFor: type == null || type.isEmpty,
    );
    fetchProperties(refresh: true);
  }

  void setPropertyType(String? type) {
    state = state.copyWith(
      propertyType: type,
      clearPropertyType: type == null || type.isEmpty,
    );
    fetchProperties(refresh: true);
  }

  void setCity(String? city) {
    state = state.copyWith(city: city, clearCity: city == null || city.isEmpty);
    fetchProperties(refresh: true);
  }

  void setPriceRange({double? min, double? max}) {
    state = state.copyWith(
      minPrice: min,
      maxPrice: max,
      clearPrice: min == null && max == null,
    );
    fetchProperties(refresh: true);
  }

  void clearFilters() {
    state = state.copyWith(
      clearCategory: true,
      clearListingFor: true,
      clearPropertyType: true,
      clearCity: true,
      clearLocality: true,
      clearPrice: true,
      clearSearch: true,
    );
    fetchProperties(refresh: true);
  }
}

// ─── Provider ─────────────────────────────────────────────────────────────────

final verifiedPropertiesProvider =
    StateNotifierProvider<VerifiedPropertiesNotifier, VerifiedPropertiesState>(
      (ref) => VerifiedPropertiesNotifier(),
    );
