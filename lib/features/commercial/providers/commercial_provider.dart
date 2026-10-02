import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/legacy.dart';
import 'package:gharmb_app/features/commercial/repo/commercial_repo.dart';
import 'package:gharmb_app/features/property/models/response/near_properties_response.dart';

// ─── Enums ────────────────────────────────────────────────────────────────────

enum CommercialMode { buy, rent }

enum CommercialCategory {
  shop,
  officeSpace,
  showroom,
  warehouse,
  coWorking,
  industrialPlot,
}

// ─── Extensions ──────────────────────────────────────────────────────────────

extension CatLabel on CommercialCategory {
  String get label => switch (this) {
    CommercialCategory.shop => 'Shop / Retail',
    CommercialCategory.officeSpace => 'Office Space',
    CommercialCategory.showroom => 'Showroom',
    CommercialCategory.warehouse => 'Warehouse',
    CommercialCategory.coWorking => 'Co-working',
    CommercialCategory.industrialPlot => 'Industrial Plot',
  };

  String get apiKey => switch (this) {
    CommercialCategory.shop => 'Shop / Retail',
    CommercialCategory.officeSpace => 'Office Space',
    CommercialCategory.showroom => 'Showroom',
    CommercialCategory.warehouse => 'Warehouse',
    CommercialCategory.coWorking => 'Co-working',
    CommercialCategory.industrialPlot => 'Industrial Plot',
  };
}

// ─── State ────────────────────────────────────────────────────────────────────

class CommercialState {
  final CommercialMode mode;
  final CommercialCategory? selectedCategory;
  final List<Property> properties;
  final bool isLoading;
  final bool isMoreLoading;
  final bool hasMore;
  final int page;
  final int totalCount;
  final String? errorMessage;
  final Property? selectedProperty;

  const CommercialState({
    this.mode = CommercialMode.buy,
    this.selectedCategory,
    this.properties = const [],
    this.isLoading = false,
    this.isMoreLoading = false,
    this.hasMore = true,
    this.page = 1,
    this.totalCount = 0,
    this.errorMessage,
    this.selectedProperty,
  });

  CommercialState copyWith({
    CommercialMode? mode,
    CommercialCategory? selectedCategory,
    bool clearCategory = false,
    List<Property>? properties,
    bool? isLoading,
    bool? isMoreLoading,
    bool? hasMore,
    int? page,
    int? totalCount,
    String? errorMessage,
    bool clearError = false,
    Property? selectedProperty,
  }) => CommercialState(
    mode: mode ?? this.mode,
    selectedCategory: clearCategory ? null : (selectedCategory ?? this.selectedCategory),
    properties: properties ?? this.properties,
    isLoading: isLoading ?? this.isLoading,
    isMoreLoading: isMoreLoading ?? this.isMoreLoading,
    hasMore: hasMore ?? this.hasMore,
    page: page ?? this.page,
    totalCount: totalCount ?? this.totalCount,
    errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    selectedProperty: selectedProperty ?? this.selectedProperty,
  );
}

// ─── Notifier ─────────────────────────────────────────────────────────────────

class CommercialNotifier extends StateNotifier<CommercialState> {
  final CommercialRepo _repo = CommercialRepo();

  CommercialNotifier() : super(const CommercialState()) {
    fetchCommercialSpaces(refresh: true);
  }

  void setMode(CommercialMode m) {
    if (state.mode == m) return;
    state = state.copyWith(mode: m);
    fetchCommercialSpaces(refresh: true);
  }

  void setCategory(CommercialCategory? c) {
    if (state.selectedCategory == c) return;
    state = state.copyWith(
      selectedCategory: c,
      clearCategory: c == null,
    );
    fetchCommercialSpaces(refresh: true);
  }

  void selectProperty(Property p) {
    state = state.copyWith(selectedProperty: p);
  }

  String get _listingForParam => state.mode == CommercialMode.buy ? 'Sale' : 'Rent';

  Future<void> fetchCommercialSpaces({bool refresh = false}) async {
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
      final propertyType = state.selectedCategory?.apiKey;

      final res = await _repo.getCommercialProperties(
        listingFor: _listingForParam,
        propertyType: propertyType,
        page: targetPage,
        limit: 10,
      );

      final newItems = res?.data.properties ?? [];
      final total = res?.totalCount ?? res?.results ?? newItems.length;

      final updatedList = refresh
          ? newItems
          : [...state.properties, ...newItems];

      state = state.copyWith(
        isLoading: false,
        isMoreLoading: false,
        properties: updatedList,
        page: targetPage,
        totalCount: total,
        hasMore: newItems.isNotEmpty && updatedList.length < total,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isMoreLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> loadMore() async {
    await fetchCommercialSpaces(refresh: false);
  }
}

// ─── Providers ────────────────────────────────────────────────────────────────

final commercialProvider =
    StateNotifierProvider<CommercialNotifier, CommercialState>(
      (_) => CommercialNotifier(),
    );

final selectedCommercialPropertyProvider = StateProvider<Property?>(
  (ref) => ref.watch(commercialProvider).selectedProperty,
);
