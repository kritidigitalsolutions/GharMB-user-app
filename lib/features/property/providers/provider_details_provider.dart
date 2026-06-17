// ─── Model ────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class PropertyDetailModel {
  final String id;
  final String name;
  final String price;
  final String priceSuffix;
  final String type;
  final String location;
  final String area;
  final int bedrooms;
  final int bathrooms;
  final String parking;
  final String floor;
  final bool isVerified;
  final bool isHot;
  final int photos;
  final List<HighlightItem> highlights;
  final List<AmenityItem> amenities;
  final String aboutText;
  final Map<String, String> propertyDetails;
  final List<NearbyItem> nearbyPlaces;
  final String furnishing;
  final String facing;
  final String availability;
  final String maintenanceCharge;
  final String deposit;
  final String propertyType;

  const PropertyDetailModel({
    required this.id,
    required this.name,
    required this.price,
    required this.priceSuffix,
    required this.type,
    required this.location,
    required this.area,
    required this.bedrooms,
    required this.bathrooms,
    required this.parking,
    required this.floor,
    required this.isVerified,
    required this.isHot,
    required this.photos,
    required this.highlights,
    required this.amenities,
    required this.aboutText,
    required this.propertyDetails,
    required this.nearbyPlaces,
    required this.furnishing,
    required this.facing,
    required this.availability,
    required this.maintenanceCharge,
    required this.deposit,
    required this.propertyType,
  });
}

class HighlightItem {
  final IconData icon;
  final String label;
  const HighlightItem(this.icon, this.label);
}

class AmenityItem {
  final IconData icon;
  final String label;
  const AmenityItem(this.icon, this.label);
}

class NearbyItem {
  final String place;
  final String distance;
  const NearbyItem(this.place, this.distance);
}

// ─── Dummy Data ───────────────────────────────────────────────────────────────

final _dummyProperty = PropertyDetailModel(
  id: 'prop_001',
  name: 'Sector 62, Noida',
  price: '₹85 Lakhs',
  priceSuffix: '/month',
  type: '3 BHK Apartment',
  location: 'Sector 62, Noida',
  area: '1450',
  bedrooms: 3,
  bathrooms: 2,
  parking: '1',
  floor: 'G',
  isVerified: true,
  isHot: true,
  photos: 12,
  highlights: const [
    HighlightItem(Icons.security, 'Gated\nSociety'),
    HighlightItem(Icons.shield_outlined, '24x7\nSecurity'),
    HighlightItem(Icons.bolt_outlined, 'Power\nBackup'),
    HighlightItem(Icons.elevator_outlined, 'Lift'),
    HighlightItem(Icons.sports_tennis_outlined, 'Clubhouse'),
  ],
  amenities: const [
    AmenityItem(Icons.fitness_center, 'Gym'),
    AmenityItem(Icons.pool, 'Swimming Pool'),
    AmenityItem(Icons.child_friendly, 'Kids Play Area'),
    AmenityItem(Icons.people_outline, 'Community Hall'),
    AmenityItem(Icons.park_outlined, 'Park'),
  ],
  aboutText:
      'Spacious 3 BHK apartment available for rent in a premium gated society. '
      'The flat is semi-furnished with modular kitchen, wardrobes and light '
      'fixtures. Well ventilated with ample natural light.',
  propertyDetails: {
    'Furnishing': 'Semi Furnished',
    'Property Type': 'Apartment',
    'Facing': 'North-East',
    'Maintenance': '₹3,500 /month',
    'Availability': 'Immediate',
    'Deposit': '2,00,000',
  },
  nearbyPlaces: const [
    NearbyItem('Metro Station', '1.2 km'),
    NearbyItem('Amity University', '1.8 km'),
    NearbyItem('Fortis Hospital', '2.1 km'),
    NearbyItem('DLF Mall of India', '2.8 km'),
    NearbyItem('Noida Sec 62 Market', '0.6 km'),
  ],
  furnishing: 'Semi Furnished',
  facing: 'North-East',
  availability: 'Immediate',
  maintenanceCharge: '₹3,500 /month',
  deposit: '2,00,000',
  propertyType: 'Apartment',
);

// ─── Provider ─────────────────────────────────────────────────────────────────

final propertyDetailProvider = Provider<PropertyDetailModel>(
  (_) => _dummyProperty,
);

final isWishlistedProvider = StateProvider<bool>((_) => false);
final isExpandedProvider = StateProvider<bool>((_) => false);
