import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

// ─── Enums ────────────────────────────────────────────────────────────────────

enum ProjectType { residential, commercial, mixedUse }

enum ProjectStatus { underConstruction, readyToMove, newLaunch }

enum BhkFacing { east, west, north, south, ne, nw, se, sw }

enum PaymentPlanType { constructionLinked, downPayment, subvention, flexi }

enum LockInPeriod { none, sixMonths, oneYear, twoYears, threeYears }

enum AmenityItem {
  reraApproved,
  gatedSociety,
  security24x7,
  clubhouse,
  swimmingPool,
  gym,
  powerBackup,
  lift,
  metroNearby,
  wifiReady,
  garden,
  evCharging,
  cricketPitch,
  tennisCourt,
  badmintonCourt,
  kidsPlayArea,
  joggingTrack,
  amphitheatre,
}

enum GreenCertification { igbc, griha, leed, none }

enum PhotoCategory {
  exterior,
  lobby,
  clubhouse,
  pool,
  gym,
  flat,
  masterPlan,
  floorPlan,
  other,
}

// ─── BHK Config model ─────────────────────────────────────────────────────────

class BhkConfig {
  final String id;
  final String bhkType;
  final String carpetArea;
  final String builtUpArea;
  final String superBuiltUpArea;
  final String priceInLakh;
  final String totalUnits;
  final String bookingAmount;
  final BhkFacing? facing;
  final PaymentPlanType? paymentPlan;

  const BhkConfig({
    required this.id,
    this.bhkType = '',
    this.carpetArea = '',
    this.builtUpArea = '',
    this.superBuiltUpArea = '',
    this.priceInLakh = '',
    this.totalUnits = '',
    this.bookingAmount = '',
    this.facing,
    this.paymentPlan,
  });

  double get pricePerSqft {
    final price = double.tryParse(priceInLakh) ?? 0;
    final carpet = double.tryParse(carpetArea) ?? 0;
    if (carpet == 0) return 0;
    return (price * 100000) / carpet;
  }

  BhkConfig copyWith({
    String? bhkType,
    String? carpetArea,
    String? builtUpArea,
    String? superBuiltUpArea,
    String? priceInLakh,
    String? totalUnits,
    String? bookingAmount,
    BhkFacing? facing,
    PaymentPlanType? paymentPlan,
  }) {
    return BhkConfig(
      id: id,
      bhkType: bhkType ?? this.bhkType,
      carpetArea: carpetArea ?? this.carpetArea,
      builtUpArea: builtUpArea ?? this.builtUpArea,
      superBuiltUpArea: superBuiltUpArea ?? this.superBuiltUpArea,
      priceInLakh: priceInLakh ?? this.priceInLakh,
      totalUnits: totalUnits ?? this.totalUnits,
      bookingAmount: bookingAmount ?? this.bookingAmount,
      facing: facing ?? this.facing,
      paymentPlan: paymentPlan ?? this.paymentPlan,
    );
  }
}

// ─── Tagged photo model ───────────────────────────────────────────────────────

class TaggedPhoto {
  final File file;
  final PhotoCategory category;
  TaggedPhoto({required this.file, this.category = PhotoCategory.exterior});
}

// ─── State ────────────────────────────────────────────────────────────────────

class ProjectAddState {
  // ── Step 1: Basic info ──────────────────────────────────────────────────────
  final String projectName;
  final String reraNumber;
  final String reraExpiryDate;
  final ProjectType projectType;
  final ProjectStatus projectStatus;
  final String developerName;
  final String projectWebsite;
  final String projectTagline;
  final String city;
  final String locality;
  final String fullAddress;
  final String pincode;
  final String possessionDate;
  final String launchDate;
  final String shortDescription;

  // ── Step 2: Unit configuration ──────────────────────────────────────────────
  final List<BhkConfig> bhkConfigs;
  final String totalFloors;
  final String totalTowers;
  final String totalUnitsOverall;
  final String openSpacePercent;

  // ── Step 3: Amenities & highlights ─────────────────────────────────────────
  final Set<AmenityItem> amenities;
  final String nearbyLandmark;
  final List<String> nearbyLandmarks;
  final String schoolDistanceKm;
  final String hospitalDistanceKm;
  final String roadWidthFt;
  final bool vastuCompliant;
  final GreenCertification greenCertification;
  final String constructionUpdateUrl;

