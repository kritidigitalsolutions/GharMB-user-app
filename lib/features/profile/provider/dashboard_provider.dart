import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/features/profile/models/models.dart';
import 'package:riverpod/legacy.dart';

// ─── Dashboard Stats Provider ─────────────────────────────────
final dashboardStatsProvider = Provider<DashboardStats>((ref) {
  return const DashboardStats(
    totalListings: 12,
    liveListings: 4,
    pendingTokens: 3,
    acceptedTokens: 2,
    views: 156,
    shortlisted: 23,
    inquiries: 12,
    tokenReceived: 3,
    newTokenRequests: 3,
  );
});

// ─── Properties Provider ──────────────────────────────────────
final propertiesProvider = Provider<List<PropertyModel>>((ref) {
  return const [
    PropertyModel(
      id: '1',
      title: 'Skyline Heights – 3 BHK Apartment',
      location: 'Sector 62, Noida',
      views: 156,
      shortlisted: 23,
      tokens: 2,
      isLive: true,
      status: 'Live',
      imageUrl: 'https://via.placeholder.com/80x60',
    ),
    PropertyModel(
      id: '2',
      title: 'Skyline Heights – 3 BHK Apartment',
      location: 'Sector 87, Noida',
      views: 156,
      shortlisted: 23,
      tokens: 2,
      isLive: false,
      status: 'Pending',
      imageUrl: 'https://via.placeholder.com/80x60',
    ),
    PropertyModel(
      id: '3',
      title: 'Skyline Heights – 3 BHK Apartment',
      location: 'Sector 62, Noida',
      views: 156,
      shortlisted: 23,
      tokens: 2,
      isLive: false,
      status: 'Rejected',
      imageUrl: 'https://via.placeholder.com/80x60',
    ),
  ];
});

// ─── Selected Period Provider ─────────────────────────────────
final selectedPeriodProvider = StateProvider<String>((ref) => 'This Month');
final dashboardPropertyFilterProvider = StateProvider<String>((ref) => 'Live');
