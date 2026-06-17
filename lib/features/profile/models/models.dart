// ─── Property Model ───────────────────────────────────────────
class PropertyModel {
  final String id;
  final String title;
  final String location;
  final int views;
  final int shortlisted;
  final int tokens;
  final bool isLive;
  final String imageUrl;

  const PropertyModel({
    required this.id,
    required this.title,
    required this.location,
    required this.views,
    required this.shortlisted,
    required this.tokens,
    required this.isLive,
    required this.imageUrl,
  });
}

// ─── Dashboard Stats Model ────────────────────────────────────
class DashboardStats {
  final int totalListings;
  final int liveListings;
  final int pendingTokens;
  final int acceptedTokens;
  final int views;
  final int shortlisted;
  final int inquiries;
  final int tokenReceived;
  final int newTokenRequests;

  const DashboardStats({
    required this.totalListings,
    required this.liveListings,
    required this.pendingTokens,
    required this.acceptedTokens,
    required this.views,
    required this.shortlisted,
    required this.inquiries,
    required this.tokenReceived,
    required this.newTokenRequests,
  });
}

// ─── Listing Timeline Event ───────────────────────────────────
class TimelineEvent {
  final String title;
  final String? subtitle;
  final String date;
  final bool completed;

  const TimelineEvent({
    required this.title,
    this.subtitle,
    required this.date,
    required this.completed,
  });
}

// ─── Listing Detail Model ─────────────────────────────────────
class ListingDetail {
  final String id;
  final String title;
  final String area;
  final String location;
  final String imageUrl;
  final List<TimelineEvent> timeline;

  const ListingDetail({
    required this.id,
    required this.title,
    required this.area,
    required this.location,
    required this.imageUrl,
    required this.timeline,
  });
}
