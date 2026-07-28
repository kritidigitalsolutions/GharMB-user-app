import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/real_state_news/models/news_detail_response_model.dart';
import 'package:gharmb_app/features/real_state_news/models/news_response_model.dart';
import 'package:gharmb_app/features/real_state_news/providers/news_provider.dart';
import 'package:gharmb_app/routes/app_page.dart';
import 'package:gharmb_app/shared/button/custom_button.dart';
import 'package:go_router/go_router.dart';

class NewsDetailPage extends ConsumerStatefulWidget {
  const NewsDetailPage({super.key});

  @override
  ConsumerState<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends ConsumerState<NewsDetailPage> {
  String? _newsId;

  @override
  void initState() {
    super.initState();
    // Grab the id the list page set right before navigating here, and lock
    // it in for the lifetime of this page instance. Using initState (not
    // build/watch) means if the user taps a "related" card that updates
    // selectedNewsIdProvider, *this* page keeps showing its own article —
    // only the freshly pushed page instance picks up the new id.
    _newsId = ref.read(selectedNewsIdProvider);
  }

  @override
  Widget build(BuildContext context) {
    final newsId = _newsId;
    if (newsId == null) {
      return const Scaffold(body: Center(child: Text('No article selected')));
    }

    final detailAsync = ref.watch(newsDetailProvider(newsId));

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: detailAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Could not load this article',
                    style: text14(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$err',
                    style: text12(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => ref.invalidate(newsDetailProvider(newsId)),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
          data: (article) {
            if (article == null) {
              return const Center(child: Text('Article not found'));
            }
            return _NewsDetailContent(article: article);
          },
        ),
      ),
    );
  }
}

// ─── Detail content (once the real article has loaded) ────────────────────
class _NewsDetailContent extends ConsumerWidget {
  final NewsDetail article;
  const _NewsDetailContent({required this.article});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // ── Header ───────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Row(
            children: [
              CustomBackButton(),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      style: text15(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Stay ahead of the market',
                      style: text11(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const Icon(
                Icons.share_outlined,
                size: 20,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // ── Scrollable Content ────────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category + meta
                Row(
                  children: [
                    _CategoryBadge(
                      label: article.category.toNewsCategory().displayName,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${article.formattedPublishedAt}  •  ${article.readTimeDisplay}',
                      style: text11(color: AppColors.grey400),
                    ),
                    const Spacer(),
                    Text(
                      'NestKey News',
                      style: text11(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Hero image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _ArticleImage(imageUrl: article.image),
                ),
                const SizedBox(height: 16),

                // Title
                Text(article.title, style: text18(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),

                // Body paragraphs (real description from the API)
                ...article.description
                    .split('\n\n')
                    .where((p) => p.trim().isNotEmpty)
                    .map(
                      (para) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Text(
                          para,
                          style: text13(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.normal,
                          ).copyWith(height: 1.65),
                        ),
                      ),
                    ),
                const SizedBox(height: 8),

                // Related news — up to 4 other articles from the same category
                _RelatedNewsSection(
                  category: article.category,
                  currentId: article.id,
                ),

                // Back to news feed button
                AppButton(
                  title: "Back to news feed",
                  onTap: () {
                    context.pop();
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Related News (fetched, same category, capped at 4) ───────────────────
class _RelatedNewsSection extends ConsumerWidget {
  final String category;
  final String currentId;

  const _RelatedNewsSection({required this.category, required this.currentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // NOTE: deliberately NOT using categoryNewsProvider(category) here.
    // That calls NewsRepo.categoryNews(categoryId: ...), and if the backend
    // expects a real category-document id rather than the plain string
    // stored on News.category (e.g. "policy"), the server-side filter
    // silently fails to match and you get back unrelated articles.
    // allNewsProvider already has every article with its real `category`
    // string, so filtering here guarantees "related" actually means
    // same category — no trusting the endpoint's own filtering.
    final allNewsAsync = ref.watch(allNewsProvider);

    return allNewsAsync.when(
      // Keep the detail page uncluttered if related news is still loading
      // or failed — the article itself already rendered above.
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (allNews) {
        final related = allNews
            .where((n) => n.category == category && n.id != currentId)
            .take(4)
            .toList();

        if (related.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Related news', style: text15(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            ...related.map(
              (r) => _RelatedNewsCard(
                article: r,
                onTap: () {
                  ref.read(selectedNewsIdProvider.notifier).state = r.id;
                  context.pushNamed(AppPage.newsDetailsName);
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }
}

// ─── Category Badge ────────────────────────────────────────────
class _CategoryBadge extends StatelessWidget {
  final String label;
  const _CategoryBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: text11(color: AppColors.white, fontWeight: FontWeight.w600),
      ),
    );
  }
}

// ─── Article Image ─────────────────────────────────────────────
class _ArticleImage extends StatelessWidget {
  final String imageUrl;
  const _ArticleImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        height: 190,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const _ArticleImagePlaceholder(),
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const SizedBox(
            height: 190,
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        },
      );
    }
    return const _ArticleImagePlaceholder();
  }
}

class _ArticleImagePlaceholder extends StatelessWidget {
  const _ArticleImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A1035), Color(0xFF4A2060), Color(0xFFE8956D)],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'THE NEW',
              style: text16(
                fontWeight: FontWeight.w900,
                color: AppColors.white.withOpacity(0.9),
              ),
            ),
            Text(
              'BUSINESS',
              style: text20(
                fontWeight: FontWeight.w900,
                color: AppColors.white.withOpacity(0.9),
              ),
            ),
            Text(
              'Era',
              style: appTextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w300,
                color: AppColors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Related News Card ─────────────────────────────────────────
class _RelatedNewsCard extends StatelessWidget {
  final News article;
  final VoidCallback onTap;

  const _RelatedNewsCard({required this.article, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.grey200),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                article.title,
                style: text13(fontWeight: FontWeight.w500),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 10),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Small formatting helpers for NewsDetail ────────────────────────────
// NewsDetail doesn't carry the same extension methods as News
// (see NewsExtension in news_response_model.dart), so mirror the two we
// need here rather than duplicating them into the model file.
extension _NewsDetailFormatting on NewsDetail {
  String get formattedPublishedAt {
    final now = DateTime.now();
    final difference = now.difference(publishedAt);

    if (difference.inDays > 0) {
      if (difference.inDays == 1) return 'Yesterday';
      if (difference.inDays < 7) return '${difference.inDays} days ago';
      if (difference.inDays < 30) return '${difference.inDays ~/ 7} weeks ago';
      if (difference.inDays < 365) {
        return '${difference.inDays ~/ 30} months ago';
      }
      return '${difference.inDays ~/ 365} years ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hr${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} min${difference.inMinutes > 1 ? 's' : ''} ago';
    }
    return 'Just now';
  }

  String get readTimeDisplay => '$readTime min read';
}
