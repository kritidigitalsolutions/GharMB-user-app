import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/legacy.dart';

// ─── Enums ────────────────────────────────────────────────────────────────────

enum ListingRole { owner, agentBroker, developerBuilder }

enum PropertyCategory { residential, commercial }

enum CommercialType {
  shop,
  officeSpace,
  showroom,
  warehouse,
  coworking,
  industrialPlot,
}

enum ListingFor { sale, rent, lease, pg }

// ── Residential-specific ──────────────────────────────────────────────────────
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

// ── Commercial-specific ───────────────────────────────────────────────────────
enum CeilingHeight { below10, ten14, fourteen18, above18 }

enum CommercialFacilities {
  washroom,
  acHvac,
  lift,
  cctv,
  fireSafety,
  access24x7,
  loadingDock,
  storeRoom,
}

enum FootfallArea { highFootfall, itHub, highwayFacing, residentialComplex }

enum CommercialParking { none, oneReserved, twoPlus, visitor }

// ── Pricing / Preferences ─────────────────────────────────────────────────────
enum PriceNegotiable { yes, no, slightly }

enum PossessionStatus { immediate, within1Month, within3Months, within6Months }

enum ListingType { standard, featured, premium }

// ── NEW: Lock-in period ───────────────────────────────────────────────────────
enum LockInPeriod { none, sixMonths, oneYear, twoYears, threeYears, fiveYears }

// ── NEW: Escalation clause ────────────────────────────────────────────────────
enum EscalationClause { none, five, ten, fifteen }

// ── NEW: GST applicable ───────────────────────────────────────────────────────
enum GstApplicable { gst12, gst18, notApplicable, dontKnow }

// ── NEW: PG inclusions ────────────────────────────────────────────────────────
enum PgInclusion {
  wifi,
  foodVeg,
  foodVegNonVeg,
  laundry,
  housekeeping,
  powerBackup,
}

// ─── State ────────────────────────────────────────────────────────────────────

class ListPropertyState {
  // Role & Category
  final ListingRole role;
  final PropertyCategory category;

  // Step 1 — Basic Details (shared)
  final String propertyTitle;
  final Set<ListingFor> listingFor;
  final String city;
  final String locality;
  final String fullAddress;
  final String pincode;
  final String description;

  // Step 1 — Residential only
  final PropertyTypeList? propertyType;

  // Step 1 — Commercial only
  final CommercialType? commercialType;

  // Step 2 — Residential specs
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

  // Step 2 — Commercial specs
  final String commercialCarpetArea;
  final String commercialBuiltUpArea;
  final String commercialFloor;
  final String commercialTotalFloors;
  final String frontage;
  final CeilingHeight? ceilingHeight;
  final String powerLoad;
  final CommercialParking? commercialParking;
  final Set<CommercialFacilities> facilities;
  final AgeOfProperty? commercialAge;

  // Step 3 — Commercial: location USP
  final String commercialUsp;
  final Set<FootfallArea> footfallArea;
  final String securityDeposit;
  final String securityDepositMonths;
  final bool brokerageFree;

  // Step 3 — Photos
  final List<File> photos;

  // Step 4 — Pricing & Preferences (shared)
  final String expectedPrice;
  final PriceNegotiable priceNegotiable;
  final String maintenancePerMonth;
  final String bookingTokenAmount;
  final String monthlyRent;
  final String brokerageAmount;
  final String propertyTax;
  final String otherCharges;
  final String ownershipType;
  final String preferredTenant;
  final String suitableFor;
  final String commercialUsage;
  final String availability;
  final String rentEscalation;
  final PossessionStatus possession;
  final bool vastuCompliant;
  final bool openToAllBuyers;
  final bool loanAssistanceNeeded;
  final bool taxIncluded;
  final ListingType listingType;

  // ── NEW: Secondary charges fields ────────────────────────────────────────────
  /// Whether maintenance is included in rent (Residential Rent)
  final bool maintenanceIncluded;

  /// Lease duration as text, e.g. "2 years" (Residential & Commercial Lease)
  final String leaseDuration;

  /// Lock-in period (Residential Lease, Commercial Rent, Commercial Lease)
  final LockInPeriod? lockInPeriod;

