// project_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/data/network/network_api_service.dart';
import 'package:gharmb_app/features/project/model/propert_response_mode.dart';
import 'package:gharmb_app/features/project/repo/project_repo.dart';

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
}
