import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gharmb_app/features/profile/models/models.dart';

final listingDetailProvider = Provider<ListingDetail>((ref) {
  return const ListingDetail(
    id: '#GBM-240612-0015',
    title: '3 BHK Apartment',
    area: '1480 sq ft',
    location: 'Sector 62, Noida, Uttar Pradesh – 201309',
    imageUrl: 'https://via.placeholder.com/400x200',
    timeline: [
      TimelineEvent(
        title: 'Submitted',
        date: '12 Jun 02:18 PM',
        completed: true,
      ),
      TimelineEvent(
        title: 'Admin Verified',
        date: '12 Jun 02:18 PM',
        completed: true,
      ),
      TimelineEvent(
        title: 'Property Live',
        date: '12 Jun 02:18 PM',
        completed: true,
      ),
      TimelineEvent(
        title: 'Site Visit Completed',
        date: '12 Jun 02:28 PM',
        completed: true,
      ),
      TimelineEvent(
        title: 'Token Received',
        subtitle: '₹5000 received',
        date: '12 Jun 02:28 PM',
        completed: true,
      ),
      TimelineEvent(
        title: 'Agreement Discussion',
        subtitle: 'Completed',
        date: '12 Jun 02:18 PM',
        completed: true,
      ),
      TimelineEvent(
        title: 'Deal Closed',
        subtitle: 'Completed',
        date: '12 Jun 02:18 PM',
        completed: true,
      ),
    ],
  );
});
