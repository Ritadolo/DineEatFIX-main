import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminCustomersPage extends StatefulWidget {
  const AdminCustomersPage({super.key});

  @override
  State<AdminCustomersPage> createState() => _AdminCustomersPageState();
}

class _AdminCustomersPageState extends State<AdminCustomersPage> {
  final _searchCtrl = TextEditingController();
  String _search = '';

  static const _customers = [
    _Customer(
      name: 'Alexander Wright',
      badge: 'VIP',
      badgeColor: Color(0xFFD4AF37),
      time: '18:30',
      guests: 2,
      table: 'T-14 Window',
      preOrder: 'Wagyu Steak, Bordeaux',
      avatar: 'AW',
    ),
    _Customer(
      name: 'Sophia Laurent',
      badge: '',
      badgeColor: Colors.transparent,
      time: '19:00',
      guests: 4,
      table: 'B-02 Booth',
      preOrder: 'Anniversary Cake',
      avatar: 'SL',
    ),
    _Customer(
      name: 'Marcus Reid',
      badge: 'First Time',
      badgeColor: Color(0xFF1565C0),
      time: '19:15',
      guests: 2,
      table: 'T-08 Center',
      preOrder: 'Tasting Menu',
      avatar: 'MR',
    ),
    _Customer(
      name: 'Elena & David Chen',
      badge: '',
      badgeColor: Colors.transparent,
      time: '20:30',
      guests: 6,
      table: 'PDR-1 Private',
      preOrder: 'Caviar, Champagne',
      avatar: 'EC',
    ),
  ];

  List<_Customer> get _filtered => _customers
      .where((c) =>
          c.name.toLowerCase().contains(_search.toLowerCase()) ||
          c.table.toLowerCase().contains(_search.toLowerCase()))
      .toList();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTopBar(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 2))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTableHeader(),
                  const Divider(height: 1, color: Color(0xFFEEEEEE)),
                  Expanded(
                    child: ListView.separated(
                      itemCount: _filtered.length,
                      separatorBuilder: (_, __) => const Divider(
                          height: 1, color: Color(0xFFF5F5F5)),
                      itemBuilder: (_, i) =>
                          _buildCustomerRow(_filtered[i], i),
                    ),
                  ),
                  _buildPagination(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 64,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Text(
            'Upcoming Customers',
            style: GoogleFonts.playfairDisplay(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF031636),
            ),
          ),
          const Spacer(),
          // Search bar
          SizedBox(
            width: 260,
            height: 38,
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _search = v),
              style: GoogleFonts.inter(fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Search guests or tables...',
                hintStyle: GoogleFonts.inter(
                    fontSize: 13, color: const Color(0xFF9E9E9E)),
                prefixIcon: const Icon(Icons.search,
                    size: 18, color: Color(0xFF9E9E9E)),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0),
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          _topBarBtn(Icons.filter_list, 'Filter'),
          const SizedBox(width: 8),
          _topBarBtn(Icons.file_download_outlined, 'Export'),
        ],
      ),
    );
  }

  Widget _topBarBtn(IconData icon, String label) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 16),
      label: Text(label, style: GoogleFonts.inter(fontSize: 13)),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF031636),
        side: const BorderSide(color: Color(0xFFDDDDDD)),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)),
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          _colHead('Guest', flex: 3),
          _colHead('Time', flex: 1),
          _colHead('Guests', flex: 1),
          _colHead('Table', flex: 2),
          _colHead('Pre-order', flex: 3),
          _colHead('Actions', flex: 2),
        ],
      ),
    );
  }

  Widget _colHead(String label, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
          color: const Color(0xFF9E9E9E),
        ),
      ),
    );
  }

  Widget _buildCustomerRow(_Customer c, int i) {
    return Container(
      color: i.isOdd
          ? const Color(0xFFFAFAFA)
          : Colors.white,
      padding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          // Name + badge
          Expanded(
            flex: 3,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor:
                      const Color(0xFF031636).withOpacity(0.08),
                  child: Text(c.avatar,
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF031636))),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c.name,
                          style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1A1C1C))),
                      if (c.badge.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(top: 3),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: c.badgeColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(c.badge,
                              style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: c.badgeColor)),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Time
          Expanded(
            flex: 1,
            child: Text(c.time,
                style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF031636))),
          ),
          // Guests
          Expanded(
            flex: 1,
            child: Row(
              children: [
                const Icon(Icons.people_outline,
                    size: 14, color: Color(0xFF9E9E9E)),
                const SizedBox(width: 4),
                Text('${c.guests}',
                    style: GoogleFonts.inter(
                        fontSize: 13, color: const Color(0xFF1A1C1C))),
              ],
            ),
          ),
          // Table
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF031636).withOpacity(0.06),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(c.table,
                  style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF031636))),
            ),
          ),
          // Pre-order
          Expanded(
            flex: 3,
            child: Text(c.preOrder,
                style: GoogleFonts.inter(
                    fontSize: 12, color: const Color(0xFF44474E))),
          ),
          // Actions
          Expanded(
            flex: 2,
            child: Row(
              children: [
                _actionChip('View', Icons.visibility_outlined,
                    const Color(0xFF031636)),
                const SizedBox(width: 6),
                _actionChip('Check-in', Icons.qr_code_scanner,
                    const Color(0xFFD4AF37)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionChip(String label, IconData icon, Color color) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
            Text(label,
                style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildPagination() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Row(
        children: [
          Text('Showing ${_filtered.length} of 28 guests',
              style: GoogleFonts.inter(
                  fontSize: 13, color: const Color(0xFF75777F))),
          const Spacer(),
          _pageBtn('← Prev', false),
          const SizedBox(width: 6),
          _pageNumBtn('1', true),
          _pageNumBtn('2', false),
          _pageNumBtn('3', false),
          const SizedBox(width: 6),
          _pageBtn('Next →', true),
        ],
      ),
    );
  }

  Widget _pageBtn(String label, bool active) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
          foregroundColor: active
              ? const Color(0xFF031636)
              : const Color(0xFF9E9E9E),
          padding: const EdgeInsets.symmetric(horizontal: 10)),
      child: Text(label, style: GoogleFonts.inter(fontSize: 13)),
    );
  }

  Widget _pageNumBtn(String num, bool active) {
    return Container(
      width: 32,
      height: 32,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: active
            ? const Color(0xFF031636)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: Text(num,
            style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: active ? Colors.white : const Color(0xFF9E9E9E))),
      ),
    );
  }
}

class _Customer {
  final String name;
  final String badge;
  final Color badgeColor;
  final String time;
  final int guests;
  final String table;
  final String preOrder;
  final String avatar;

  const _Customer({
    required this.name,
    required this.badge,
    required this.badgeColor,
    required this.time,
    required this.guests,
    required this.table,
    required this.preOrder,
    required this.avatar,
  });
}
