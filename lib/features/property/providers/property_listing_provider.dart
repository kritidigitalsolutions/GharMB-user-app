// ─── Model ────────────────────────────────────────────────────────────────────

import 'package:flutter_riverpod/legacy.dart';

class ListingModel {
  final String id;
  final String name;
  final String tag; // 'For Rent' / 'For Sale'
  final String tagColor; // 'green' / 'blue'
  final String type; // '3 BHK Apartment'
  final String society;
  final String location;
  final String distance;
  final String price;
  final String priceSuffix; // '/month' or ''
  final String area;
  final String furnishing;
  final String bathrooms;
  final String parking;
  final List<String> restrictions; // ['Only Family','No Pets','Non-Cosmo']
  final List<String> restrictionIcons; // emoji or asset
  final bool isVerified;

  const ListingModel({
    required this.id,
    required this.name,
    required this.tag,
    required this.tagColor,
    required this.type,
    required this.society,
    required this.location,
    required this.distance,
    required this.price,
    required this.priceSuffix,
    required this.area,
    required this.furnishing,
    required this.bathrooms,
    required this.parking,
    required this.restrictions,
    required this.restrictionIcons,
    required this.isVerified,
  });
}

// ─── Dummy Data ───────────────────────────────────────────────────────────────

List<ListingModel> _generateListings() {
  final tags = ['For Rent', 'For Sale'];
  final tagColors = ['green', 'blue'];
  final types = [
    '3 BHK Apartment',
    '2 BHK Apartment',
    '4 BHK Villa',
    '1 BHK Studio',
    '3 BHK Builder Floor',
    '2 BHK Penthouse',
  ];
  final societies = [
    'Gated Society',
    'Township',
    'Independent Floor',
    'High Rise',
    'Low Rise',
    'Villa Complex',
  ];
  final locations = [
    'Sector 62, Noida',
    'Sector 18, Noida',
    'Sector 44, Noida',
    'Sector 137, Noida',
    'Greater Noida West',
    'Sector 50, Noida',
    'Indirapuram, GZB',
    'Sector 75, Noida',
    'Sector 93, Noida',
    'Sector 168, Noida',
  ];
  final distances = [
    '1.2 km from metro',
    '0.8 km from metro',
    '2.1 km from school',
    '500 m from metro',
    '1.5 km from highway',
    '3 km from metro',
  ];
  final prices = [
    '₹28,000',
    '₹45,000',
    '₹18,500',
    '₹62,000',
    '₹35,000',
    '₹1.2Cr',
    '₹85L',
    '₹22,000',
    '₹55,000',
    '₹95L',
    '₹40,000',
    '₹1.8Cr',
    '₹15,000',
    '₹30,000',
    '₹72L',
    '₹25,000',
    '₹48,000',
    '₹2.1Cr',
    '₹19,000',
    '₹67L',
  ];
  final suffixes = [
    '/month',
    '/month',
    '/month',
    '/month',
    '/month',
    '',
    '',
    '/month',
    '/month',
    '',
    '/month',
    '',
    '/month',
    '/month',
    '',
    '/month',
    '/month',
    '',
    '/month',
    '',
  ];
  final areas = [
    '1450 sqft',
    '980 sqft',
    '1800 sqft',
    '650 sqft',
    '1250 sqft',
    '2100 sqft',
    '1650 sqft',
    '750 sqft',
    '1100 sqft',
    '2800 sqft',
    '890 sqft',
    '3200 sqft',
    '560 sqft',
    '1380 sqft',
    '2400 sqft',
    '1020 sqft',
    '1720 sqft',
    '4100 sqft',
    '820 sqft',
    '1950 sqft',
  ];
  final furnishings = [
    'Semi Furnished',
    'Fully Furnished',
    'Unfurnished',
    'Semi Furnished',
    'Fully Furnished',
    'Unfurnished',
  ];
  final baths = ['1 Bathroom', '2 Bathrooms', '3 Bathrooms', '4 Bathrooms'];
  final parkings = ['1 Parking', '2 Parking', 'No Parking'];
  final restrictionSets = [
    ['Only Family', 'No Pets', 'Non-Cosmo'],
    ['Bachelor Allowed', 'Pets OK', 'Any Community'],
    ['Family Preferred', 'No Smoking', 'Veg Only'],
    ['Any', 'No Pets', 'Non-Cosmo'],
  ];
  final iconSets = [
    ['👨‍👩‍👧', '🐾', '🚫'],
    ['🎓', '🐶', '🌍'],
    ['👨‍👩‍👧', '🚬', '🥦'],
    ['✅', '🐾', '🚫'],
  ];

  return List.generate(20, (i) {
    final isRent = suffixes[i] == '/month';
    return ListingModel(
      id: 'prop_$i',
      name: [
        'Skyline Heights',
        'Emerald Tower',
        'Green Valley',
        'Royal Residency',
        'Silver Oak',
        'Palm Grove',
        'Sunrise Heights',
        'Urban Nest',
        'Blue Ridge',
        'Maple Homes',
        'Golden Gate',
        'Star Residency',
        'Orchid Heights',
        'Lotus Tower',
        'Crystal Park',
        'Diamond Court',
        'Jasmine Enclave',
        'Tulip Gardens',
        'Sage Apartments',
        'Coral Homes',
      ][i],
      tag: isRent ? 'For Rent' : 'For Sale',
      tagColor: isRent ? 'green' : 'blue',
      type: types[i % types.length],
      society: societies[i % societies.length],
      location: locations[i % locations.length],
      distance: distances[i % distances.length],
      price: prices[i],
      priceSuffix: suffixes[i],
      area: areas[i],
      furnishing: furnishings[i % furnishings.length],
      bathrooms: baths[i % baths.length],
      parking: parkings[i % parkings.length],
      restrictions: restrictionSets[i % restrictionSets.length],
      restrictionIcons: iconSets[i % iconSets.length],
      isVerified: i % 3 != 2,
    );
  });
}

// ─── Provider ─────────────────────────────────────────────────────────────────

final _allListings = _generateListings();

class ListingsState {
  final List<ListingModel> visible;
  final bool hasMore;
  final bool isLoading;

  const ListingsState({
    required this.visible,
    required this.hasMore,
    this.isLoading = false,
  });
}

class ListingsNotifier extends StateNotifier<ListingsState> {
  static const _pageSize = 20;

  ListingsNotifier()
    : super(
        ListingsState(
          visible: _allListings.take(_pageSize).toList(),
          hasMore: _allListings.length > _pageSize,
        ),
      );

  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;
    state = ListingsState(
      visible: state.visible,
      hasMore: state.hasMore,
      isLoading: true,
    );
    await Future.delayed(const Duration(milliseconds: 800));
    final next = state.visible.length;
    final more = _allListings.skip(next).take(_pageSize).toList();
    state = ListingsState(
      visible: [...state.visible, ...more],
      hasMore: next + more.length < _allListings.length,
    );
  }
}

final listingsProvider = StateNotifierProvider<ListingsNotifier, ListingsState>(
  (_) => ListingsNotifier(),
);

// ─── Active filter chips (local state) ───────────────────────────────────────

final activeFiltersProvider = StateProvider<List<String>>(
  (_) => ['Ready to move', 'Verified', '2-4 BHK'],
);
