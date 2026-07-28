import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/legacy.dart';
import 'package:gharmb_app/features/profile/models/profile_model.dart';
import 'package:gharmb_app/features/profile/models/update_profile_payload.dart';
import 'package:gharmb_app/features/profile/repo/profile_repo.dart';

// ─── Repo Provider ─────────────────────────────────────────────
final profileRepoProvider = Provider<ProfileRepo>((ref) => ProfileRepo());

// ─── Raw fetched user data (pre-update source of truth) ────────
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

// ─── Editable Profile State (only fields present in payload) ───

class ProfileState {
  final String name;
  final String email;
  final String phone;
  final String city;
  // final String bio;
  // final File? avatar;
  final bool isSaving;
  final String? error;

  const ProfileState({
    this.name = '',
    this.email = '',
    this.phone = '',
    this.city = '',
    // this.bio = '',
    // this.avatar,
    this.isSaving = false,
    this.error,
  });

  ProfileState copyWith({
    String? name,
    String? email,
    String? phone,
    String? city,
    // String? bio,
    // File? avatar,
    bool? isSaving,
    String? error,
  }) => ProfileState(
    name: name ?? this.name,
    email: email ?? this.email,
    phone: phone ?? this.phone,
    city: city ?? this.city,
    // bio: bio ?? this.bio,
    // avatar: avatar ?? this.avatar,
    isSaving: isSaving ?? this.isSaving,
    error: error,
  );
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  final ProfileRepo _repo;
  final Ref _ref;

  ProfileNotifier(this._repo, this._ref) : super(const ProfileState());

  // Pre-fills the editable form with data from the fetch API.
  void hydrate(UserModel user) {
    state = state.copyWith(
      name: user.name ?? '',
      email: user.email ?? '',
      phone: user.phone ?? '',
      city: user.address?.city ?? '',
    );
  }

  void setName(String v) => state = state.copyWith(name: v);
  void setEmail(String v) => state = state.copyWith(email: v);
  void setPhone(String v) => state = state.copyWith(phone: v);
  void setCity(String v) => state = state.copyWith(city: v);
  // void setBio(String v) => state = state.copyWith(bio: v);
  // void setAvatar(File f) => state = state.copyWith(avatar: f);

  Future<bool> save() async {
    state = state.copyWith(isSaving: true, error: null);

    final payload = UserProfilePayload(
      name: state.name,
      email: state.email,
      phone: state.phone,
      city: state.city,
    );

    final result = await _repo.updateProfile(payload: payload);

    state = state.copyWith(isSaving: false);

    if (result == null) {
      state = state.copyWith(error: 'Failed to update profile');
      return false;
    }

    // Refresh fetched data so userModelProvider reflects the latest values.
    _ref.invalidate(userProfileDataProvider);
    return true;
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((
  ref,
) {
  final notifier = ProfileNotifier(ref.watch(profileRepoProvider), ref);

  ref.listen<AsyncValue<UserProfileResponse?>>(userProfileDataProvider, (
    previous,
    next,
  ) {
    final user = next.value?.data?.user;
    if (user != null) {
      notifier.hydrate(user);
    }
  }, fireImmediately: true);

  return notifier;
});

// ─── Invite Friends State ─────────────────────────────────────────────────────

class InviteState {
  final String referralCode;
  final int friendsInvited;
  final int coinsEarned;
  final bool isCopied;

  const InviteState({
    this.referralCode = 'GHARMB-RAHUL42',
    this.friendsInvited = 3,
    this.coinsEarned = 750,
    this.isCopied = false,
  });

  InviteState copyWith({bool? isCopied}) => InviteState(
    referralCode: referralCode,
    friendsInvited: friendsInvited,
    coinsEarned: coinsEarned,
    isCopied: isCopied ?? this.isCopied,
  );
}

class InviteNotifier extends StateNotifier<InviteState> {
  InviteNotifier() : super(const InviteState());

  void setCopied() async {
    state = state.copyWith(isCopied: true);
    await Future.delayed(const Duration(seconds: 2));
    state = state.copyWith(isCopied: false);
  }
}

final inviteProvider = StateNotifierProvider<InviteNotifier, InviteState>(
  (_) => InviteNotifier(),
);
