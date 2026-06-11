import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  static const _items = [
    _NavItem(icon: Icons.home_rounded, label: 'Home'),
    _NavItem(icon: Icons.calendar_month_outlined, label: 'Bookings'),
    _NavItem(icon: Icons.bookmark_border_rounded, label: 'Saved'),
    _NavItem(icon: Icons.person_outline_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, -2))
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              _items.length,
              (i) => _NavItemWidget(
                item: _items[i],
                isActive: i == currentIndex,
                onTap: () => onTap(i),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}

class _NavItemWidget extends StatelessWidget {
  final _NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItemWidget({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.champagneGold
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              item.icon,
              size: 22,
              color:
                  isActive ? Colors.white : AppColors.textGray,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            item.label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight:
                  isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive
                  ? AppColors.midnightBlue
                  : AppColors.textGray,
            ),
          ),
        ],
      ),
    );
  }
}
