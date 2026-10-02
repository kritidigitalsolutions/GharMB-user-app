import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:gharmb_app/features/wishlist/models/wishlist_response_model.dart';
import 'package:gharmb_app/features/wishlist/repo/wishlist_repo.dart';

// ─── Providers ──────────────────────────────────────────────────

final wishlistRepoProvider = Provider<WishlistRepo>((ref) {
  return WishlistRepo();
});

// ─── Wishlist State Notifier ────────────────────────────────────

class WishlistState {
  final bool isLoading;
  final String? error;
  final List<WishlistItem> items;

  const WishlistState({
    this.isLoading = false,
    this.error,
    this.items = const [],
  });

  WishlistState copyWith({
    bool? isLoading,
    String? error,
    List<WishlistItem>? items,
  }) {
    return WishlistState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      items: items ?? this.items,
    );
  }
}

class WishlistNotifier extends StateNotifier<WishlistState> {
  final WishlistRepo _repo;

  WishlistNotifier(this._repo) : super(const WishlistState()) {
    fetchWishlist();
  }

  /// 📥 Fetch wishlist from API
  Future<void> fetchWishlist() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final res = await _repo.getWishlist();
      if (res != null && res.data != null) {
        state = state.copyWith(
          isLoading: false,
          items: res.data!.wishlist,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          items: [],
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// 🔄 Toggle item in wishlist (Add/Remove)
  Future<bool> toggleWishlist({
    required String propertyId,
    String itemType = 'Property',
  }) async {
    final success = await _repo.toggleWishlist(
      propertyId: propertyId,
      itemType: itemType,
    );
    if (success) {
      await fetchWishlist();
    }
    return success;
  }

  /// 🔍 Check if property is in wishlist
  Future<bool> isWishlisted(String id) async {
    final inLocal = state.items.any(
      (item) => item.id == id || (item.property != null && item.property!.id == id),
    );
    if (inLocal) return true;
    return await _repo.checkWishlist(id);
  }

  /// 🗑 Remove item from wishlist
  Future<bool> removeWishlist(String id) async {
    // Optimistic removal
    final previousItems = state.items;
    state = state.copyWith(
      items: state.items
          .where((item) =>
              item.id != id &&
              (item.property == null || item.property!.id != id))
          .toList(),
    );

    final success = await _repo.removeWishlist(id);
    if (!success) {
      // Revert if API failed
      state = state.copyWith(items: previousItems);
    }
    return success;
  }
}

final wishlistProvider =
    StateNotifierProvider<WishlistNotifier, WishlistState>((ref) {
  final repo = ref.watch(wishlistRepoProvider);
  return WishlistNotifier(repo);
});

// Single property check provider
final checkWishlistProvider =
    FutureProvider.family<bool, String>((ref, id) async {
  final repo = ref.watch(wishlistRepoProvider);
  return repo.checkWishlist(id);
});
