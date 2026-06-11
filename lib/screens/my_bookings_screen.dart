import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../core/app_theme.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/section_label.dart';
import 'home_screen.dart';
import 'saved_screen.dart';
import 'profile_screen.dart';
import 'modify_pre_order_screen.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    Widget? screen;
    switch (index) {
      case 0:
        screen = const HomeScreen();
        break;
      case 2:
        screen = const SavedScreen();
        break;
      case 3:
        screen = const ProfileScreen();
        break;
    }
    if (screen != null) {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => screen!), (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const Icon(Icons.menu, color: AppColors.midnightBlue),
        title: Text('Bookings', style: headline(20)),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.account_circle_outlined,
                color: AppColors.midnightBlue, size: 28),
          )
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.champagneGold,
          indicatorWeight: 2,
          labelStyle:
              GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold),
          unselectedLabelStyle: GoogleFonts.inter(fontSize: 14),
          labelColor: AppColors.midnightBlue,
          unselectedLabelColor: AppColors.textGray,
          tabs: const [Tab(text: 'Active'), Tab(text: 'Past')],
        ),
      ),
      bottomNavigationBar:
          BottomNavBar(currentIndex: 1, onTap: _onNavTap),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildActiveTab(),
          _buildPastTab(),
        ],
      ),
    );
  }

  Widget _buildActiveTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [_buildBookingCard()],
    );
  }

  Widget _buildPastTab() {
    return Center(
      child: Text('No past bookings',
          style: body(14, color: AppColors.textGray)),
    );
  }

  // ── Booking Card ─────────────────────────────────────────────────────────────

  Widget _buildBookingCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──
          Row(
            children: [
              Expanded(child: Text("L'Aura", style: headline(20))),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.confirmed.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle,
                        size: 14, color: AppColors.confirmed),
                    const SizedBox(width: 4),
                    Text('Confirmed',
                        style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.confirmed,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ── Meta row ──
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              _metaItem(Icons.calendar_today_outlined, 'Mar 24, 2026'),
              _metaItem(Icons.schedule_outlined, '19:30'),
              _metaItem(
                  Icons.table_restaurant_outlined, 'Table 14'),
            ],
          ),
          const SizedBox(height: 16),

          const SectionLabel('PRE-ORDERED EXPERIENCE'),
          const Divider(height: 16, color: AppColors.borderGray),

          _preOrderRow(Icons.restaurant_outlined,
              'Wagyu Beef Tenderloin', '\$85'),
          const SizedBox(height: 8),
          _preOrderRow(
              Icons.wine_bar_outlined, 'Sommelier Wine Pairing', '\$85'),
          const SizedBox(height: 12),

          // ── Total ──
          Row(
            children: [
              Text('Total Pre-paid',
                  style: body(14,
                      color: AppColors.textPrimary,
                      fw: FontWeight.bold)),
              const Spacer(),
              Text('\$170',
                  style: headline(18, color: AppColors.champagneGold)),
            ],
          ),
          const SizedBox(height: 16),

          // ── QRIS strip (tappable) ──
          GestureDetector(
            onTap: () => _showQrisSheet(context),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.midnightBlue.withOpacity(0.04),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: AppColors.champagneGold.withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.qr_code_2,
                      color: AppColors.champagneGold, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('QRIS Check-in',
                            style: body(13,
                                color: AppColors.midnightBlue,
                                fw: FontWeight.bold)),
                        Text('Tap to show QRIS code',
                            style: body(12,
                                color: AppColors.textGray)),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right,
                      color: AppColors.champagneGold, size: 20),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ── Action buttons ──
          Row(
            children: [
              Expanded(
                child: _outlinedBtn('Modify Pre-order', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            const ModifyPreOrderScreen()),
                  );
                }),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _outlinedBtn('Show QRIS', () {
                  _showQrisSheet(context);
                }),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ── Info text ──
          Row(
            children: [
              const Icon(Icons.info_outline,
                  size: 13, color: AppColors.textGray),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Cancellation policy applies. View details.',
                  style: body(11, color: AppColors.textGray),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  Widget _metaItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppColors.textGray),
        const SizedBox(width: 4),
        Text(text,
            style: GoogleFonts.inter(
                fontSize: 12, color: AppColors.midnightBlue)),
      ],
    );
  }

  Widget _preOrderRow(IconData icon, String name, String price) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textGray),
        const SizedBox(width: 8),
        Expanded(
            child: Text(name,
                style: body(13, color: AppColors.textPrimary))),
        Text(price,
            style: body(13,
                color: AppColors.midnightBlue,
                fw: FontWeight.w600)),
      ],
    );
  }

  Widget _outlinedBtn(String label, VoidCallback onTap) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.borderGray),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 10),
      ),
      child: Text(label,
          style: body(12,
              color: AppColors.midnightBlue,
              fw: FontWeight.w500)),
    );
  }

  // ── QRIS bottom sheet ────────────────────────────────────────────────────────

  void _showQrisSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const _QrisSheet(),
    );
  }
}

class _QrisSheet extends StatelessWidget {
  const _QrisSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
                color: AppColors.borderGray,
                borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 24),
          Text('QRIS Check-in', style: headline(22)),
          const SizedBox(height: 4),
          Text("L'Aura · Table 14 · Mar 24",
              style: body(13, color: AppColors.textGray)),
          const SizedBox(height: 28),

          // QR code area
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: AppColors.champagneGold, width: 2),
              boxShadow: cardShadow,
            ),
            child: const Center(
              child: Icon(Icons.qr_code_2,
                  size: 180, color: AppColors.midnightBlue),
            ),
          ),
          const SizedBox(height: 20),

          // QRIS label
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF0066CC).withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: const Color(0xFF0066CC).withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0066CC),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text('QRIS',
                      style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1)),
                ),
                const SizedBox(width: 8),
                Text('Scan to pay & check-in',
                    style: body(13,
                        color: const Color(0xFF0066CC),
                        fw: FontWeight.w500)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Present to the maître d' or scan with any QRIS app",
            textAlign: TextAlign.center,
            style: body(12, color: AppColors.textGray),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.midnightBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('Close',
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
