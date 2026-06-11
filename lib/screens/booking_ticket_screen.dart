import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../core/app_theme.dart';
import 'home_screen.dart';
import 'my_bookings_screen.dart';

class BookingTicketScreen extends StatelessWidget {
  const BookingTicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.midnightBlue,
      body: SafeArea(
        child: Column(
          children: [
            // Manual AppBar
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const HomeScreen()),
                      (_) => false,
                    ),
                    child: const Icon(Icons.close,
                        color: Colors.white, size: 26),
                  ),
                  Expanded(
                    child: Center(
                      child: Text('DineAndGo',
                          style: headline(20, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    _buildTicketCard(context),
                    const SizedBox(height: 24),
                    _buildActionButtons(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Ticket card ─────────────────────────────────────────────────────────────

  Widget _buildTicketCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF031636).withOpacity(0.5),
            blurRadius: 40,
            offset: const Offset(0, 20),
          )
        ],
      ),
      child: Column(
        children: [
          _buildTicketTop(),
          _buildDashedDivider(),
          _buildInfoGrid(),
          _buildDashedDivider(),
          _buildQrSection(),
        ],
      ),
    );
  }

  Widget _buildTicketTop() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 32, 32, 24),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceVariant,
              border:
                  Border.all(color: AppColors.champagneGold, width: 2),
            ),
            child: const Icon(Icons.restaurant,
                size: 32, color: AppColors.midnightBlue),
          ),
          const SizedBox(height: 16),
          Text("L'Atelier d'Or", style: headline(26)),
          const SizedBox(height: 6),
          Text(
            'CONFIRMED RESERVATION',
            style: GoogleFonts.inter(
              fontSize: 11,
              letterSpacing: 3,
              fontWeight: FontWeight.w600,
              color: AppColors.champagneGold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashedDivider() {
    return Row(
      children: [
        _notch(left: true),
        Expanded(
          child: Row(
            children: List.generate(
              20,
              (_) => Expanded(
                child: Container(
                  height: 1,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 2),
                  color: AppColors.borderGray,
                ),
              ),
            ),
          ),
        ),
        _notch(left: false),
      ],
    );
  }

  Widget _notch({required bool left}) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: AppColors.midnightBlue,
        borderRadius: BorderRadius.horizontal(
          left: left ? Radius.zero : const Radius.circular(10),
          right: left ? const Radius.circular(10) : Radius.zero,
        ),
      ),
    );
  }

  Widget _buildInfoGrid() {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 8, vertical: 24),
      child: IntrinsicHeight(
        child: Row(
          children: [
            _infoCol(Icons.chair_outlined, 'Table', '14'),
            Container(width: 1, color: AppColors.borderGray),
            _infoCol(Icons.schedule_outlined, 'Tonight', '19:00'),
            Container(width: 1, color: AppColors.borderGray),
            _infoCol(Icons.group_outlined, 'Party', '2 Guests'),
          ],
        ),
      ),
    );
  }

  Widget _infoCol(IconData icon, String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: AppColors.champagneGold, size: 24),
          const SizedBox(height: 8),
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                  color: AppColors.textGray)),
          const SizedBox(height: 4),
          Text(value,
              style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.midnightBlue)),
        ],
      ),
    );
  }

  Widget _buildQrSection() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Icon(Icons.qr_code_2,
              size: 130, color: AppColors.midnightBlue),
          const SizedBox(height: 12),
          Text(
            "Present this code to the maître d' upon arrival",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
                fontSize: 12, color: AppColors.textGray),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ── Action buttons ───────────────────────────────────────────────────────────

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _outlinedBtn(
            context,
            icon: Icons.restaurant_menu,
            label: 'View Pre-order',
            onTap: () => _showPreOrderSheet(context),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _outlinedBtn(
            context,
            icon: Icons.edit_calendar,
            label: 'Manage Booking',
            onTap: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (_) => const MyBookingsScreen()),
              (_) => false,
            ),
          ),
        ),
      ],
    );
  }

  Widget _outlinedBtn(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return SizedBox(
      height: 46,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 16, color: Colors.white),
        label: Text(label,
            style: GoogleFonts.inter(
                fontSize: 13, color: Colors.white)),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.white),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  // ── Pre-order bottom sheet ───────────────────────────────────────────────────

  void _showPreOrderSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const _PreOrderSheet(),
    );
  }
}

class _PreOrderSheet extends StatelessWidget {
  const _PreOrderSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: AppColors.borderGray,
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 20),
          Text('Pre-ordered Items', style: headline(20)),
          const SizedBox(height: 4),
          Text("L'Atelier d'Or · Table 14 · Mar 24",
              style: body(13, color: AppColors.textGray)),
          const SizedBox(height: 20),
          const Divider(color: AppColors.borderGray, height: 1),
          const SizedBox(height: 16),
          _orderRow(Icons.restaurant_outlined,
              'Wagyu Beef Tenderloin', '× 1', '\$85'),
          const SizedBox(height: 12),
          _orderRow(Icons.wine_bar_outlined,
              'Sommelier Wine Pairing', '× 1', '\$85'),
          const SizedBox(height: 16),
          const Divider(color: AppColors.borderGray, height: 1),
          const SizedBox(height: 16),
          Row(
            children: [
              Text('Subtotal',
                  style: body(14, color: AppColors.textGray)),
              const Spacer(),
              Text('\$170.00',
                  style: body(14,
                      color: AppColors.textPrimary,
                      fw: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text('Taxes & Fees',
                  style: body(14, color: AppColors.textGray)),
              const Spacer(),
              Text('\$15.30',
                  style: body(14,
                      color: AppColors.textPrimary,
                      fw: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text('Total',
                  style: body(16,
                      color: AppColors.midnightBlue,
                      fw: FontWeight.bold)),
              const Spacer(),
              Text('\$185.30',
                  style: headline(20,
                      color: AppColors.champagneGold)),
            ],
          ),
          const SizedBox(height: 24),
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

  Widget _orderRow(
      IconData icon, String name, String qty, String price) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.champagneGold.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon,
              size: 18, color: AppColors.champagneGold),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: body(14,
                      color: AppColors.midnightBlue,
                      fw: FontWeight.w600)),
              Text(qty,
                  style: body(12, color: AppColors.textGray)),
            ],
          ),
        ),
        Text(price,
            style: body(14,
                color: AppColors.midnightBlue,
                fw: FontWeight.bold)),
      ],
    );
  }
}