  /// Escalation clause (Commercial Rent, Commercial Lease)
  final EscalationClause? escalationClause;

  /// Notice period text, e.g. "30 days" (PG)
  final String noticePeriod;

  /// What is included in PG charges
  final Set<PgInclusion> pgInclusions;

  /// GST applicable (Commercial Sale)
  final GstApplicable? gstApplicable;

  // ── NEW: Preference toggle fields ────────────────────────────────────────────
  /// Family preferred (Residential Rent / Lease / PG)
  final bool familyPreferred;

  /// Fit-out / interior modification allowed (Commercial Rent / Lease)
  final bool fitOutAllowed;

  /// Legal clearance / title deed clear (Commercial Sale)
  final bool legalClearanceDone;

  /// Long-term tenant preferred — 2+ years (Commercial Rent / Lease)
  final bool longTermPreferred;

  const ListPropertyState({
    this.role = ListingRole.owner,
    this.category = PropertyCategory.residential,
    this.propertyTitle = '',
    this.listingFor = const {ListingFor.rent},
    this.propertyType,
    this.commercialType,
    this.city = '',
    this.locality = '',
    this.fullAddress = '',
    this.pincode = '',
    this.description = '',
    // Residential specs
    this.bedrooms = 2,
    this.bathrooms = 2,
    this.carpetArea = '',
    this.builtUpArea = '',
    this.floorNo = '',
    this.totalFloors = '',
    this.ageOfProperty,
    this.furnishing,
    this.facing = const {},
    this.parking,
    this.amenities = const {},
    // Commercial specs
    this.commercialCarpetArea = '',
    this.commercialBuiltUpArea = '',
    this.commercialFloor = '',
    this.commercialTotalFloors = '',
    this.frontage = '',
    this.ceilingHeight,
    this.powerLoad = '',
    this.commercialParking,
    this.facilities = const {},
    this.commercialAge,
    // Commercial USP
    this.commercialUsp = '',
    this.footfallArea = const {},
    this.securityDeposit = '2',
    this.securityDepositMonths = '',
    this.brokerageFree = true,
    // Photos
    this.photos = const [],
    // Pricing
    this.expectedPrice = '',
    this.priceNegotiable = PriceNegotiable.yes,
    this.maintenancePerMonth = '',
    this.bookingTokenAmount = '',
    this.monthlyRent = '',
    this.brokerageAmount = '',
    this.propertyTax = '',
    this.otherCharges = '',
    this.ownershipType = '',
    this.preferredTenant = '',
    this.suitableFor = '',
    this.commercialUsage = '',
    this.availability = '',
    this.rentEscalation = '',
    this.possession = PossessionStatus.immediate,
    this.vastuCompliant = true,
    this.openToAllBuyers = true,
    this.loanAssistanceNeeded = true,
    this.taxIncluded = false,
    this.listingType = ListingType.standard,
    // Secondary charges
    this.maintenanceIncluded = false,
    this.leaseDuration = '',
    this.lockInPeriod,
    this.escalationClause,
    this.noticePeriod = '',
    this.pgInclusions = const {},
    this.gstApplicable,
    // Preference toggles
    this.familyPreferred = false,
    this.fitOutAllowed = false,
    this.legalClearanceDone = false,
    this.longTermPreferred = false,
  });

  // ── Computed helpers ──────────────────────────────────────────────────────

  bool get isResidential => category == PropertyCategory.residential;
  bool get isCommercial => category == PropertyCategory.commercial;

  bool get isSale => listingFor.contains(ListingFor.sale);
  bool get isRent => listingFor.contains(ListingFor.rent);
  bool get isLease => listingFor.contains(ListingFor.lease);
  bool get isPg => listingFor.contains(ListingFor.pg);

  bool get showRentFields => isResidential && (isRent || isLease || isPg);
  bool get showCommercialRentFields => isCommercial && (isRent || isLease);
  bool get showSaleOnlyFields => isSale && isResidential;
  bool get showPgFields => isPg && isResidential;

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

