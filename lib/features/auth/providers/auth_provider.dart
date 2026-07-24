// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/legacy.dart';
// import 'package:gharmb_app/core/constants/app_colors.dart';

// final authLoadingProvider = StateProvider<bool>((ref) => false);

// enum UserRole {
//   buyer,
//   tenant,
//   propertyOwner,
//   realEstateAgent,
//   builderDeveloper,
// }

// extension UserRoleExtension on UserRole {
//   String get title {
//     switch (this) {
//       case UserRole.buyer:
//         return 'Buyer';
//       case UserRole.tenant:
//         return 'Tenant';
//       case UserRole.propertyOwner:
//         return 'Property Owner';
//       case UserRole.realEstateAgent:
//         return 'Real Estate Agent';
//       case UserRole.builderDeveloper:
//         return 'Builder / Developer';
//     }
//   }

//   String get subtitle {
//     switch (this) {
//       case UserRole.buyer:
//         return 'I want to buy a property';
//       case UserRole.tenant:
//         return 'I want to rent a property';
//       case UserRole.propertyOwner:
//         return 'I want to list my property';
//       case UserRole.realEstateAgent:
//         return 'I help clients find properties';
//       case UserRole.builderDeveloper:
//         return 'I am a builder or developer';
//     }
//   }

//   IconData get icon {
//     switch (this) {
//       case UserRole.buyer:
//         return Icons.person_outline;
//       case UserRole.tenant:
//         return Icons.key_outlined;
//       case UserRole.propertyOwner:
//         return Icons.home_outlined;
//       case UserRole.realEstateAgent:
//         return Icons.badge_outlined;
//       case UserRole.builderDeveloper:
//         return Icons.construction_outlined;
//     }
//   }

//   Color get color {
//     switch (this) {
//       case UserRole.buyer:
//         return AppColors.button;
//       case UserRole.tenant:
//         return AppColors.error;
//       case UserRole.propertyOwner:
//         return AppColors.yellow;
//       case UserRole.realEstateAgent:
//         return AppColors.blue;
//       case UserRole.builderDeveloper:
//         return AppColors.success;
//     }
//   }
// }

// final selectedRoleProvider = StateProvider<UserRole?>((ref) => null);
