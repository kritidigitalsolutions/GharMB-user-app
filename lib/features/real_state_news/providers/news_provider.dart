import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/features/real_state_news/repo/news_repo.dart';
import 'package:riverpod/legacy.dart';

import 'package:gharmb_app/features/real_state_news/models/news_response_model.dart';
import 'package:gharmb_app/features/real_state_news/models/featured_news_response_model.dart';
import 'package:gharmb_app/features/real_state_news/models/news_detail_response_model.dart';

// NOTE: adjust the `news_repo.dart` import path above to match wherever
// NewsRepo actually lives in your project (e.g. .../repo/news_repo.dart).

// ─── Repo provider ────────────────────────────────────────────────────────

final newsRepoProvider = Provider<NewsRepo>((ref) => NewsRepo());

// ─── UI selection state ───────────────────────────────────────────────────

/// Selected category tab. "All" is a synthetic value meaning "no filter" —
/// every other value is one of the *raw* category strings returned by the
/// API (e.g. `policy`, `prices`, `rbi_rates`...), never hardcoded.
final newsCategoryProvider = StateProvider<String>((ref) => 'All');

/// Id of the article currently open on the detail page. The detail page
/// reads this id and watches `newsDetailProvider(id)` to fetch real data.
final selectedNewsIdProvider = StateProvider<String?>((ref) => null);

/// Simple page counter, kept for "load more" UI. Wire it into
/// `NewsRepo.allNews()` / `categoryNews()` once those endpoints support a
/// page/limit query param — the repo above doesn't take one yet.
final newsPageProvider = StateProvider<int>((ref) => 1);

// ─── Data providers (real API, no dummy data) ─────────────────────────────

/// All news, straight from `NewsRepo.allNews()`.
final allNewsProvider = FutureProvider<List<News>>((ref) async {
  final repo = ref.watch(newsRepoProvider);
  final response = await repo.allNews();
  return response?.data.news ?? [];
});

/// Featured news, straight from `NewsRepo.allFeaturedNews()`.
final featuredNewsProvider = FutureProvider<List<FeaturedNews>>((ref) async {
  final repo = ref.watch(newsRepoProvider);
  final response = await repo.allFeaturedNews();
  return response?.data.news ?? [];
});

/// News for one specific category, straight from `NewsRepo.categoryNews()`.
/// Only hit when the user picks a real category (not "All").
final categoryNewsProvider = FutureProvider.family<List<News>, String>((
  ref,
  categoryId,
) async {
  final repo = ref.watch(newsRepoProvider);
  final response = await repo.categoryNews(categoryId: categoryId);
  return response?.data.news ?? [];
});

/// Full detail for a single article, straight from `NewsRepo.newsDetail()`.
final newsDetailProvider = FutureProvider.family<NewsDetail?, String>((
  ref,
  id,
) async {
  final repo = ref.watch(newsRepoProvider);
  final response = await repo.newsDetail(id: id);
  return response?.data.news;
});

// ─── Categories, derived from real data (no hardcoded list) ───────────────

/// The category chips shown in the UI. Built from the *actual* `category`
/// field on whatever `allNews` returned, de-duplicated, so if the backend
/// adds/removes a category the app just picks it up — nothing to edit here.
final newsCategoriesProvider = Provider<List<String>>((ref) {
  final newsAsync = ref.watch(allNewsProvider);

  return newsAsync.when(
    data: (newsList) {
      final rawCategories = newsList.map((n) => n.category).toSet().toList()
        ..sort();
      return ['All', ...rawCategories];
    },
    loading: () => const ['All'],
    error: (_, __) => const ['All'],
  );
});

/// Same as above, but as display-friendly labels (e.g. "RBI Rates" instead
/// of "rbi_rates") using the `NewsCategoryExtension` from the news model.
/// Pair this with `newsCategoriesProvider` (raw values) 1:1 by index if you
/// need to show a pretty label but filter on the raw value.
final newsCategoryLabelsProvider = Provider<List<String>>((ref) {
  final rawCategories = ref.watch(newsCategoriesProvider);
  return rawCategories.map((c) {
    if (c == 'All') return 'All';
    return c.toNewsCategory().displayName;
  }).toList();
});

// ─── Filtered feed, respecting the selected category ──────────────────────

/// The list actually shown on the feed screen. "All" reuses `allNewsProvider`;
/// any real category re-fetches from the server via `categoryNewsProvider`
/// so filtering isn't just client-side guesswork.
final filteredNewsProvider = Provider<AsyncValue<List<News>>>((ref) {
  final selectedCategory = ref.watch(newsCategoryProvider);

  if (selectedCategory == 'All') {
    return ref.watch(allNewsProvider);
  }
  return ref.watch(categoryNewsProvider(selectedCategory));
});