  ListPropertyState copyWith({
    ListingRole? role,
    PropertyCategory? category,
    String? propertyTitle,
    Set<ListingFor>? listingFor,
    PropertyTypeList? propertyType,
    CommercialType? commercialType,
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
    String? commercialCarpetArea,
    String? commercialBuiltUpArea,
    String? commercialFloor,
    String? commercialTotalFloors,
    String? frontage,
    CeilingHeight? ceilingHeight,
    String? powerLoad,
    CommercialParking? commercialParking,
    Set<CommercialFacilities>? facilities,
    AgeOfProperty? commercialAge,
    String? commercialUsp,
    Set<FootfallArea>? footfallArea,
    String? securityDeposit,
    String? securityDepositMonths,
    bool? brokerageFree,
    List<File>? photos,
    String? expectedPrice,
    PriceNegotiable? priceNegotiable,
    String? maintenancePerMonth,
    String? bookingTokenAmount,
    String? monthlyRent,
    String? brokerageAmount,
    String? propertyTax,
    String? otherCharges,
    String? ownershipType,
    String? preferredTenant,
    String? suitableFor,
    String? commercialUsage,
    String? availability,
    String? rentEscalation,
    PossessionStatus? possession,
    bool? vastuCompliant,
    bool? openToAllBuyers,
    bool? loanAssistanceNeeded,
    bool? taxIncluded,
    ListingType? listingType,
    // Secondary charges
    bool? maintenanceIncluded,
    String? leaseDuration,
    LockInPeriod? lockInPeriod,
    EscalationClause? escalationClause,
    String? noticePeriod,
    Set<PgInclusion>? pgInclusions,
    GstApplicable? gstApplicable,
    // Preference toggles
    bool? familyPreferred,
    bool? fitOutAllowed,
    bool? legalClearanceDone,
    bool? longTermPreferred,
  }) {
    return ListPropertyState(
      role: role ?? this.role,
      category: category ?? this.category,
      propertyTitle: propertyTitle ?? this.propertyTitle,
      listingFor: listingFor ?? this.listingFor,
      propertyType: propertyType ?? this.propertyType,
      commercialType: commercialType ?? this.commercialType,
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
      commercialCarpetArea: commercialCarpetArea ?? this.commercialCarpetArea,
      commercialBuiltUpArea:
          commercialBuiltUpArea ?? this.commercialBuiltUpArea,
      commercialFloor: commercialFloor ?? this.commercialFloor,
      commercialTotalFloors:
          commercialTotalFloors ?? this.commercialTotalFloors,
      frontage: frontage ?? this.frontage,
      ceilingHeight: ceilingHeight ?? this.ceilingHeight,
      powerLoad: powerLoad ?? this.powerLoad,
      commercialParking: commercialParking ?? this.commercialParking,
      facilities: facilities ?? this.facilities,
      commercialAge: commercialAge ?? this.commercialAge,
      commercialUsp: commercialUsp ?? this.commercialUsp,
      footfallArea: footfallArea ?? this.footfallArea,
      securityDeposit: securityDeposit ?? this.securityDeposit,
      securityDepositMonths:
          securityDepositMonths ?? this.securityDepositMonths,
      brokerageFree: brokerageFree ?? this.brokerageFree,
      photos: photos ?? this.photos,
      expectedPrice: expectedPrice ?? this.expectedPrice,
      priceNegotiable: priceNegotiable ?? this.priceNegotiable,
      maintenancePerMonth: maintenancePerMonth ?? this.maintenancePerMonth,
      bookingTokenAmount: bookingTokenAmount ?? this.bookingTokenAmount,
      monthlyRent: monthlyRent ?? this.monthlyRent,
      brokerageAmount: brokerageAmount ?? this.brokerageAmount,
      propertyTax: propertyTax ?? this.propertyTax,
      otherCharges: otherCharges ?? this.otherCharges,
      ownershipType: ownershipType ?? this.ownershipType,
      preferredTenant: preferredTenant ?? this.preferredTenant,
      suitableFor: suitableFor ?? this.suitableFor,
      commercialUsage: commercialUsage ?? this.commercialUsage,
      availability: availability ?? this.availability,
      rentEscalation: rentEscalation ?? this.rentEscalation,
      possession: possession ?? this.possession,
      vastuCompliant: vastuCompliant ?? this.vastuCompliant,
      openToAllBuyers: openToAllBuyers ?? this.openToAllBuyers,
      loanAssistanceNeeded: loanAssistanceNeeded ?? this.loanAssistanceNeeded,
      taxIncluded: taxIncluded ?? this.taxIncluded,
      listingType: listingType ?? this.listingType,
      // Secondary charges
      maintenanceIncluded: maintenanceIncluded ?? this.maintenanceIncluded,
      leaseDuration: leaseDuration ?? this.leaseDuration,
      lockInPeriod: lockInPeriod ?? this.lockInPeriod,
      escalationClause: escalationClause ?? this.escalationClause,
      noticePeriod: noticePeriod ?? this.noticePeriod,
      pgInclusions: pgInclusions ?? this.pgInclusions,
      gstApplicable: gstApplicable ?? this.gstApplicable,
      // Preference toggles
      familyPreferred: familyPreferred ?? this.familyPreferred,
      fitOutAllowed: fitOutAllowed ?? this.fitOutAllowed,
      legalClearanceDone: legalClearanceDone ?? this.legalClearanceDone,
      longTermPreferred: longTermPreferred ?? this.longTermPreferred,
    );
  }
}

