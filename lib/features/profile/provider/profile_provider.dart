import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/legacy.dart';

// ─── Profile State ────────────────────────────────────────────────────────────

class ProfileState {
  final String name;
  final String email;
  final String phone;
  final String city;
  final String bio;
  final File? avatar;
  final bool isSaving;

  const ProfileState({
    this.name = 'Rahul Sharma',
    this.email = 'rahul.sharma@gmail.com',
    this.phone = '+91 98765 43210',
    this.city = 'Noida, Uttar Pradesh',
    this.bio = 'Looking for a 3 BHK in Noida or Gurgaon.',
    this.avatar,
    this.isSaving = false,
  });

  ProfileState copyWith({
    String? name,
    String? email,
    String? phone,
    String? city,
    String? bio,
    File? avatar,
    bool? isSaving,
  }) => ProfileState(
    name: name ?? this.name,
    email: email ?? this.email,
    phone: phone ?? this.phone,
    city: city ?? this.city,
    bio: bio ?? this.bio,
    avatar: avatar ?? this.avatar,
    isSaving: isSaving ?? this.isSaving,
  );
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  ProfileNotifier() : super(const ProfileState());

  void setName(String v) => state = state.copyWith(name: v);
  void setEmail(String v) => state = state.copyWith(email: v);
  void setPhone(String v) => state = state.copyWith(phone: v);
  void setCity(String v) => state = state.copyWith(city: v);
  void setBio(String v) => state = state.copyWith(bio: v);
  void setAvatar(File f) => state = state.copyWith(avatar: f);

  Future<bool> save() async {
    state = state.copyWith(isSaving: true);
    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(isSaving: false);
    return true;
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>(
  (_) => ProfileNotifier(),
);

// ─── My Properties State ──────────────────────────────────────────────────────

enum MyPropertyStatus { live, pending, rejected }

class MyPropertyModel {
  final String id;
  final String title;
  final String location;
  final String price;
  final String type;
  final MyPropertyStatus status;
  final int views;
  final int enquiries;
  final int tokens;
  final String postedOn;
  final String gradientKey;

  const MyPropertyModel({
    required this.id,
    required this.title,
    required this.location,
    required this.price,
    required this.type,
    required this.status,
    required this.views,
    required this.enquiries,
    required this.tokens,
    required this.postedOn,
    required this.gradientKey,
  });
}

final myPropertiesProvider = Provider<List<MyPropertyModel>>(
  (_) => [
    const MyPropertyModel(
      id: 'mp1',
      title: 'Skyline Heights — 3 BHK',
      location: 'Sector 62, Noida',
      price: '₹85 Lakhs',
      type: '3 BHK Apartment',
      status: MyPropertyStatus.live,
      views: 156,
      enquiries: 23,
      tokens: 2,
      postedOn: '12 Jun 2025',
      gradientKey: 'blue',
    ),
    const MyPropertyModel(
      id: 'mp2',
      title: 'Green Valley — 2 BHK',
      location: 'Sector 18, Noida',
      price: '₹55 Lakhs',
      type: '2 BHK Apartment',
      status: MyPropertyStatus.pending,
      views: 0,
      enquiries: 0,
      tokens: 0,
      postedOn: '10 Jun 2025',
      gradientKey: 'teal',
    ),
    const MyPropertyModel(
      id: 'mp3',
      title: 'Royal Residency — 4 BHK',
      location: 'Greater Noida West',
      price: '₹1.2 Cr',
      type: '4 BHK Villa',
      status: MyPropertyStatus.rejected,
      views: 0,
      enquiries: 0,
      tokens: 0,
      postedOn: '08 Jun 2025',
      gradientKey: 'gold',
    ),
  ],
);

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
