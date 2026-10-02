class ReviewPayload {
  final int rating;
  final String comment;
  final String tag;
  final List<String> tags;
  final List<String> whatAreYouRating;

  ReviewPayload({
    required this.rating,
    required this.comment,
    this.tag = '',
    this.tags = const [],
    this.whatAreYouRating = const [],
  });

  Map<String, dynamic> toJson() {
    final List<String> effectiveTags = whatAreYouRating.isNotEmpty
        ? whatAreYouRating
        : (tags.isNotEmpty
            ? tags
            : (tag.isNotEmpty ? tag.split(',').map((e) => e.trim()).toList() : []));

    final String effectiveTagStr = tag.isNotEmpty
        ? tag
        : (effectiveTags.isNotEmpty ? effectiveTags.join(', ') : '');

    return {
      'rating': rating,
      'comment': comment,
      'tag': effectiveTagStr,
      'tags': effectiveTags,
      'whatAreYouRating': effectiveTags,
    };
  }
}