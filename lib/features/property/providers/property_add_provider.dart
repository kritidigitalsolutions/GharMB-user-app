import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/legacy.dart';

// ─── Enums ────────────────────────────────────────────────────────────────────

import 'dart:io';

// ─── Enums ────────────────────────────────────────────────────────────────────

enum ListingRole { owner, agentBroker, developerBuilder }

enum ListingFor { sale, rent, lease, pg }

enum PropertyTypeList { apartment, villa, house, studio, plot }

enum AgeOfProperty { zeroToThree, threeToSeven, sevenToFifteen, fifteenPlus }

enum Furnishing { unfurnished, semiFurnished, fullyFurnished }

enum FacingDirection { east, west, north, south, ne, nw }

enum ParkingType { none, oneCovered, twoCovered, open }

enum AmenityList {
  security,
  gym,
  lift,
  powerBackup,
  pool,
  wifi,
  garden,
  clubhouse,
}

// Step 3
enum PriceNegotiable { yes, no, slightly }

enum PossessionStatus { immediate, within1Month, within3Months, within6Months }

// Step 4
enum ListingType { standard, featured, premium }

// ─── State ────────────────────────────────────────────────────────────────────

class ListPropertyState {
  // Role
  final ListingRole role;

  // Step 1 — Basic Details
  final String propertyTitle;
  final Set<ListingFor> listingFor;
  final PropertyTypeList? propertyType;
  final String city;
  final String locality;
  final String fullAddress;
  final String pincode;
  final String description;

  // Step 2 — Property Specs
  final int bedrooms;
  final int bathrooms;
  final String carpetArea;
  final String builtUpArea;
  final String floorNo;
  final String totalFloors;
  final AgeOfProperty? ageOfProperty;
  final Furnishing? furnishing;
  final Set<FacingDirection> facing;
  final ParkingType? parking;
  final Set<AmenityList> amenities;

  // Step 3 — Photos & Video
  final List<File> photos;

  // Step 4 — Pricing & Preferences
  final String expectedPrice;
  final PriceNegotiable priceNegotiable;
  final String maintenancePerMonth;
  final PossessionStatus possession;
  final bool vastuCompliant;
  final bool openToAllBuyers;
  final bool loanAssistanceNeeded;
  final ListingType listingType;

  const ListPropertyState({
    this.role = ListingRole.owner,
    this.propertyTitle = '',
    this.listingFor = const {ListingFor.sale},
    this.propertyType,
    this.city = '',
    this.locality = '',
    this.fullAddress = '',
    this.pincode = '',
    this.description = '',
    this.bedrooms = 3,
    this.bathrooms = 3,
    this.carpetArea = '',
    this.builtUpArea = '',
    this.floorNo = '',
    this.totalFloors = '',
    this.ageOfProperty,
    this.furnishing,
    this.facing = const {},
    this.parking,
    this.amenities = const {},
    this.photos = const [],
    this.expectedPrice = '',
    this.priceNegotiable = PriceNegotiable.yes,
    this.maintenancePerMonth = '',
    this.possession = PossessionStatus.immediate,
    this.vastuCompliant = true,
    this.openToAllBuyers = true,
    this.loanAssistanceNeeded = true,
    this.listingType = ListingType.standard,
  });

