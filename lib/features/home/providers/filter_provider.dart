import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:gharmb_app/features/property/models/response/near_properties_response.dart';
import 'package:gharmb_app/features/property/providers/property_listing_near_by_provider.dart';

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

enum SortOption {
  defaultSort('Default'),
  priceLowToHigh('Price: Low to High'),
  priceHighToLow('Price: High to Low'),
  newest('Newest First'),
  areaLargeToSmall('Area: Largest First');

  final String label;
  const SortOption(this.label);
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
  final bool keyHandover;
  final bool nearMetroSchool;
  final Set<Amenity> amenities;

  const FilterState({
    this.lookingFor = const {},
    this.propertyTypes = const {},
    this.budgetRange = const RangeValues(0, 500),
    this.bedrooms = const {},
    this.furnishing = const {},
    this.areaRange = const RangeValues(0, 5000),
    this.postedBy = PostedBy.all,
    this.verifiedOnly = false,
    this.withPhotoOnly = false,
    this.readyToMoveIn = false,
    this.vastuCompliant = false,
    this.keyHandover = false,
    this.nearMetroSchool = false,
    this.amenities = const {},
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
    bool? keyHandover,
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
      keyHandover: keyHandover ?? this.keyHandover,
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
    if (lookingFor.isNotEmpty) count++;
    if (propertyTypes.isNotEmpty) count++;
    if (budgetRange.start > 0 || budgetRange.end < 500) count++;
    if (bedrooms.isNotEmpty) count++;
    if (furnishing.isNotEmpty) count++;
    if (areaRange.start > 0 || areaRange.end < 5000) count++;
    if (postedBy != PostedBy.all) count++;
    if (verifiedOnly) count++;
    if (withPhotoOnly) count++;
    if (readyToMoveIn) count++;
    if (vastuCompliant) count++;
    if (keyHandover) count++;
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

  void setLookingFor(Set<LookingFor> v) =>
      state = state.copyWith(lookingFor: v);
  void setPropertyTypes(Set<PropertyType> v) =>
      state = state.copyWith(propertyTypes: v);

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
  void toggleKeyHandover(bool v) => state = state.copyWith(keyHandover: v);
  void toggleNearMetro(bool v) => state = state.copyWith(nearMetroSchool: v);

  void toggleAmenity(Amenity v) {
    final s = Set<Amenity>.from(state.amenities);
    s.contains(v) ? s.remove(v) : s.add(v);
    state = state.copyWith(amenities: s);
  }

  void clearAll() => state = const FilterState();
}

final filterProvider = StateNotifierProvider<FilterNotifier, FilterState>(
  (_) => FilterNotifier(),
);

// ─── Search & Sort Providers ──────────────────────────────────────────────────

final searchQueryProvider = StateProvider<String>((ref) => '');

final sortByProvider = StateProvider<SortOption>(
  (ref) => SortOption.defaultSort,
);

// ─── Filtered Properties Provider ─────────────────────────────────────────────

final filteredPropertiesProvider = Provider<List<Property>>((ref) {
  final nearAsync = ref.watch(nearPropertiesProvider);
  final allProperties = nearAsync.value?.data.properties ?? [];
  if (allProperties.isEmpty) return [];

  final query = ref.watch(searchQueryProvider).trim().toLowerCase();
  final filter = ref.watch(filterProvider);
  final sortBy = ref.watch(sortByProvider);

  // If no search query, no filter active, and default sort -> show ALL properties as normal
  if (query.isEmpty &&
      filter.activeFilterCount == 0 &&
      sortBy == SortOption.defaultSort) {
    return allProperties;
  }

  final filtered = allProperties.where((p) {
    // 1. Search Query (Multi-keyword token matching)
    if (query.isNotEmpty) {
      final terms =
          query.split(RegExp(r'\s+')).where((t) => t.isNotEmpty).toList();
      final t = p.title.toLowerCase();
      final l = p.locality.toLowerCase();
      final c = p.city.toLowerCase();
      final a = p.fullAddress.toLowerCase();
      final pt = p.propertyType.toLowerCase();
      final cat = p.category.toLowerCase();
      final d = p.description.toLowerCase();
      final lf = p.listingFor.toLowerCase();
      final pin = p.pincode.toLowerCase();
      final own = p.owner.name.toLowerCase();
      final beds = p.bedrooms.toLowerCase();
      final furn = p.furnishing.toLowerCase();
      final ams = p.amenities.map((e) => e.toLowerCase()).join(' ');

      final haystack = '$t $l $c $a $pt $cat $d $lf $pin $own $beds $furn $ams';

      for (final term in terms) {
        if (!haystack.contains(term)) {
          return false;
        }
      }
    }

    // 2. Looking For
    if (filter.lookingFor.isNotEmpty) {
      final lFor = p.listingFor.toLowerCase();
      final cat = p.category.toLowerCase();
      bool match = false;
      for (final lf in filter.lookingFor) {
        switch (lf) {
          case LookingFor.buy:
            if (lFor.contains('buy') ||
                lFor.contains('sale') ||
                lFor.contains('sell')) {
              match = true;
            }
            break;
          case LookingFor.rent:
            if (lFor.contains('rent') || lFor.contains('lease')) match = true;
            break;
          case LookingFor.sell:
            if (lFor.contains('sell') || lFor.contains('sale')) match = true;
            break;
          case LookingFor.pgCoLiving:
            if (lFor.contains('pg') ||
                cat.contains('pg') ||
                cat.contains('co-living') ||
                cat.contains('coliving')) {
              match = true;
            }
            break;
          case LookingFor.commercial:
            if (lFor.contains('commercial') ||
                cat.contains('commercial') ||
                p.propertyType.toLowerCase().contains('commercial') ||
                p.propertyType.toLowerCase().contains('shop') ||
                p.propertyType.toLowerCase().contains('office')) {
              match = true;
            }
            break;
        }
        if (match) break;
      }
      if (!match) return false;
    }

    // 3. Property Type
    if (filter.propertyTypes.isNotEmpty) {
      final pType = p.propertyType.toLowerCase();
      bool match = false;
      for (final pt in filter.propertyTypes) {
        switch (pt) {
          case PropertyType.apartment:
            if (pType.contains('apartment') || pType.contains('flat')) {
              match = true;
            }
            break;
          case PropertyType.villa:
            if (pType.contains('villa')) match = true;
            break;
          case PropertyType.house:
            if (pType.contains('house') ||
                pType.contains('independent') ||
                pType.contains('home')) {
              match = true;
            }
            break;
          case PropertyType.studio:
            if (pType.contains('studio')) match = true;
            break;
          case PropertyType.penthouse:
            if (pType.contains('penthouse')) match = true;
            break;
          case PropertyType.plot:
            if (pType.contains('plot') || pType.contains('land')) match = true;
            break;
        }
        if (match) break;
      }
      if (!match) return false;
    }

    // 4. Budget Range (in Lakhs: 1 Lakh = 100,000, 100 Lakh = 1 Cr)
    if (filter.budgetRange.start > 0 || filter.budgetRange.end < 500) {
      final double priceInLakhs =
          p.price > 1000 ? p.price / 100000.0 : p.price.toDouble();
      if (priceInLakhs < filter.budgetRange.start ||
          priceInLakhs > filter.budgetRange.end) {
        return false;
      }
    }

    // 5. Bedrooms
    if (filter.bedrooms.isNotEmpty) {
      final bedsNum = int.tryParse(p.bedrooms) ?? 0;
      final bedsStr = p.bedrooms.toLowerCase();
      bool match = false;
      for (final bf in filter.bedrooms) {
        switch (bf) {
          case BedroomFilter.one:
            if (bedsNum == 1 || bedsStr.contains('1')) match = true;
            break;
          case BedroomFilter.two:
            if (bedsNum == 2 || bedsStr.contains('2')) match = true;
            break;
          case BedroomFilter.three:
            if (bedsNum == 3 || bedsStr.contains('3')) match = true;
            break;
          case BedroomFilter.four:
            if (bedsNum == 4 || bedsStr.contains('4')) match = true;
            break;
          case BedroomFilter.fourPlus:
            if (bedsNum >= 4) match = true;
            break;
        }
        if (match) break;
      }
      if (!match) return false;
    }

    // 6. Furnishing
    if (filter.furnishing.isNotEmpty) {
      final fStr = p.furnishing.toLowerCase();
      bool match = false;
      for (final f in filter.furnishing) {
        switch (f) {
          case Furnishing.unfurnished:
            if (fStr.contains('unfurnished') || fStr == 'un') match = true;
            break;
          case Furnishing.semiFurnished:
            if (fStr.contains('semi')) match = true;
            break;
          case Furnishing.fullyFurnished:
            if (fStr.contains('full')) match = true;
            break;
        }
        if (match) break;
      }
      if (!match) return false;
    }

    // 7. Area Range
    if (filter.areaRange.start > 0 || filter.areaRange.end < 5000) {
      final area = p.carpetArea > 0 ? p.carpetArea : p.builtUpArea;
      if (area > 0 &&
          (area < filter.areaRange.start || area > filter.areaRange.end)) {
        return false;
      }
    }

    // 8. Posted By
    if (filter.postedBy != PostedBy.all) {
      final lAs = p.listingAs.toLowerCase();
      switch (filter.postedBy) {
        case PostedBy.owner:
          if (!lAs.contains('owner')) return false;
          break;
        case PostedBy.agent:
          if (!lAs.contains('agent')) return false;
          break;
        case PostedBy.builder:
          if (!lAs.contains('builder') && !lAs.contains('developer'))
            return false;
          break;
        case PostedBy.all:
          break;
      }
    }

    // 9. Special Filters
    if (filter.verifiedOnly) {
      if (!p.owner.isVerified && p.approvalStatus.toLowerCase() != 'approved') {
        return false;
      }
    }

    if (filter.withPhotoOnly) {
      if (p.images.isEmpty) return false;
    }

    if (filter.readyToMoveIn) {
      final age = p.ageOfProperty.toLowerCase();
      final desc = p.description.toLowerCase();
      if (!age.contains('ready') && !desc.contains('ready')) return false;
    }

    if (filter.vastuCompliant) {
      if (!p.vastuCompliant) return false;
    }

    if (filter.keyHandover) {
      if (!p.keyHandover) return false;
    }

    // 10. Amenities
    if (filter.amenities.isNotEmpty) {
      final allAmenityStrings = p.amenities
          .map((a) => a.toLowerCase())
          .toList();
      bool match = false;
      for (final a in filter.amenities) {
        switch (a) {
          case Amenity.security:
            if (allAmenityStrings.any(
              (s) => s.contains('security') || s.contains('guard'),
            ))
              match = true;
            break;
          case Amenity.parking:
            if (p.parking.isNotEmpty ||
                allAmenityStrings.any((s) => s.contains('parking')))
              match = true;
            break;
          case Amenity.swimmingPool:
            if (allAmenityStrings.any(
              (s) => s.contains('pool') || s.contains('swim'),
            ))
              match = true;
            break;
          case Amenity.gym:
            if (allAmenityStrings.any(
              (s) => s.contains('gym') || s.contains('fitness'),
            ))
              match = true;
            break;
          case Amenity.lift:
            if (allAmenityStrings.any(
              (s) => s.contains('lift') || s.contains('elevator'),
            ))
              match = true;
            break;
          case Amenity.power:
            if (allAmenityStrings.any(
              (s) => s.contains('power') || s.contains('backup'),
            ))
              match = true;
            break;
          case Amenity.petAllowed:
            if (p.petsAllowed ||
                allAmenityStrings.any((s) => s.contains('pet')))
              match = true;
            break;
          case Amenity.garden:
            if (allAmenityStrings.any(
              (s) => s.contains('garden') || s.contains('park'),
            ))
              match = true;
            break;
          case Amenity.acReady:
            if (allAmenityStrings.any(
              (s) => s.contains('ac') || s.contains('air'),
            ))
              match = true;
            break;
        }
        if (match) break;
      }
      if (!match) return false;
    }

    return true;
  }).toList();

  // Sorting
  switch (sortBy) {
    case SortOption.priceLowToHigh:
      filtered.sort((a, b) => a.price.compareTo(b.price));
      break;
    case SortOption.priceHighToLow:
      filtered.sort((a, b) => b.price.compareTo(a.price));
      break;
    case SortOption.newest:
      filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      break;
    case SortOption.areaLargeToSmall:
      filtered.sort((a, b) {
        final areaA = a.carpetArea > 0 ? a.carpetArea : a.builtUpArea;
        final areaB = b.carpetArea > 0 ? b.carpetArea : b.builtUpArea;
        return areaB.compareTo(areaA);
      });
      break;
    case SortOption.defaultSort:
      break;
  }

  return filtered;
});

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