// ─── Notifier ─────────────────────────────────────────────────────────────────

class ListPropertyNotifier extends StateNotifier<ListPropertyState> {
  ListPropertyNotifier() : super(const ListPropertyState());

  void setRole(ListingRole r) => state = state.copyWith(role: r);

  void setCategory(PropertyCategory c) {
    final defaultFor = c == PropertyCategory.commercial
        ? {ListingFor.rent}
        : {ListingFor.rent};
    state = state.copyWith(category: c, listingFor: defaultFor);
  }

  void setPropertyTitle(String v) => state = state.copyWith(propertyTitle: v);

  void toggleListingFor(ListingFor v) {
    state = state.copyWith(listingFor: {v});
  }

  void setPropertyType(PropertyTypeList v) =>
      state = state.copyWith(propertyType: v);

  void setCommercialType(CommercialType v) =>
      state = state.copyWith(commercialType: v);

  void setCity(String v) => state = state.copyWith(city: v);
  void setLocality(String v) => state = state.copyWith(locality: v);
  void setFullAddress(String v) => state = state.copyWith(fullAddress: v);
  void setPincode(String v) => state = state.copyWith(pincode: v);
  void setDescription(String v) => state = state.copyWith(description: v);

  // Residential specs
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

  // Commercial specs
  void setCommercialCarpetArea(String v) =>
      state = state.copyWith(commercialCarpetArea: v);
  void setCommercialBuiltUpArea(String v) =>
      state = state.copyWith(commercialBuiltUpArea: v);
  void setCommercialFloor(String v) =>
      state = state.copyWith(commercialFloor: v);
  void setCommercialTotalFloors(String v) =>
      state = state.copyWith(commercialTotalFloors: v);
  void setFrontage(String v) => state = state.copyWith(frontage: v);
  void setCeilingHeight(CeilingHeight v) =>
      state = state.copyWith(ceilingHeight: v);
  void setPowerLoad(String v) => state = state.copyWith(powerLoad: v);
  void setCommercialParking(CommercialParking v) =>
      state = state.copyWith(commercialParking: v);
  void toggleFacility(CommercialFacilities v) {
    final s = Set<CommercialFacilities>.from(state.facilities);
    s.contains(v) ? s.remove(v) : s.add(v);
    state = state.copyWith(facilities: s);
  }

  void setCommercialAge(AgeOfProperty v) =>
      state = state.copyWith(commercialAge: v);

  // Commercial USP
  void setCommercialUsp(String v) => state = state.copyWith(commercialUsp: v);
  void toggleFootfall(FootfallArea v) {
    final s = Set<FootfallArea>.from(state.footfallArea);
    s.contains(v) ? s.remove(v) : s.add(v);
    state = state.copyWith(footfallArea: s);
  }

  void setSecurityDeposit(String v) =>
      state = state.copyWith(securityDeposit: v);
  void setSecurityDepositMonths(String v) =>
      state = state.copyWith(securityDepositMonths: v);
  void setBrokerageFree(bool v) => state = state.copyWith(brokerageFree: v);