  ListPropertyState copyWith({
    ListingRole? role,
    String? propertyTitle,
    Set<ListingFor>? listingFor,
    PropertyTypeList? propertyType,
    String? city,
    String? locality,
    String? fullAddress,
    String? pincode,
    String? description,
    int? bedrooms,
    int? bathrooms,
    String? carpetArea,
    String? builtUpArea,
    String? floorNo,
    String? totalFloors,
    AgeOfProperty? ageOfProperty,
    Furnishing? furnishing,
    Set<FacingDirection>? facing,
    ParkingType? parking,
    Set<AmenityList>? amenities,
    List<File>? photos,
    String? expectedPrice,
    PriceNegotiable? priceNegotiable,
    String? maintenancePerMonth,
    PossessionStatus? possession,
    bool? vastuCompliant,
    bool? openToAllBuyers,
    bool? loanAssistanceNeeded,
    ListingType? listingType,
  }) {
    return ListPropertyState(
      role: role ?? this.role,
      propertyTitle: propertyTitle ?? this.propertyTitle,
      listingFor: listingFor ?? this.listingFor,
      propertyType: propertyType ?? this.propertyType,
      city: city ?? this.city,
      locality: locality ?? this.locality,
      fullAddress: fullAddress ?? this.fullAddress,
      pincode: pincode ?? this.pincode,
      description: description ?? this.description,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      carpetArea: carpetArea ?? this.carpetArea,
      builtUpArea: builtUpArea ?? this.builtUpArea,
      floorNo: floorNo ?? this.floorNo,
      totalFloors: totalFloors ?? this.totalFloors,
      ageOfProperty: ageOfProperty ?? this.ageOfProperty,
      furnishing: furnishing ?? this.furnishing,
      facing: facing ?? this.facing,
      parking: parking ?? this.parking,
      amenities: amenities ?? this.amenities,
      photos: photos ?? this.photos,
      expectedPrice: expectedPrice ?? this.expectedPrice,
      priceNegotiable: priceNegotiable ?? this.priceNegotiable,
      maintenancePerMonth: maintenancePerMonth ?? this.maintenancePerMonth,
      possession: possession ?? this.possession,
      vastuCompliant: vastuCompliant ?? this.vastuCompliant,
      openToAllBuyers: openToAllBuyers ?? this.openToAllBuyers,
      loanAssistanceNeeded: loanAssistanceNeeded ?? this.loanAssistanceNeeded,
      listingType: listingType ?? this.listingType,
    );
  }

  // Computed
  String get furnishingLabel => furnishing?.label ?? '';
  String get possessionLabel => switch (possession) {
    PossessionStatus.immediate => 'Immediate',
    PossessionStatus.within1Month => 'Within 1 Month',
    PossessionStatus.within3Months => 'Within 3 Months',
    PossessionStatus.within6Months => 'Within 6 Months',
  };
  String get listingTypeLabel => switch (listingType) {
    ListingType.standard => 'Standard - free',
    ListingType.featured => 'Featured - ₹999',
    ListingType.premium => 'Premium - ₹1,999',
  };
}

// ─── Notifier ─────────────────────────────────────────────────────────────────

class ListPropertyNotifier extends StateNotifier<ListPropertyState> {
  ListPropertyNotifier() : super(const ListPropertyState());

  void setRole(ListingRole r) => state = state.copyWith(role: r);
  void setPropertyTitle(String v) => state = state.copyWith(propertyTitle: v);
  void toggleListingFor(ListingFor v) {
    final s = Set<ListingFor>.from(state.listingFor);
    s.contains(v) ? s.remove(v) : s.add(v);
    state = state.copyWith(listingFor: s);
  }

  void setPropertyType(PropertyTypeList v) =>
      state = state.copyWith(propertyType: v);
  void setCity(String v) => state = state.copyWith(city: v);
  void setLocality(String v) => state = state.copyWith(locality: v);
  void setFullAddress(String v) => state = state.copyWith(fullAddress: v);
  void setPincode(String v) => state = state.copyWith(pincode: v);
  void setDescription(String v) => state = state.copyWith(description: v);
  void setBedrooms(int v) => state = state.copyWith(bedrooms: v);
  void setBathrooms(int v) => state = state.copyWith(bathrooms: v);
  void setCarpetArea(String v) => state = state.copyWith(carpetArea: v);
  void setBuiltUpArea(String v) => state = state.copyWith(builtUpArea: v);
  void setFloorNo(String v) => state = state.copyWith(floorNo: v);
  void setTotalFloors(String v) => state = state.copyWith(totalFloors: v);
  void setAge(AgeOfProperty v) => state = state.copyWith(ageOfProperty: v);
  void setFurnishing(Furnishing v) => state = state.copyWith(furnishing: v);
  void toggleFacing(FacingDirection v) {
    final s = Set<FacingDirection>.from(state.facing);
    s.contains(v) ? s.remove(v) : s.add(v);
    state = state.copyWith(facing: s);
  }

  void setParking(ParkingType v) => state = state.copyWith(parking: v);
  void toggleAmenity(AmenityList v) {
    final s = Set<AmenityList>.from(state.amenities);
    s.contains(v) ? s.remove(v) : s.add(v);
    state = state.copyWith(amenities: s);
  }

