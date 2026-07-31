// project_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/data/network/network_api_service.dart';
import 'package:gharmb_app/features/project/model/propert_response_mode.dart';
import 'package:gharmb_app/features/project/repo/project_repo.dart';
import 'package:riverpod/legacy.dart';

// ─────────────────────────────────────────────────────────────────────────
// Core API providers (unchanged)
// ─────────────────────────────────────────────────────────────────────────

final networkApiServiceProvider = Provider<NetworkApiService>((ref) {
  return NetworkApiService();
});

final projectRepoProvider = Provider<ProjectRepo>((ref) {
  final api = ref.read(networkApiServiceProvider);
  return ProjectRepo(api);
});

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

  /// Pull-to-refresh / retry without flashing a full loading spinner
  /// (keeps old data on screen while refetching).
  Future<void> refresh() async {
    state = await AsyncValue.guard(() => _repo.allProperties());
  }
}

// ─────────────────────────────────────────────────────────────────────────
// UI display model — this is what ProjectListPage / _ProjectCard render.
// Keeps the page/UI code completely unchanged regardless of whether the
// data came from the API or from the local demo fallback.
// ─────────────────────────────────────────────────────────────────────────

class ProjectModel {
  final String id;
  final String imageGradientKey;
  final bool reraApproved;
  final bool readyToMove;
  final String name;
  final String location;
  final String startingPrice;
  final String developer;
  final String bhkTypes;
  final int totalUnits;
  final String possession;
  final int interested;
  final String distance;

  const ProjectModel({
    required this.id,
    required this.imageGradientKey,
    required this.reraApproved,
    required this.readyToMove,
    required this.name,
    required this.location,
    required this.startingPrice,
    required this.developer,
    required this.bhkTypes,
    required this.totalUnits,
    required this.possession,
    required this.interested,
    required this.distance,
  });

  /// Maps a real API [PropertyModel] into the shape the UI expects.
  factory ProjectModel.fromProperty(PropertyModel p, {int index = 0}) {
    const gradients = ['dark_blue', 'dark_teal', 'dark_yellow'];

    return ProjectModel(
      id: p.id,
      imageGradientKey: gradients[index % gradients.length],
      reraApproved: p.approvalStatus.toLowerCase() == 'approved',
      readyToMove:
          p.ageOfProperty.toLowerCase().contains('ready') ||
          p.ageOfProperty.trim() == '0',
      name: p.title,
      location: p.locality.isNotEmpty ? '${p.locality}, ${p.city}' : p.city,
      startingPrice: _formatPrice(p.price),
      developer: p.owner.name,
      bhkTypes: p.bedrooms.isNotEmpty ? '${p.bedrooms} BHK' : '-',
      totalUnits: p.tokensCount,
      possession: p.readyToMove_ageLabel,
      interested: p.shortlistedCount,
      distance: '-',
    );
  }

  static String _formatPrice(int price) {
    if (price >= 10000000) {
      return '₹${(price / 10000000).toStringAsFixed(2)} Cr';
    } else if (price >= 100000) {
      return '₹${(price / 100000).toStringAsFixed(1)} L';
    }
    return '₹$price';
  }
}

/// Small helper kept off the model class body so PropertyModel itself
/// doesn't need to change.
extension _PossessionLabel on PropertyModel {
  String get readyToMove_ageLabel {
    if (ageOfProperty.trim().isEmpty) return 'TBD';
    return ageOfProperty;
  }
}

// ─────────────────────────────────────────────────────────────────────────
// Demo fallback data — shown only when the API has no data yet
// (null response, empty properties list, or a load error).
// ─────────────────────────────────────────────────────────────────────────

final List<ProjectModel> demoProjects = [
  

];

// ─────────────────────────────────────────────────────────────────────────
// Derived provider: what the page actually renders.
// Real data when available, demo data otherwise — computed from the
// single source of truth (projectControllerProvider), no separate
// "newProjectsProvider" needed.
// ─────────────────────────────────────────────────────────────────────────

final displayedProjectsProvider = Provider<List<ProjectModel>>((ref) {
  final async = ref.watch(projectControllerProvider);

  return async.when(
    data: (response) {
      final properties = response?.data.properties ?? const [];
      if (properties.isEmpty) return demoProjects;
      return [
        for (var i = 0; i < properties.length; i++)
          ProjectModel.fromProperty(properties[i], index: i),
      ];
    },
    loading: () => demoProjects,
    error: (_, __) => demoProjects,
  );
});

/// Whether we're currently showing demo data (so the UI can, if it wants,
/// show a subtle "showing sample projects" hint).
final isShowingDemoDataProvider = Provider<bool>((ref) {
  final async = ref.watch(projectControllerProvider);
  return async.when(
    data: (response) => (response?.data.properties ?? const []).isEmpty,
    loading: () => true,
    error: (_, __) => true,
  );
});

/// Simple chip filter state (All / 2 BHK / 3 BHK / 4 BHK / Ready to Move).
/// This replaces the filter state that used to live on newProjectsProvider.
final selectedChipFilterProvider = StateProvider<String>((ref) => 'All');