  // Photos
  void addPhotos(List<File> files) {
    final merged = [...state.photos, ...files];
    state = state.copyWith(photos: merged.take(12).toList());
  }

  void removePhoto(int index) {
    final updated = List<File>.from(state.photos)..removeAt(index);
    state = state.copyWith(photos: updated);
  }

  // Pricing
  void setExpectedPrice(String v) => state = state.copyWith(expectedPrice: v);
  void setPriceNegotiable(PriceNegotiable v) =>
      state = state.copyWith(priceNegotiable: v);
  void setMaintenance(String v) =>
      state = state.copyWith(maintenancePerMonth: v);
  void setBookingTokenAmount(String v) =>
      state = state.copyWith(bookingTokenAmount: v);
  void setMonthlyRent(String v) => state = state.copyWith(monthlyRent: v);
  void setBrokerageAmount(String v) =>
      state = state.copyWith(brokerageAmount: v);
  void setPropertyTax(String v) => state = state.copyWith(propertyTax: v);
  void setOtherCharges(String v) => state = state.copyWith(otherCharges: v);
  void setOwnershipType(String v) => state = state.copyWith(ownershipType: v);
  void setPreferredTenant(String v) =>
      state = state.copyWith(preferredTenant: v);
  void setSuitableFor(String v) => state = state.copyWith(suitableFor: v);
  void setCommercialUsage(String v) =>
      state = state.copyWith(commercialUsage: v);
  void setAvailability(String v) => state = state.copyWith(availability: v);
  void setRentEscalation(String v) => state = state.copyWith(rentEscalation: v);
  void setPossession(PossessionStatus v) =>
      state = state.copyWith(possession: v);
  void setVastu(bool v) => state = state.copyWith(vastuCompliant: v);
  void setOpenToAll(bool v) => state = state.copyWith(openToAllBuyers: v);
  void setLoanAssistance(bool v) =>
      state = state.copyWith(loanAssistanceNeeded: v);
  void setTaxIncluded(bool v) => state = state.copyWith(taxIncluded: v);
  void setListingType(ListingType v) => state = state.copyWith(listingType: v);

  // ── NEW: Secondary charges setters ──────────────────────────────────────────

  void setMaintenanceIncluded(bool v) =>
      state = state.copyWith(maintenanceIncluded: v);

  void setLeaseDuration(String v) => state = state.copyWith(leaseDuration: v);

  void setLockInPeriod(LockInPeriod v) =>
      state = state.copyWith(lockInPeriod: v);

  void setEscalationClause(EscalationClause v) =>
      state = state.copyWith(escalationClause: v);

  void setNoticePeriod(String v) => state = state.copyWith(noticePeriod: v);

  void togglePgInclusion(PgInclusion v) {
    final s = Set<PgInclusion>.from(state.pgInclusions);
    s.contains(v) ? s.remove(v) : s.add(v);
    state = state.copyWith(pgInclusions: s);
  }

  void setGstApplicable(GstApplicable v) =>
      state = state.copyWith(gstApplicable: v);

  // ── NEW: Preference toggle setters ──────────────────────────────────────────

  void setFamilyPreferred(bool v) => state = state.copyWith(familyPreferred: v);

  void setFitOutAllowed(bool v) => state = state.copyWith(fitOutAllowed: v);

  void setLegalClearanceDone(bool v) =>
      state = state.copyWith(legalClearanceDone: v);

  void setLongTermPreferred(bool v) =>
      state = state.copyWith(longTermPreferred: v);
}

final listPropertyProvider =
    StateNotifierProvider<ListPropertyNotifier, ListPropertyState>(
      (_) => ListPropertyNotifier(),
    );

// ─── Extensions ───────────────────────────────────────────────────────────────

extension PropertyCategoryLabel on PropertyCategory {
  String get label => switch (this) {
    PropertyCategory.residential => 'Residential',
    PropertyCategory.commercial => 'Commercial',
  };
}