  // Step 3
  void addPhotos(List<File> newFiles) {
    final merged = [...state.photos, ...newFiles];
    state = state.copyWith(photos: merged.take(12).toList());
  }

  void removePhoto(int index) {
    final updated = List<File>.from(state.photos)..removeAt(index);
    state = state.copyWith(photos: updated);
  }

  // Step 4
  void setExpectedPrice(String v) => state = state.copyWith(expectedPrice: v);
  void setPriceNegotiable(PriceNegotiable v) =>
      state = state.copyWith(priceNegotiable: v);
  void setMaintenance(String v) =>
      state = state.copyWith(maintenancePerMonth: v);
  void setPossession(PossessionStatus v) =>
      state = state.copyWith(possession: v);
  void setVastu(bool v) => state = state.copyWith(vastuCompliant: v);
  void setOpenToAll(bool v) => state = state.copyWith(openToAllBuyers: v);
  void setLoanAssistance(bool v) =>
      state = state.copyWith(loanAssistanceNeeded: v);
  void setListingType(ListingType v) => state = state.copyWith(listingType: v);
}

final listPropertyProvider =
    StateNotifierProvider<ListPropertyNotifier, ListPropertyState>(
      (_) => ListPropertyNotifier(),
    );

// ─── Extensions ──────────────────────────────────────────────────────────────

extension ListingForLabel on ListingFor {
  String get label => switch (this) {
    ListingFor.sale => 'Sale',
    ListingFor.rent => 'Rent',
    ListingFor.lease => 'Lease',
    ListingFor.pg => 'PG',
  };
}

extension PropertyTypeLabel on PropertyTypeList {
  String get label => switch (this) {
    PropertyTypeList.apartment => 'Apartment',
    PropertyTypeList.villa => 'Villa',
    PropertyTypeList.house => 'House',
    PropertyTypeList.studio => 'Studio',
    PropertyTypeList.plot => 'Plot',
  };
}

extension AgeLabel on AgeOfProperty {
  String get label => switch (this) {
    AgeOfProperty.zeroToThree => '0-3 yrs',
    AgeOfProperty.threeToSeven => '3-7 yrs',
    AgeOfProperty.sevenToFifteen => '7-15 yrs',
    AgeOfProperty.fifteenPlus => '15+ yrs',
  };
}

extension FurnishingLabel on Furnishing {
  String get label => switch (this) {
    Furnishing.unfurnished => 'Unfurnished',
    Furnishing.semiFurnished => 'Semi-furnished',
    Furnishing.fullyFurnished => 'Fully-furnished',
  };
}

extension FacingLabel on FacingDirection {
  String get label => switch (this) {
    FacingDirection.east => 'East',
    FacingDirection.west => 'West',
    FacingDirection.north => 'North',
    FacingDirection.south => 'South',
    FacingDirection.ne => 'NE',
    FacingDirection.nw => 'NW',
  };
}

extension ParkingLabel on ParkingType {
  String get label => switch (this) {
    ParkingType.none => 'None',
    ParkingType.oneCovered => '1 covered',
    ParkingType.twoCovered => '2 covered',
    ParkingType.open => 'Open',
  };
}

extension AmenityLabel on AmenityList {
  String get label => switch (this) {
    AmenityList.security => 'Security',
    AmenityList.gym => 'Gym',
    AmenityList.lift => 'Lift',
    AmenityList.powerBackup => 'Power backup',
    AmenityList.pool => 'Pool',
    AmenityList.wifi => 'Wi-Fi',
    AmenityList.garden => 'Garden',
    AmenityList.clubhouse => 'Clubhouse',
  };
}

extension PriceNegotiableLabel on PriceNegotiable {
  String get label => switch (this) {
    PriceNegotiable.yes => 'Yes',
    PriceNegotiable.no => 'No',
    PriceNegotiable.slightly => 'Slightly',
  };
}

// provider property submitted

final submissionIdProvider = Provider<String>((ref) => '#GBM-240612-0015');

// Step index provider (0=submitted, 1=doc verification, 2=property verification, 3=go live)
final currentStepProvider = StateProvider<int>((ref) => 0);