  // ── Step 4: Photos & plans ──────────────────────────────────────────────────
  final List<TaggedPhoto> projectPhotos;
  final File? masterPlan;
  final File? floorPlan;
  final File? brochure;
  final String virtualTourUrl;
  final String droneVideoUrl;
  final String googleMapsUrl;

  // ── Step 5: Contact & submit ────────────────────────────────────────────────
  final String contactPersonName;
  final String contactPersonPhone;
  final String contactPersonEmail;
  final String siteVisitTimings;
  final int listingValidityDays;
  final bool termsAccepted;

  const ProjectAddState({
    // Step 1
    this.projectName = '',
    this.reraNumber = '',
    this.reraExpiryDate = '',
    this.projectType = ProjectType.residential,
    this.projectStatus = ProjectStatus.underConstruction,
    this.developerName = '',
    this.projectWebsite = '',
    this.projectTagline = '',
    this.city = '',
    this.locality = '',
    this.fullAddress = '',
    this.pincode = '',
    this.possessionDate = '',
    this.launchDate = '',
    this.shortDescription = '',
    // Step 2
    this.bhkConfigs = const [],
    this.totalFloors = '',
    this.totalTowers = '',
    this.totalUnitsOverall = '',
    this.openSpacePercent = '',
    // Step 3
    this.amenities = const {},
    this.nearbyLandmark = '',
    this.nearbyLandmarks = const [],
    this.schoolDistanceKm = '',
    this.hospitalDistanceKm = '',
    this.roadWidthFt = '',
    this.vastuCompliant = false,
    this.greenCertification = GreenCertification.none,
    this.constructionUpdateUrl = '',
    // Step 4
    this.projectPhotos = const [],
    this.masterPlan,
    this.floorPlan,
    this.brochure,
    this.virtualTourUrl = '',
    this.droneVideoUrl = '',
    this.googleMapsUrl = '',
    // Step 5
    this.contactPersonName = '',
    this.contactPersonPhone = '',
    this.contactPersonEmail = '',
    this.siteVisitTimings = '',
    this.listingValidityDays = 60,
    this.termsAccepted = false,
  });

  // ── Computed ────────────────────────────────────────────────────────────────

  String get bhkTypesLabel {
    if (bhkConfigs.isEmpty) return '';
    return bhkConfigs
        .map((e) => e.bhkType)
        .where((e) => e.isNotEmpty)
        .join(', ');
  }

  String get priceRangeLabel {
    if (bhkConfigs.isEmpty) return '';
    final prices = bhkConfigs
        .map((e) => double.tryParse(e.priceInLakh) ?? 0)
        .where((e) => e > 0)
        .toList();
    if (prices.isEmpty) return '';
    prices.sort();
    return '₹${prices.first.toStringAsFixed(0)}L – ₹${prices.last.toStringAsFixed(0)}L';
  }

  int get totalPhotosCount => projectPhotos.length;
  String get address => fullAddress;
  String get bhkSummary =>
      bhkTypesLabel.isEmpty ? '2, 3, 4 BHK' : bhkTypesLabel;
  String get priceRange => priceRangeLabel.isEmpty ? '-' : priceRangeLabel;
  String get totalUnitsSummary {
    if (totalUnitsOverall.isNotEmpty) return totalUnitsOverall;
    final total = bhkConfigs
        .map((e) => int.tryParse(e.totalUnits) ?? 0)
        .fold<int>(0, (sum, value) => sum + value);
    return total == 0 ? '-' : '$total';
  }

  bool get reraApproved =>
      amenities.contains(AmenityItem.reraApproved) || reraNumber.isNotEmpty;

