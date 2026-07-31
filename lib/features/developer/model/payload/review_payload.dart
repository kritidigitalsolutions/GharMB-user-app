class ReviewPayload {
  final int rating;
  final String comment;
  final String tag;

  ReviewPayload({
    required this.rating,
    required this.comment,
    required this.tag,
  });

  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'comment': comment,
      'tag': tag,
    };
  }
}