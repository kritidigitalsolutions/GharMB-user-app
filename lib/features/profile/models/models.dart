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

  DashboardStats({
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

class PropertyModel {
  final String id;
  final String title;
  final String location;
  final int views;
  final int shortlisted;
  final int tokens;
  final bool isLive;
  final String status; // 'Live' | 'Pending' | 'Rejected'
  final String imageUrl;

  PropertyModel({
    required this.id,
    required this.title,
    required this.location,
    required this.views,
    required this.shortlisted,
    required this.tokens,
    required this.isLive,
    required this.status,
    required this.imageUrl,
  });
}

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

class TimelineEvent {
  final String title;
  final String date;
  final bool completed;
  final String? subtitle;

  const TimelineEvent({
    required this.title,
    required this.date,
    required this.completed,
    this.subtitle,
  });
}
