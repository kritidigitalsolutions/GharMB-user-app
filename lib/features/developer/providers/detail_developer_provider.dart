import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/data/network/network_api_service.dart';
import 'package:gharmb_app/features/developer/model/response/detail_developer_model.dart';
import 'package:gharmb_app/features/developer/repo/developer_repo.dart';

// 1. Provide the NetworkApiService (if you don't already have a provider)
final networkApiServiceProvider = Provider<NetworkApiService>((ref) {
  return NetworkApiService(); // adjust constructor if needed
});

// 2. Provide the DeveloperRepo
final developerRepoProvider = Provider<DeveloperRepo>((ref) {
  final api = ref.watch(networkApiServiceProvider);
  return DeveloperRepo(networkApiService: api);
});

// 3. The family provider for detailDeveloper – pass a developer ID
final developerDetailProvider = FutureProvider.family<DeveloperDetailResponse?, String>((ref, id) async {
  final repo = ref.watch(developerRepoProvider);
  return repo.detailDeveloper(id: id);
});