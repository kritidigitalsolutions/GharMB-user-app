import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';
import 'package:gharmb_app/features/real_state_news/providers/news_provider.dart';
import 'package:gharmb_app/shared/button/custom_button.dart';
import 'package:go_router/go_router.dart';

class NewsDetailPage extends ConsumerWidget {
  const NewsDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final article = ref.watch(selectedArticleProvider);
    if (article == null) {
      return const Scaffold(body: Center(child: Text('No article selected')));
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
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
                        _CategoryBadge(label: article.category),
                        const SizedBox(width: 10),
                        Text(
                          '${article.timeAgo}  •  ${article.readTime}',
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
                      child: _ArticleImage(),
                    ),
                    const SizedBox(height: 16),

                    // Title
                    Text(
                      article.title,
                      style: text18(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),

                    // Body paragraphs
                    ...article.body
                        .split('\n\n')
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

                    // Related News
                    if (article.relatedNews.isNotEmpty) ...[
                      Text(
                        'Related news',
                        style: text15(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 12),
                      ...article.relatedNews.map(
                        (r) => _RelatedNewsCard(title: r.title),
                      ),
                      const SizedBox(height: 20),
                    ],

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
        ),
      ),
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
  final String title;
  const _RelatedNewsCard({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
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
              title,
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
    );
  }
}
