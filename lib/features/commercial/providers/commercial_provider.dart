import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/legacy.dart';

// ─── Enums ────────────────────────────────────────────────────────────────────

enum CommercialMode { buy, rent }

enum CommercialCategory { shop, officeSpace, showroom, warehouse, coWorking }

// ─── Models ───────────────────────────────────────────────────────────────────

class CommercialListing {
  final String id;
  final String price;
  final String pricePerSqft;
  final String type;
  final String floor;
  final String area;
  final String location;
  final String market;
  final String imageGradientKey;
  final String tag; // 'For Sale' | 'For Rent'
  final int photos;

  const CommercialListing({
    required this.id,
    required this.price,
    required this.pricePerSqft,
    required this.type,
    required this.floor,
    required this.area,
    required this.location,
    required this.market,
    required this.imageGradientKey,
    required this.tag,
    required this.photos,
  });
}

class LandmarkModel {
  final String name;
  final String distance;
  const LandmarkModel({required this.name, required this.distance});
}

// ─── Dummy Data ───────────────────────────────────────────────────────────────

final _listings = [
  const CommercialListing(
    id: 'c1',
    price: '₹48 Lakhs',
    pricePerSqft: '₹9,600/sqft',
    type: 'Retail shop',
    floor: 'Ground floor',
    area: '500 sqft',
    location: '9 Sector 18, Noida',
    market: 'Main market',
    imageGradientKey: 'warm',
    tag: 'For Sale',
    photos: 12,
  ),
  const CommercialListing(
    id: 'c2',
    price: '₹48 Lakhs',
    pricePerSqft: '₹9,600/sqft',
    type: 'Retail shop',
    floor: 'Ground floor',
    area: '500 sqft',
    location: '9 Sector 18, Noida',
    market: 'Main market',
    imageGradientKey: 'warm2',
    tag: 'For Rent',
    photos: 8,
  ),
  const CommercialListing(
    id: 'c3',
    price: '₹48 Lakhs',
    pricePerSqft: '₹9,600/sqft',
    type: 'Retail shop',
    floor: 'Ground floor',
    area: '500 sqft',
    location: '9 Sector 18, Noida',
    market: 'Main market',
    imageGradientKey: 'warm',
    tag: 'For Sale',
    photos: 15,
  ),
];

final _shopHighlights = [
  'Sector 18 — Noida\'s highest footfall market. 25,000+ daily visitors.',
  'Sector 18 metro — 300m walking distance',
  'Expected rental income: ₹40K–₹55K/month (9–11% ROI)',
  'All legal docs clear — title deed, OC, CC in place',
  'Ground floor + 22ft frontage — maximum brand visibility',
];

final _landmarks = [
  const LandmarkModel(name: 'Sector 18 metro', distance: '300m'),
  const LandmarkModel(name: 'DLF Mall of India', distance: '2.5 km'),
  const LandmarkModel(name: 'Noida IT corridor', distance: '1 km'),
];

// ─── Providers ────────────────────────────────────────────────────────────────

class CommercialState {
  final CommercialMode mode;
  final CommercialCategory? selectedCategory;

  const CommercialState({
    this.mode = CommercialMode.buy,
    this.selectedCategory,
  });

  CommercialState copyWith({
    CommercialMode? mode,
    CommercialCategory? selectedCategory,
  }) => CommercialState(
    mode: mode ?? this.mode,
    selectedCategory: selectedCategory ?? this.selectedCategory,
  );
}

class CommercialNotifier extends StateNotifier<CommercialState> {
  CommercialNotifier() : super(const CommercialState());

  void setMode(CommercialMode m) => state = state.copyWith(mode: m);
  void setCategory(CommercialCategory c) =>
      state = state.copyWith(selectedCategory: c);
}

final commercialProvider =
    StateNotifierProvider<CommercialNotifier, CommercialState>(
      (_) => CommercialNotifier(),
    );

final commercialListingsProvider = Provider<List<CommercialListing>>(
  (_) => _listings,
);

final selectedListingProvider = StateProvider<CommercialListing?>(
  (ref) => null,
);

final shopHighlightsProvider = Provider<List<String>>((_) => _shopHighlights);

final landmarksProvider = Provider<List<LandmarkModel>>((_) => _landmarks);

// ─── Extensions ──────────────────────────────────────────────────────────────

extension CatLabel on CommercialCategory {
  String get label => switch (this) {
    CommercialCategory.shop => 'Shop',
    CommercialCategory.officeSpace => 'Office space',
    CommercialCategory.showroom => 'Showroom',
    CommercialCategory.warehouse => 'Warehouse',
    CommercialCategory.coWorking => 'Co-working',
  };
}
