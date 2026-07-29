import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:gharmb_app/core/data/network/network_api_service.dart';
import 'package:gharmb_app/features/developer/model/response/all_developer_response.dart';
import 'package:gharmb_app/features/developer/repo/developer_repo.dart';

// ─── Models ───────────────────────────────────────────────────────────────────

class DeveloperModel {
  final String id;
  final String name;
  final String coverage;
  final int projects;
  final double rating;
  final String reviewCount;
  final bool reraApproved;
  final bool isoCertified;
  final bool bseListed;
  final String established;
  final int unitsDelivered;
  final int cities;
  final String about;
  final List<ReviewModel> reviews;

  const DeveloperModel({
    required this.id,
    required this.name,
    required this.coverage,
    required this.projects,
    required this.rating,
    required this.reviewCount,
    required this.reraApproved,
    required this.isoCertified,
    required this.bseListed,
    required this.established,
    required this.unitsDelivered,
    required this.cities,
    required this.about,
    required this.reviews,
  });
}

class ReviewModel {
  final String name;
  final String initials;
  final double rating;
  final String review;
  final String projectBought;
  final String timeAgo;

  const ReviewModel({
    required this.name,
    required this.initials,
    required this.rating,
    required this.review,
    required this.projectBought,
    required this.timeAgo,
  });
}

// ─── Demo reviews (API doesn't return reviews yet — kept for the rating UI) ───

const _demoReviews = [
  ReviewModel(
    name: 'Anil Verma',
    initials: 'AV',
    rating: 5.0,
    review:
        'Excellent construction quality. Delivered on time. The admin team at NestKey made the entire process smooth.',
    projectBought: 'Bought a premium project',
    timeAgo: '2 weeks ago',
  ),
  ReviewModel(
    name: 'Priya Sharma',
    initials: 'PS',
    rating: 4.5,
    review:
        'Great project. Construction quality is top-notch. Would highly recommend to anyone looking for premium homes.',
    projectBought: 'Bought a premium project',
    timeAgo: '1 month ago',
  ),
];

// ─── Mapper: API Developer -> DeveloperModel ──────────────────────────────────

DeveloperModel _mapDeveloper(Developer d) {
  return DeveloperModel(
    id: d.id,
    name: d.companyName.isNotEmpty ? d.companyName : d.name,
    coverage: '${d.cityOfOperation} · ${d.projectCountDisplay}',
    projects: d.projectCount,
    rating: d.rating,
    reviewCount: '${d.reviewCount} reviews',
    // Not returned by the API yet — kept as demo flags for the badges UI.
    reraApproved: true,
    isoCertified: true,
    bseListed: false,
    established: 'Est. ${d.yearsInBusiness}',
    unitsDelivered: 0,
    cities: 1,
    about:
        '${d.name} has been delivering quality projects across ${d.cityOfOperation} for ${d.yearsInBusiness}.',
    // API has no reviews field yet — demo rating section preserved here.
    reviews: _demoReviews,
  );
}

// ─── Providers ────────────────────────────────────────────────────────────────

final _cities = ['All India', 'Noida', 'Gurgaon', 'Mumbai', 'Bangalore'];

final developerRepoProvider = Provider<DeveloperRepo>(
  (ref) => DeveloperRepo(networkApiService: NetworkApiService()),
);

// Raw API call
final allDevelopersDataProvider = FutureProvider<AllDeveloperResponse?>((
  ref,
) async {
  final repo = ref.watch(developerRepoProvider);
  return repo.allDevelopers();
});

class DeveloperListState {
  final List<DeveloperModel> developers;
  final String selectedCity;
  final bool showAll;

  const DeveloperListState({
    this.developers = const [],
    this.selectedCity = 'All India',
    this.showAll = false,
  });

  DeveloperListState copyWith({
    List<DeveloperModel>? developers,
    String? selectedCity,
    bool? showAll,
  }) => DeveloperListState(
    developers: developers ?? this.developers,
    selectedCity: selectedCity ?? this.selectedCity,
    showAll: showAll ?? this.showAll,
  );

  List<DeveloperModel> get visibleDevelopers =>
      showAll ? developers : developers.take(6).toList();
}

class DeveloperListNotifier extends StateNotifier<DeveloperListState> {
  DeveloperListNotifier() : super(const DeveloperListState());

  void setCity(String c) => state = state.copyWith(selectedCity: c);
  void toggleShowAll() => state = state.copyWith(showAll: !state.showAll);

  // Called once the API data resolves.
  void hydrate(List<DeveloperModel> developers) {
    state = state.copyWith(developers: developers);
  }
}

final developerListProvider =
    StateNotifierProvider<DeveloperListNotifier, DeveloperListState>((ref) {
      final notifier = DeveloperListNotifier();

      ref.listen<AsyncValue<AllDeveloperResponse?>>(allDevelopersDataProvider, (
        previous,
        next,
      ) {
        final list = next.value?.data.developers;
        if (list != null) {
          notifier.hydrate(list.map(_mapDeveloper).toList());
        }
      }, fireImmediately: true);

      return notifier;
    });

final selectedDeveloperProvider = StateProvider<DeveloperModel?>((ref) => null);

final citiesProvider = Provider<List<String>>((_) => _cities);
