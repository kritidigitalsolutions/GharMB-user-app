import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/features/profile/models/profile_model.dart';
import 'package:gharmb_app/features/profile/repo/profile_repo.dart';

// ─── Repo Provider ─────────────────────────────────────────────
final profileRepoProvider = Provider<ProfileRepo>((ref) => ProfileRepo());

// ─── Raw User Profile API Data Provider ────────────────────────
final userProfileDataProvider = FutureProvider<UserProfileResponse?>((
  ref,
) async {
  final repo = ref.watch(profileRepoProvider);
  return repo.getUser();
});

// ─── Convenience Provider — just the UserModel ─────────────────
final userModelProvider = Provider<UserModel?>((ref) {
  final asyncData = ref.watch(userProfileDataProvider);
  return asyncData.value?.data?.user;
});
