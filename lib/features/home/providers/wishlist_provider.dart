import 'package:riverpod/legacy.dart';

// ─── Model ────────────────────────────────────────────────────
class WishlistProperty {
  final String id;
  final String title;
  final String location;
  final String price;
  final String area;
  final String bhk;
  final String imageUrl;
  final bool isVerified;

  const WishlistProperty({
    required this.id,
    required this.title,
    required this.location,
    required this.price,
    required this.area,
    required this.bhk,
    required this.imageUrl,
    this.isVerified = false,
  });
}

// ─── State Notifier ───────────────────────────────────────────
class WishlistNotifier extends StateNotifier<List<WishlistProperty>> {
  WishlistNotifier()
    : super(const [
        WishlistProperty(
          id: '1',
          title: 'Skyline Heights',
          location: 'Sector 62, Noida, UP',
          price: '₹45,00,000',
          area: '1480 sq ft',
          bhk: '3 BHK',
          imageUrl: '',
          isVerified: true,
        ),
        WishlistProperty(
          id: '2',
          title: 'Green Valley Apartments',
          location: 'Sector 50, Noida, UP',
          price: '₹32,00,000',
          area: '1100 sq ft',
          bhk: '2 BHK',
          imageUrl: '',
          isVerified: true,
        ),
        WishlistProperty(
          id: '3',
          title: 'Royal Residency',
          location: 'Indirapuram, Ghaziabad',
          price: '₹58,00,000',
          area: '1800 sq ft',
          bhk: '3 BHK',
          imageUrl: '',
          isVerified: false,
        ),
        WishlistProperty(
          id: '4',
          title: 'Palm Grove Villas',
          location: 'Sector 137, Noida, UP',
          price: '₹75,00,000',
          area: '2200 sq ft',
          bhk: '4 BHK',
          imageUrl: '',
          isVerified: true,
        ),
      ]);

  void remove(String id) {
    state = state.where((p) => p.id != id).toList();
  }
}

final wishlistProvider =
    StateNotifierProvider<WishlistNotifier, List<WishlistProperty>>(
      (ref) => WishlistNotifier(),
    );
