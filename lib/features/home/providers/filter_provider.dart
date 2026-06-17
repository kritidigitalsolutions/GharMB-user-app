import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

// ─── Enums ────────────────────────────────────────────────────────────────────

enum LookingFor { buy, rent, sell, pgCoLiving, commercial }

enum PropertyType { apartment, villa, house, studio, penthouse, plot }

enum BedroomFilter { one, two, three, four, fourPlus }

enum Furnishing { unfurnished, semiFurnished, fullyFurnished }

enum PostedBy { all, owner, agent, builder }

enum Amenity {
  security,
  parking,
  swimmingPool,
  gym,
  lift,
  power,
  petAllowed,
  garden,
  acReady,
}

// ─── State ────────────────────────────────────────────────────────────────────

class FilterState {
  final Set<LookingFor> lookingFor;
  final Set<PropertyType> propertyTypes;
  final RangeValues budgetRange;
  final Set<BedroomFilter> bedrooms;
  final Set<Furnishing> furnishing;
  final RangeValues areaRange;
  final PostedBy postedBy;
  final bool verifiedOnly;
  final bool withPhotoOnly;
  final bool readyToMoveIn;
  final bool vastuCompliant;
  final bool nearMetroSchool;
  final Set<Amenity> amenities;

  const FilterState({
    this.lookingFor = const {LookingFor.buy},
    this.propertyTypes = const {PropertyType.apartment},
    this.budgetRange = const RangeValues(10, 50),
    this.bedrooms = const {BedroomFilter.one},
    this.furnishing = const {Furnishing.unfurnished},
    this.areaRange = const RangeValues(0, 1400),
    this.postedBy = PostedBy.all,
    this.verifiedOnly = false,
    this.withPhotoOnly = false,
    this.readyToMoveIn = false,
    this.vastuCompliant = true,
    this.nearMetroSchool = true,
    this.amenities = const {Amenity.security, Amenity.parking},
  });

  FilterState copyWith({
    Set<LookingFor>? lookingFor,
    Set<PropertyType>? propertyTypes,
    RangeValues? budgetRange,
    Set<BedroomFilter>? bedrooms,
    Set<Furnishing>? furnishing,
    RangeValues? areaRange,
    PostedBy? postedBy,
    bool? verifiedOnly,
    bool? withPhotoOnly,
    bool? readyToMoveIn,
    bool? vastuCompliant,
    bool? nearMetroSchool,
    Set<Amenity>? amenities,
  }) {
    return FilterState(
      lookingFor: lookingFor ?? this.lookingFor,
      propertyTypes: propertyTypes ?? this.propertyTypes,
      budgetRange: budgetRange ?? this.budgetRange,
      bedrooms: bedrooms ?? this.bedrooms,
      furnishing: furnishing ?? this.furnishing,
      areaRange: areaRange ?? this.areaRange,
      postedBy: postedBy ?? this.postedBy,
      verifiedOnly: verifiedOnly ?? this.verifiedOnly,
      withPhotoOnly: withPhotoOnly ?? this.withPhotoOnly,
      readyToMoveIn: readyToMoveIn ?? this.readyToMoveIn,
      vastuCompliant: vastuCompliant ?? this.vastuCompliant,
      nearMetroSchool: nearMetroSchool ?? this.nearMetroSchool,
      amenities: amenities ?? this.amenities,
    );
  }

  String get budgetLabel {
    String f(double v) =>
        v >= 100 ? '₹${(v / 100).toStringAsFixed(0)}Cr' : '₹${v.toInt()}L';
    return '${f(budgetRange.start)} – ${f(budgetRange.end)}';
  }

  int get activeFilterCount {
    int count = 0;
    if (propertyTypes.isNotEmpty) count++;
    if (bedrooms.isNotEmpty) count++;
    if (furnishing.isNotEmpty) count++;
    if (postedBy != PostedBy.all) count++;
    if (verifiedOnly) count++;
    if (readyToMoveIn) count++;
    if (vastuCompliant) count++;
    if (nearMetroSchool) count++;
    if (amenities.isNotEmpty) count++;
    return count;
  }
}

class FilterNotifier extends StateNotifier<FilterState> {
  FilterNotifier() : super(const FilterState());

  void toggleLookingFor(LookingFor v) {
    final s = Set<LookingFor>.from(state.lookingFor);
    s.contains(v) ? s.remove(v) : s.add(v);
    state = state.copyWith(lookingFor: s);
  }

  void togglePropertyType(PropertyType v) {
    final s = Set<PropertyType>.from(state.propertyTypes);
    s.contains(v) ? s.remove(v) : s.add(v);
    state = state.copyWith(propertyTypes: s);
  }

