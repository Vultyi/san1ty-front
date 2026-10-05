import 'package:flutter/material.dart';
import '../theme/admin_colors.dart';
import '../theme/admin_theme.dart';

class AdminBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AdminBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AdminDimensions.bottomNavHeight,
      decoration: BoxDecoration(
        color: AdminColors.bgPrimary,
        border: Border(top: AdminBorders.primary),
      ),
      child: BottomNavigationBar(
        backgroundColor: AdminColors.bgPrimary,
        selectedItemColor: AdminColors.accentCyan,
        unselectedItemColor: AdminColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: onTap,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard, size: 20),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people, size: 20),
            label: 'Equipe',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long, size: 20),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, size: 20),
            label: 'Config',
          ),
        ],
        selectedLabelStyle: AdminTextStyles.labelBase.copyWith(
          color: AdminColors.accentCyan,
        ),
        unselectedLabelStyle: AdminTextStyles.labelBase.copyWith(
          color: AdminColors.textSecondary,
        ),
      ),
    );
  }
}