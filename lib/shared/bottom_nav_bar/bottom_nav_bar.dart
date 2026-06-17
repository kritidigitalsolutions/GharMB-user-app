import 'package:flutter/material.dart';
import 'package:gharmb_app/core/constants/app_colors.dart';
import 'package:gharmb_app/core/theme/text_style.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 6,
      backgroundColor: AppColors.white,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.grey,
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark_border),
          label: "Wishlist",
        ),
        BottomNavigationBarItem(
          icon: SizedBox.shrink(), // Placeholder for FAB
          label: "",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.apartment_outlined),
          label: "Projects",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "My Profile"),
      ],
      selectedLabelStyle: text12(fontWeight: FontWeight.w600),
      unselectedLabelStyle: text12(),
    );
  }
}