extension CommercialTypeLabel on CommercialType {
  String get label => switch (this) {
    CommercialType.shop => 'Shop / Retail',
    CommercialType.officeSpace => 'Office space',
    CommercialType.showroom => 'Showroom',
    CommercialType.warehouse => 'Warehouse',
    CommercialType.coworking => 'Co-working',
    CommercialType.industrialPlot => 'Industrial plot',
  };
}

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
    AgeOfProperty.zeroToThree => '0–3 yrs',
    AgeOfProperty.threeToSeven => '3–7 yrs',
    AgeOfProperty.sevenToFifteen => '7–15 yrs',
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

extension CeilingHeightLabel on CeilingHeight {
  String get label => switch (this) {
    CeilingHeight.below10 => '< 10 ft',
    CeilingHeight.ten14 => '10–14 ft',
    CeilingHeight.fourteen18 => '14–18 ft',
    CeilingHeight.above18 => '18+ ft',
  };
}

extension CommercialFacilitiesLabel on CommercialFacilities {
  String get label => switch (this) {
    CommercialFacilities.washroom => 'Washroom',
    CommercialFacilities.acHvac => 'AC / HVAC',
    CommercialFacilities.lift => 'Lift',
    CommercialFacilities.cctv => 'CCTV',
    CommercialFacilities.fireSafety => 'Fire safety',
    CommercialFacilities.access24x7 => '24/7 access',
    CommercialFacilities.loadingDock => 'Loading dock',
    CommercialFacilities.storeRoom => 'Store room',
  };
}

extension FootfallAreaLabel on FootfallArea {
  String get label => switch (this) {
    FootfallArea.highFootfall => 'High footfall market',
    FootfallArea.itHub => 'IT / office hub',
    FootfallArea.highwayFacing => 'Highway facing',
    FootfallArea.residentialComplex => 'Residential complex',
  };
}

extension CommercialParkingLabel on CommercialParking {
  String get label => switch (this) {
    CommercialParking.none => 'None',
    CommercialParking.oneReserved => '1 reserved',
    CommercialParking.twoPlus => '2+ reserved',
    CommercialParking.visitor => 'Visitor',
  };
}

extension PriceNegotiableLabel on PriceNegotiable {
  String get label => switch (this) {
    PriceNegotiable.yes => 'Yes',
    PriceNegotiable.no => 'No',
    PriceNegotiable.slightly => 'Slightly',
  };
}

// ── NEW: Extension labels ─────────────────────────────────────────────────────

extension PossessionStatusLabel on PossessionStatus {
  String get shortLabel => switch (this) {
    PossessionStatus.immediate => 'Immediate',
    PossessionStatus.within1Month => 'Within 1 mo',
    PossessionStatus.within3Months => 'Within 3 mo',
    PossessionStatus.within6Months => 'Within 6 mo',
  };
}

extension LockInPeriodLabel on LockInPeriod {
  String get label => switch (this) {
    LockInPeriod.none => 'None',
    LockInPeriod.sixMonths => '6 months',
    LockInPeriod.oneYear => '1 year',
    LockInPeriod.twoYears => '2 years',
    LockInPeriod.threeYears => '3 years',
    LockInPeriod.fiveYears => '4+ years',
  };
}

extension EscalationClauseLabel on EscalationClause {
  String get label => switch (this) {
    EscalationClause.none => 'None',
    EscalationClause.five => '5% / year',
    EscalationClause.ten => '10% / year',
    EscalationClause.fifteen => '15% / 3 yrs',
  };
}

extension GstApplicableLabel on GstApplicable {
  String get label => switch (this) {
    GstApplicable.gst12 => 'Yes (12%)',
    GstApplicable.gst18 => 'Yes (18%)',
    GstApplicable.notApplicable => 'Not applicable',
    GstApplicable.dontKnow => "Don't know",
  };
}

extension PgInclusionLabel on PgInclusion {
  String get label => switch (this) {
    PgInclusion.wifi => 'WiFi',
    PgInclusion.foodVeg => 'Food (veg)',
    PgInclusion.foodVegNonVeg => 'Food (veg + non-veg)',
    PgInclusion.laundry => 'Laundry',
    PgInclusion.housekeeping => 'Housekeeping',
    PgInclusion.powerBackup => 'Power backup',
  };
}

// ── Extra providers ───────────────────────────────────────────────────────────
final submissionIdProvider = Provider<String>((ref) => '#GBM-240612-0015');
final currentStepProvider = StateProvider<int>((ref) => 0);