  ProjectAddState copyWith({
    String? projectName,
    String? reraNumber,
    String? reraExpiryDate,
    ProjectType? projectType,
    ProjectStatus? projectStatus,
    String? developerName,
    String? projectWebsite,
    String? projectTagline,
    String? city,
    String? locality,
    String? fullAddress,
    String? pincode,
    String? possessionDate,
    String? launchDate,
    String? shortDescription,
    List<BhkConfig>? bhkConfigs,
    String? totalFloors,
    String? totalTowers,
    String? totalUnitsOverall,
    String? openSpacePercent,
    Set<AmenityItem>? amenities,
    String? nearbyLandmark,
    List<String>? nearbyLandmarks,
    String? schoolDistanceKm,
    String? hospitalDistanceKm,
    String? roadWidthFt,
    bool? vastuCompliant,
    GreenCertification? greenCertification,
    String? constructionUpdateUrl,
    List<TaggedPhoto>? projectPhotos,
    File? masterPlan,
    File? floorPlan,
    File? brochure,
    bool clearMasterPlan = false,
    bool clearFloorPlan = false,
    bool clearBrochure = false,
    String? virtualTourUrl,
    String? droneVideoUrl,
    String? googleMapsUrl,
    String? contactPersonName,
    String? contactPersonPhone,
    String? contactPersonEmail,
    String? siteVisitTimings,
    int? listingValidityDays,
    bool? termsAccepted,
  }) {
    return ProjectAddState(
      projectName: projectName ?? this.projectName,
      reraNumber: reraNumber ?? this.reraNumber,
      reraExpiryDate: reraExpiryDate ?? this.reraExpiryDate,
      projectType: projectType ?? this.projectType,
      projectStatus: projectStatus ?? this.projectStatus,
      developerName: developerName ?? this.developerName,
      projectWebsite: projectWebsite ?? this.projectWebsite,
      projectTagline: projectTagline ?? this.projectTagline,
      city: city ?? this.city,
      locality: locality ?? this.locality,
      fullAddress: fullAddress ?? this.fullAddress,
      pincode: pincode ?? this.pincode,
      possessionDate: possessionDate ?? this.possessionDate,
      launchDate: launchDate ?? this.launchDate,
      shortDescription: shortDescription ?? this.shortDescription,
      bhkConfigs: bhkConfigs ?? this.bhkConfigs,
      totalFloors: totalFloors ?? this.totalFloors,
      totalTowers: totalTowers ?? this.totalTowers,
      totalUnitsOverall: totalUnitsOverall ?? this.totalUnitsOverall,
      openSpacePercent: openSpacePercent ?? this.openSpacePercent,
      amenities: amenities ?? this.amenities,
      nearbyLandmark: nearbyLandmark ?? this.nearbyLandmark,
      nearbyLandmarks: nearbyLandmarks ?? this.nearbyLandmarks,
      schoolDistanceKm: schoolDistanceKm ?? this.schoolDistanceKm,
      hospitalDistanceKm: hospitalDistanceKm ?? this.hospitalDistanceKm,
      roadWidthFt: roadWidthFt ?? this.roadWidthFt,
      vastuCompliant: vastuCompliant ?? this.vastuCompliant,
      greenCertification: greenCertification ?? this.greenCertification,
      constructionUpdateUrl:
          constructionUpdateUrl ?? this.constructionUpdateUrl,
      projectPhotos: projectPhotos ?? this.projectPhotos,
      masterPlan: clearMasterPlan ? null : masterPlan ?? this.masterPlan,
      floorPlan: clearFloorPlan ? null : floorPlan ?? this.floorPlan,
      brochure: clearBrochure ? null : brochure ?? this.brochure,
      virtualTourUrl: virtualTourUrl ?? this.virtualTourUrl,
      droneVideoUrl: droneVideoUrl ?? this.droneVideoUrl,
      googleMapsUrl: googleMapsUrl ?? this.googleMapsUrl,
      contactPersonName: contactPersonName ?? this.contactPersonName,
      contactPersonPhone: contactPersonPhone ?? this.contactPersonPhone,
      contactPersonEmail: contactPersonEmail ?? this.contactPersonEmail,
      siteVisitTimings: siteVisitTimings ?? this.siteVisitTimings,
      listingValidityDays: listingValidityDays ?? this.listingValidityDays,
      termsAccepted: termsAccepted ?? this.termsAccepted,
    );
  }
}

// ─── Notifier ─────────────────────────────────────────────────────────────────

class ProjectAddNotifier extends StateNotifier<ProjectAddState> {
  ProjectAddNotifier() : super(const ProjectAddState());

  // Step 1
  void setProjectName(String v) => state = state.copyWith(projectName: v);
  void setReraNumber(String v) => state = state.copyWith(reraNumber: v);
  void setReraExpiryDate(String v) => state = state.copyWith(reraExpiryDate: v);
  void setProjectType(ProjectType v) => state = state.copyWith(projectType: v);
  void setProjectStatus(ProjectStatus v) =>
      state = state.copyWith(projectStatus: v);
  void setDeveloperName(String v) => state = state.copyWith(developerName: v);
  void setProjectWebsite(String v) => state = state.copyWith(projectWebsite: v);
  void setProjectTagline(String v) => state = state.copyWith(projectTagline: v);
  void setCity(String v) => state = state.copyWith(city: v);
  void setLocality(String v) => state = state.copyWith(locality: v);
  void setFullAddress(String v) => state = state.copyWith(fullAddress: v);
  void setPincode(String v) => state = state.copyWith(pincode: v);
  void setPossessionDate(String v) => state = state.copyWith(possessionDate: v);
  void setLaunchDate(String v) => state = state.copyWith(launchDate: v);
  void setShortDescription(String v) =>
      state = state.copyWith(shortDescription: v);