  void setBudget(RangeValues v) => state = state.copyWith(budgetRange: v);

  void toggleBedroom(BedroomFilter v) {
    final s = Set<BedroomFilter>.from(state.bedrooms);
    s.contains(v) ? s.remove(v) : s.add(v);
    state = state.copyWith(bedrooms: s);
  }

  void toggleFurnishing(Furnishing v) {
    final s = Set<Furnishing>.from(state.furnishing);
    s.contains(v) ? s.remove(v) : s.add(v);
    state = state.copyWith(furnishing: s);
  }

  void setArea(RangeValues v) => state = state.copyWith(areaRange: v);

  void setPostedBy(PostedBy v) => state = state.copyWith(postedBy: v);

  void toggleVerified(bool v) => state = state.copyWith(verifiedOnly: v);
  void togglePhotoOnly(bool v) => state = state.copyWith(withPhotoOnly: v);
  void toggleReadyToMove(bool v) => state = state.copyWith(readyToMoveIn: v);
  void toggleVastu(bool v) => state = state.copyWith(vastuCompliant: v);
  void toggleNearMetro(bool v) => state = state.copyWith(nearMetroSchool: v);

  void toggleAmenity(Amenity v) {
    final s = Set<Amenity>.from(state.amenities);
    s.contains(v) ? s.remove(v) : s.add(v);
    state = state.copyWith(amenities: s);
  }

  void clearAll() => state = const FilterState(
    lookingFor: {},
    propertyTypes: {},
    bedrooms: {},
    furnishing: {},
    amenities: {},
    verifiedOnly: false,
    withPhotoOnly: false,
    readyToMoveIn: false,
    vastuCompliant: false,
    nearMetroSchool: false,
    postedBy: PostedBy.all,
  );
}

final filterProvider = StateNotifierProvider<FilterNotifier, FilterState>(
  (_) => FilterNotifier(),
);

// ─── Extensions ──────────────────────────────────────────────────────────────

extension LookingForLabel on LookingFor {
  String get label => switch (this) {
    LookingFor.buy => 'Buy',
    LookingFor.rent => 'Rent',
    LookingFor.sell => 'Sell',
    LookingFor.pgCoLiving => 'PG/Co-living',
    LookingFor.commercial => 'Commercial',
  };
}

extension PropertyTypeLabel on PropertyType {
  String get label => switch (this) {
    PropertyType.apartment => 'Apartment',
    PropertyType.villa => 'Villa',
    PropertyType.house => 'House',
    PropertyType.studio => 'Studio',
    PropertyType.penthouse => 'Penthouse',
    PropertyType.plot => 'Plot',
  };
}

extension BedroomLabel on BedroomFilter {
  String get label => switch (this) {
    BedroomFilter.one => '1 BHK',
    BedroomFilter.two => '2 BHK',
    BedroomFilter.three => '3 BHK',
    BedroomFilter.four => '4 BHK',
    BedroomFilter.fourPlus => '4+ BHK',
  };
}

extension FurnishingLabel on Furnishing {
  String get label => switch (this) {
    Furnishing.unfurnished => 'Unfurnished',
    Furnishing.semiFurnished => 'Semi Furnished',
    Furnishing.fullyFurnished => 'Fully Furnished',
  };
}

extension PostedByLabel on PostedBy {
  String get label => switch (this) {
    PostedBy.all => 'All',
    PostedBy.owner => 'Owner',
    PostedBy.agent => 'Agent',
    PostedBy.builder => 'Builder',
  };
}

extension AmenityLabel on Amenity {
  String get label => switch (this) {
    Amenity.security => 'Security',
    Amenity.parking => 'Parking',
    Amenity.swimmingPool => 'Swimming Pool',
    Amenity.gym => 'Gym',
    Amenity.lift => 'Lift',
    Amenity.power => 'Power Backup',
    Amenity.petAllowed => 'Pet Allowed',
    Amenity.garden => 'Garden / park',
    Amenity.acReady => 'AC Fitings',
  };
}

extension AmenityIcon on Amenity {
  IconData get icon => switch (this) {
    Amenity.security => Icons.security,
    Amenity.parking => Icons.local_parking,
    Amenity.swimmingPool => Icons.pool,
    Amenity.gym => Icons.fitness_center,
    Amenity.lift => Icons.elevator,
    Amenity.power => Icons.bolt,
    Amenity.petAllowed => Icons.pets,
    Amenity.garden => Icons.park,
    Amenity.acReady => Icons.ac_unit,
  };
}
