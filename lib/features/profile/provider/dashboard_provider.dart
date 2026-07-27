import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/features/profile/models/dashboard_model.dart';
import 'package:gharmb_app/features/profile/models/models.dart';
import 'package:gharmb_app/features/profile/repo/profile_repo.dart';
import 'package:riverpod/legacy.dart';

// ─── Repo Provider ─────────────────────────────────────────────
final profileRepoProvider = Provider<ProfileRepo>((ref) => ProfileRepo());

// ─── Raw Dashboard API Data Provider ───────────────────────────
final dashboardDataProvider = FutureProvider<DashboardResponse?>((ref) async {
  final repo = ref.watch(profileRepoProvider);
  return repo.getDashboardData();
});

// ─── Profile Provider ──────────────────────────────────────────
final profileProvider = Provider<ProfileModel?>((ref) {
  final asyncData = ref.watch(dashboardDataProvider);
  return asyncData.value?.data?.profile;
});

// ─── Dashboard Stats Provider ─────────────────────────────────
final dashboardStatsProvider = Provider<DashboardStats>((ref) {
  final asyncData = ref.watch(dashboardDataProvider);
  final data = asyncData.value?.data;

  final counters = data?.counters;
  final performance = data?.performance;

  return DashboardStats(
    totalListings: counters?.totalListings ?? 0,
    liveListings: counters?.liveListings ?? 0,
    pendingTokens: counters?.pendingTokens ?? 0,
    acceptedTokens: counters?.acceptedTokens ?? 0,
    views: performance?.views ?? 0,
    shortlisted: performance?.shortlisted ?? 0,
    inquiries: performance?.inquiries ?? 0,
    tokenReceived: performance?.tokensReceived ?? 0,
    // No dedicated "new token requests" field in the payload —
    // pendingTokens is the closest stand-in until backend adds one.
    newTokenRequests: counters?.pendingTokens ?? 0,
  );
});

// ─── Properties Provider (flattened live/pending/rejected → UI model) ──
final propertiesProvider = Provider<List<PropertyModel>>((ref) {
  final asyncData = ref.watch(dashboardDataProvider);
  final myProperties = asyncData.value?.data?.myProperties;

  if (myProperties == null) return const [];

  List<PropertyModel> mapItems(
    List<PropertyDashboardItem>? items,
    String bucketStatus,
  ) {
    if (items == null) return const [];
    return items.map((item) {
      return PropertyModel(
        id: item.id ?? '',
        title: item.title ?? '',
        location: (item.locality?.isNotEmpty ?? false)
            ? '${item.locality}, ${item.city ?? ''}'
            : (item.city ?? '—'),
        views: item.viewsCount ?? 0,
        shortlisted: item.shortlistedCount ?? 0,
        tokens: item.tokensCount ?? 0,
        isLive: item.isLive ?? false,
        // Use item.statusDisplay when available (it accounts for
        // isLive/approvalStatus), otherwise fall back to which
        // bucket (live/pending/rejected) it came from.
        status: item.statusDisplay != 'Draft'
            ? item.statusDisplay
            : bucketStatus,
        imageUrl: (item.images != null && item.images!.isNotEmpty)
            ? item.images!.first
            : '',
      );
    }).toList();
  }

  return [
    ...mapItems(myProperties.live, 'Live'),
    ...mapItems(myProperties.pending, 'Pending'),
    ...mapItems(myProperties.rejected, 'Rejected'),
  ];
});

// ─── Selected Period Provider ─────────────────────────────────
final selectedPeriodProvider = StateProvider<String>((ref) => 'This Month');
final dashboardPropertyFilterProvider = StateProvider<String>((ref) => 'Live');