  // Step 2 — BHK configs
  void addBhkConfig() {
    final configs = List<BhkConfig>.from(state.bhkConfigs);
    configs.add(
      BhkConfig(id: DateTime.now().millisecondsSinceEpoch.toString()),
    );
    state = state.copyWith(bhkConfigs: configs);
  }

  void removeBhkConfig(String id) {
    state = state.copyWith(
      bhkConfigs: state.bhkConfigs.where((c) => c.id != id).toList(),
    );
  }

  void updateBhkConfig(String id, BhkConfig updated) {
    state = state.copyWith(
      bhkConfigs: state.bhkConfigs
          .map((c) => c.id == id ? updated : c)
          .toList(),
    );
  }

  void setTotalFloors(String v) => state = state.copyWith(totalFloors: v);
  void setTotalTowers(String v) => state = state.copyWith(totalTowers: v);
  void setTotalUnitsOverall(String v) =>
      state = state.copyWith(totalUnitsOverall: v);
  void setOpenSpacePercent(String v) =>
      state = state.copyWith(openSpacePercent: v);
  void setFloors(String v) => setTotalFloors(v);
  void setTowers(String v) => setTotalTowers(v);
  void setTotalUnits(String v) => setTotalUnitsOverall(v);

  // Step 3
  void toggleAmenity(AmenityItem v) {
    final s = Set<AmenityItem>.from(state.amenities);
    s.contains(v) ? s.remove(v) : s.add(v);
    state = state.copyWith(amenities: s);
  }

  void addLandmark(String v) {
    if (v.trim().isEmpty) return;
    state = state.copyWith(
      nearbyLandmarks: [...state.nearbyLandmarks, v.trim()],
    );
  }

  void removeLandmark(int index) {
    final list = List<String>.from(state.nearbyLandmarks)..removeAt(index);
    state = state.copyWith(nearbyLandmarks: list);
  }

  void setSchoolDistance(String v) =>
      state = state.copyWith(schoolDistanceKm: v);
  void setHospitalDistance(String v) =>
      state = state.copyWith(hospitalDistanceKm: v);
  void setRoadWidth(String v) => state = state.copyWith(roadWidthFt: v);
  void setVastu(bool v) => state = state.copyWith(vastuCompliant: v);
  void setVastuCompliant(bool v) => setVastu(v);
  void setGreenCertification(GreenCertification v) =>
      state = state.copyWith(greenCertification: v);
  void setConstructionUpdateUrl(String v) =>
      state = state.copyWith(constructionUpdateUrl: v);

  // Step 4
  void addPhotos(List<File> files, PhotoCategory category) {
    final newPhotos = files
        .map((f) => TaggedPhoto(file: f, category: category))
        .toList();
    final merged = [...state.projectPhotos, ...newPhotos].take(12).toList();
    state = state.copyWith(projectPhotos: merged);
  }

  void addProjectPhotos(List<File> files) =>
      addPhotos(files, PhotoCategory.exterior);

  void removePhoto(int index) {
    final updated = List<TaggedPhoto>.from(state.projectPhotos)
      ..removeAt(index);
    state = state.copyWith(projectPhotos: updated);
  }

  void removeProjectPhoto(int index) => removePhoto(index);

  void setMasterPlan(File? f) => state = state.copyWith(masterPlan: f);
  void setFloorPlan(File? f) => state = state.copyWith(floorPlan: f);
  void setBrochure(File? f) => state = state.copyWith(brochure: f);
  void removeMasterPlan() => state = state.copyWith(clearMasterPlan: true);
  void removeFloorPlan() => state = state.copyWith(clearFloorPlan: true);
  void removeBrochure() => state = state.copyWith(clearBrochure: true);
  void setVirtualTourUrl(String v) => state = state.copyWith(virtualTourUrl: v);
  void setWalkthroughVideoUrl(String v) => setVirtualTourUrl(v);
  void setDroneVideoUrl(String v) => state = state.copyWith(droneVideoUrl: v);
  void setGoogleMapsUrl(String v) => state = state.copyWith(googleMapsUrl: v);

