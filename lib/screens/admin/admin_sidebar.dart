import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminSidebar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AdminSidebar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _navItems = [
    _NavItem(Icons.dashboard_outlined, Icons.dashboard, 'Dashboard'),
    _NavItem(Icons.table_restaurant_outlined, Icons.table_restaurant, 'Table Map'),
    _NavItem(Icons.receipt_long_outlined, Icons.receipt_long, 'Orders'),
    _NavItem(Icons.people_outline, Icons.people, 'Customers'),
    _NavItem(Icons.restaurant_menu_outlined, Icons.restaurant_menu, 'Food & Beverage'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      color: const Color(0xFF031636),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          // Logo
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.restaurant,
                      color: Color(0xFF031636), size: 22),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Resto OS',
                        style: GoogleFonts.playfairDisplay(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                    Text('Premium Management',
                        style: GoogleFonts.inter(
                            fontSize: 10,
                            color: Colors.white.withOpacity(0.5),
                            letterSpacing: 0.3)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          // Nav items
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: _navItems.length,
              itemBuilder: (_, i) => _buildNavItem(i),
            ),
          ),
          // New Reservation button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
            child: SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 16),
                label: Text('New Reservation',
                    style: GoogleFonts.inter(
                        fontSize: 13, fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4AF37),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final item = _navItems[index];
    final isActive = index == currentIndex;
    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: isActive
                  ? const Color(0xFFD4AF37)
                  : Colors.transparent,
              width: 3,
            ),
          ),
          color: isActive
              ? Colors.white.withOpacity(0.06)
              : Colors.transparent,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          child: Row(
            children: [
              Icon(
                isActive ? item.activeIcon : item.icon,
                size: 20,
                color: isActive
                    ? const Color(0xFFD4AF37)
                    : Colors.white.withOpacity(0.65),
              ),
              const SizedBox(width: 14),
              Text(
                item.label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight:
                      isActive ? FontWeight.w600 : FontWeight.normal,
                  color: isActive
                      ? Colors.white
                      : Colors.white.withOpacity(0.65),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavItem(this.icon, this.activeIcon, this.label);
}
