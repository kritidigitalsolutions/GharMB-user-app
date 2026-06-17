import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/legacy.dart';

// ─── Models ───────────────────────────────────────────────────
class NewsArticle {
  final String id;
  final String title;
  final String category;
  final String timeAgo;
  final String readTime;
  final String imageUrl;
  final String body;
  final List<RelatedNews> relatedNews;

  const NewsArticle({
    required this.id,
    required this.title,
    required this.category,
    required this.timeAgo,
    required this.readTime,
    required this.imageUrl,
    this.body = '',
    this.relatedNews = const [],
  });
}

class RelatedNews {
  final String id;
  final String title;
  const RelatedNews({required this.id, required this.title});
}

// ─── Providers ────────────────────────────────────────────────
const _dummyBody =
    "The Reserve Bank of India's Monetary Policy Committee (MPC) voted unanimously to hold "
    "the repo rate at 6.5%, marking the 5th consecutive pause. This means home loan "
    "borrowers on floating rates will see no change in their EMIs for at least the next quarter.\n\n"
    "Banks like SBI, HDFC, and ICICI are expected to maintain their current home loan rates "
    "ranging from 8.5% to 9.2%. Analysts believe this stability is encouraging fence-sitters to "
    "commit to property purchases.";

const _articles = [
  NewsArticle(
    id: '1',
    title:
        'RBI holds repo rate at 6.5% — home loan EMIs stay stable this quarter',
    category: 'Policy',
    timeAgo: '2 hrs ago',
    readTime: '3 min read',
    imageUrl: '',
    body: _dummyBody,
    relatedNews: [
      RelatedNews(
        id: 'r1',
        title: 'Budget 2025 — home loan deduction raised to ₹75L',
      ),
      RelatedNews(id: 'r2', title: 'Noida prices up 12% — should you buy now?'),
    ],
  ),
  NewsArticle(
    id: '2',
    title:
        'RBI holds repo rate at 6.5% — home loan EMIs stay stable this quarter',
    category: 'Prices',
    timeAgo: '2 hrs ago',
    readTime: '3 min read',
    imageUrl: '',
    body: _dummyBody,
    relatedNews: [
      RelatedNews(
        id: 'r1',
        title: 'Budget 2025 — home loan deduction raised to ₹75L',
      ),
      RelatedNews(id: 'r2', title: 'Noida prices up 12% — should you buy now?'),
    ],
  ),
  NewsArticle(
    id: '3',
    title:
        'RBI holds repo rate at 6.5% — home loan EMIs stay stable this quarter',
    category: 'New launches',
    timeAgo: '2 hrs ago',
    readTime: '3 min read',
    imageUrl: '',
    body: _dummyBody,
    relatedNews: [
      RelatedNews(
        id: 'r1',
        title: 'Budget 2025 — home loan deduction raised to ₹75L',
      ),
      RelatedNews(id: 'r2', title: 'Noida prices up 12% — should you buy now?'),
    ],
  ),
  NewsArticle(
    id: '4',
    title:
        'RBI holds repo rate at 6.5% — home loan EMIs stay stable this quarter',
    category: 'RBI & rates',
    timeAgo: '2 hrs ago',
    readTime: '3 min read',
    imageUrl: '',
    body: _dummyBody,
    relatedNews: [
      RelatedNews(
        id: 'r1',
        title: 'Budget 2025 — home loan deduction raised to ₹75L',
      ),
      RelatedNews(id: 'r2', title: 'Noida prices up 12% — should you buy now?'),
    ],
  ),
];

const _categories = [
  'Policy',
  'Prices',
  'New launches',
  'RBI & rates',
  'Market',
];

// Selected category tab
final newsCategoryProvider = StateProvider<String>((ref) => 'Policy');

// Selected article (for detail page)
final selectedArticleProvider = StateProvider<NewsArticle?>((ref) => null);

// All articles
final newsArticlesProvider = Provider<List<NewsArticle>>((ref) => _articles);

// Filtered articles by category
final filteredNewsProvider = Provider<List<NewsArticle>>((ref) {
  final cat = ref.watch(newsCategoryProvider);
  return _articles; // In real app, filter by category
});

// Categories list
final newsCategoriesProvider = Provider<List<String>>((ref) => _categories);

// Load more state
final newsPageProvider = StateProvider<int>((ref) => 1);
