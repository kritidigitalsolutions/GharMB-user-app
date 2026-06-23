import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

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

// ─── Dummy Data ───────────────────────────────────────────────────────────────

final _developers = [
  DeveloperModel(
    id: 'd1',
    name: 'Godrej Properties',
    coverage: 'Pan India · 80+ projects',
    projects: 80,
    rating: 4.9,
    reviewCount: '12K reviews',
    reraApproved: true,
    isoCertified: true,
    bseListed: true,
    established: 'Est. 1990 · BSE listed',
    unitsDelivered: 15000,
    cities: 12,
    about:
        'Godrej Properties brings the Godrej Group philosophy of innovation, sustainability and excellence to the real estate industry. They have won over 250 awards for excellence in construction, design and delivery. All projects are IGBC green-rated.',
    reviews: const [
      ReviewModel(
        name: 'Anil Verma',
        initials: 'AV',
        rating: 5.0,
        review:
            'Excellent construction quality. Delivered on time. The admin team at NestKey made the entire process smooth.',
        projectBought: 'Bought Godrej Meridian',
        timeAgo: '2 weeks ago',
      ),
      ReviewModel(
        name: 'Priya Sharma',
        initials: 'PS',
        rating: 4.5,
        review:
            'Great project. Construction quality is top-notch. Would highly recommend to anyone looking for premium homes.',
        projectBought: 'Bought Godrej Palm Grove',
        timeAgo: '1 month ago',
      ),
    ],
  ),
  DeveloperModel(
    id: 'd2',
    name: 'Godrej Properties',
    coverage: 'Pan India · 80+ projects',
    projects: 80,
    rating: 4.9,
    reviewCount: '12K reviews',
    reraApproved: true,
    isoCertified: true,
    bseListed: false,
    established: 'Est. 1990',
    unitsDelivered: 15000,
    cities: 12,
    about:
        'Godrej Properties brings the Godrej Group philosophy of innovation, sustainability and excellence to the real estate industry.',
    reviews: const [
      ReviewModel(
        name: 'Rahul Gupta',
        initials: 'RG',
        rating: 4.5,
        review: 'Good construction quality. On-time delivery.',
        projectBought: 'Bought Godrej Heights',
        timeAgo: '3 weeks ago',
      ),
    ],
  ),
  DeveloperModel(
    id: 'd3',
    name: 'Godrej Properties',
    coverage: 'Pan India · 80+ projects',
    projects: 80,
    rating: 4.9,
    reviewCount: '12K reviews',
    reraApproved: true,
    isoCertified: true,
    bseListed: false,
    established: 'Est. 1990',
    unitsDelivered: 15000,
    cities: 12,
    about: 'Award-winning real estate developer with presence across India.',
    reviews: const [],
  ),
  DeveloperModel(
    id: 'd4',
    name: 'Godrej Properties',
    coverage: 'Pan India · 80+ projects',
    projects: 80,
    rating: 4.9,
    reviewCount: '12K reviews',
    reraApproved: true,
    isoCertified: true,
    bseListed: false,
    established: 'Est. 1990',
    unitsDelivered: 15000,
    cities: 12,
    about: 'Delivering quality homes for over 30 years.',
    reviews: const [],
  ),
  DeveloperModel(
    id: 'd5',
    name: 'Godrej Properties',
    coverage: 'Pan India · 80+ projects',
    projects: 80,
    rating: 4.9,
    reviewCount: '12K reviews',
    reraApproved: true,
    isoCertified: true,
    bseListed: false,
    established: 'Est. 1990',
    unitsDelivered: 15000,
    cities: 12,
    about: 'Green-rated projects with world-class amenities.',
    reviews: const [],
  ),
  DeveloperModel(
    id: 'd6',
    name: 'Godrej Properties',
    coverage: 'Pan India · 80+ projects',
    projects: 80,
    rating: 4.9,
    reviewCount: '12K reviews',
    reraApproved: true,
    isoCertified: true,
    bseListed: false,
    established: 'Est. 1990',
    unitsDelivered: 15000,
    cities: 12,
    about: 'Trusted by millions of homebuyers across the country.',
    reviews: const [],
  ),
];

// ─── Providers ────────────────────────────────────────────────────────────────

final _cities = ['All India', 'Noida', 'Gurgaon', 'Mumbai', 'Bangalore'];

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
  DeveloperListNotifier() : super(DeveloperListState(developers: _developers));

  void setCity(String c) => state = state.copyWith(selectedCity: c);
  void toggleShowAll() => state = state.copyWith(showAll: !state.showAll);
}

final developerListProvider =
    StateNotifierProvider<DeveloperListNotifier, DeveloperListState>(
      (_) => DeveloperListNotifier(),
    );

final selectedDeveloperProvider = StateProvider<DeveloperModel?>((ref) => null);

final citiesProvider = Provider<List<String>>((_) => _cities);
