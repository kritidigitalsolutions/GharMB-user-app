import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:gharmb_app/features/property/models/response/near_properties_response.dart';
import 'package:gharmb_app/features/property/providers/property_listing_near_by_provider.dart';
import 'package:gharmb_app/features/property/providers/verified_properties_provider.dart';
import 'package:gharmb_app/features/property/repo/property_repo.dart';

// ─── Provider for PropertyRepo ────────────────────────────────────────────────
final propertyRepoProvider = Provider<PropertyRepo>((ref) {
  return PropertyRepo();
});

// ─── Selected Property Provider ───────────────────────────────────────────────
final selectedPropertyProvider = StateProvider<Property?>((ref) => null);

// ─── Fetch Property by ID Future Provider ─────────────────────────────────────
final propertyDetailByIdProvider = FutureProvider.family<Property?, String>((
  ref,
  id,
) async {
  if (id.isEmpty) return null;

  // 1. Check if selected property has matching ID
  final selected = ref.watch(selectedPropertyProvider);
  if (selected != null && (selected.id == id || selected.mongoId == id)) {
    return selected;
  }

  // 2. Check in verified properties cache
  final verifiedProps =
      ref.watch(verifiedPropertiesProvider).properties;
  final fromVerified = verifiedProps.cast<Property?>().firstWhere(
    (p) => p?.id == id || p?.mongoId == id,
    orElse: () => null,
  );
  if (fromVerified != null) return fromVerified;

  // 3. Check in near properties cache
  final nearProps =
      ref.watch(nearPropertiesProvider).value?.data.properties ?? [];
  final fromNear = nearProps.cast<Property?>().firstWhere(
    (p) => p?.id == id || p?.mongoId == id,
    orElse: () => null,
  );
  if (fromNear != null) return fromNear;

  // 4. Fetch full property from API endpoint
  final repo = ref.watch(propertyRepoProvider);
  return repo.getPropertyById(id);
});

final isExpandedProvider = StateProvider.autoDispose<bool>((_) => false);

// ─── Highlight & Amenity Helpers ──────────────────────────────────────────────
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