  // Step 5
  void setContactPersonName(String v) =>
      state = state.copyWith(contactPersonName: v);
  void setContactPersonPhone(String v) =>
      state = state.copyWith(contactPersonPhone: v);
  void setContactPersonEmail(String v) =>
      state = state.copyWith(contactPersonEmail: v);
  void setSiteVisitTimings(String v) =>
      state = state.copyWith(siteVisitTimings: v);
  void setListingValidity(int v) =>
      state = state.copyWith(listingValidityDays: v);
  void setTermsAccepted(bool v) => state = state.copyWith(termsAccepted: v);
}

final projectAddProvider =
    StateNotifierProvider<ProjectAddNotifier, ProjectAddState>(
      (_) => ProjectAddNotifier(),
    );

final projectCurrentStepProvider = StateProvider<int>((_) => 0);

const projectAmenityOptions = AmenityItem.values;

// ─── Extensions ───────────────────────────────────────────────────────────────

extension ProjectTypeLabel on ProjectType {
  String get label => switch (this) {
    ProjectType.residential => 'Residential',
    ProjectType.commercial => 'Commercial',
    ProjectType.mixedUse => 'Mixed use',
  };
}

extension ProjectStatusLabel on ProjectStatus {
  String get label => switch (this) {
    ProjectStatus.underConstruction => 'Under construction',
    ProjectStatus.readyToMove => 'Ready to move',
    ProjectStatus.newLaunch => 'New launch',
  };

  IconData get icon => switch (this) {
    ProjectStatus.underConstruction => Icons.construction,
    ProjectStatus.readyToMove => Icons.check_circle,
    ProjectStatus.newLaunch => Icons.rocket_launch,
  };
}

extension BhkFacingLabel on BhkFacing {
  String get label => switch (this) {
    BhkFacing.east => 'East',
    BhkFacing.west => 'West',
    BhkFacing.north => 'North',
    BhkFacing.south => 'South',
    BhkFacing.ne => 'NE',
    BhkFacing.nw => 'NW',
    BhkFacing.se => 'SE',
    BhkFacing.sw => 'SW',
  };
}

extension PaymentPlanLabel on PaymentPlanType {
  String get label => switch (this) {
    PaymentPlanType.constructionLinked => 'Construction linked',
    PaymentPlanType.downPayment => 'Down payment',
    PaymentPlanType.subvention => 'Subvention',
    PaymentPlanType.flexi => 'Flexi plan',
  };
}

extension AmenityLabel on AmenityItem {
  String get label => switch (this) {
    AmenityItem.reraApproved => 'RERA approved',
    AmenityItem.gatedSociety => 'Gated society',
    AmenityItem.security24x7 => '24/7 security',
    AmenityItem.clubhouse => 'Clubhouse',
    AmenityItem.swimmingPool => 'Swimming pool',
    AmenityItem.gym => 'Gym',
    AmenityItem.powerBackup => 'Power backup',
    AmenityItem.lift => 'Lift',
    AmenityItem.metroNearby => 'Metro nearby',
    AmenityItem.wifiReady => 'WiFi ready',
    AmenityItem.garden => 'Garden',
    AmenityItem.evCharging => 'EV charging',
    AmenityItem.cricketPitch => 'Cricket pitch',
    AmenityItem.tennisCourt => 'Tennis court',
    AmenityItem.badmintonCourt => 'Badminton court',
    AmenityItem.kidsPlayArea => 'Kids play area',
    AmenityItem.joggingTrack => 'Jogging track',
    AmenityItem.amphitheatre => 'Amphitheatre',
  };
}

extension GreenCertLabel on GreenCertification {
  String get label => switch (this) {
    GreenCertification.igbc => 'IGBC Green',
    GreenCertification.griha => 'GRIHA rated',
    GreenCertification.leed => 'LEED certified',
    GreenCertification.none => 'None',
  };
}

extension PhotoCategoryLabel on PhotoCategory {
  String get label => switch (this) {
    PhotoCategory.exterior => 'Exterior',
    PhotoCategory.lobby => 'Lobby',
    PhotoCategory.clubhouse => 'Clubhouse',
    PhotoCategory.pool => 'Pool',
    PhotoCategory.gym => 'Gym',
    PhotoCategory.flat => 'Flat / Unit',
    PhotoCategory.masterPlan => 'Master plan',
    PhotoCategory.floorPlan => 'Floor plan',
    PhotoCategory.other => 'Other',
  };
}
