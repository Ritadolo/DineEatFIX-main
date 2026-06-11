import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminOrdersPage extends StatefulWidget {
  const AdminOrdersPage({super.key});

  @override
  State<AdminOrdersPage> createState() => _AdminOrdersPageState();
}

class _AdminOrdersPageState extends State<AdminOrdersPage> {
  final List<_KanbanCard> _prep = [
    _KanbanCard(
      table: 'T-12',
      guest: 'Alice S.',
      guests: 4,
      items: ['Wagyu Tartare', 'Burrata Salad'],
      allergyNote: '',
      elapsed: '8m',
      status: _KanbanStatus.prep,
    ),
    _KanbanCard(
      table: 'T-04',
      guest: 'James R.',
      guests: 2,
      items: ['Chef\'s Tasting Menu (8 courses)'],
      allergyNote: 'Allergy: Pine nuts',
      elapsed: '12m',
      status: _KanbanStatus.prep,
    ),
  ];

  final List<_KanbanCard> _cook = [
    _KanbanCard(
      table: 'T-08',
      guest: 'Martinez',
      guests: 6,
      items: ['Scallop Crudo', 'Duck Breast', 'Mushroom Risotto'],
      allergyNote: '',
      elapsed: '24m',
      status: _KanbanStatus.cook,
    ),
  ];

  final List<_KanbanCard> _ready = [
    _KanbanCard(
      table: 'T-15',
      guest: 'Chen',
      guests: 2,
      items: ['Vintage Dom Perignon', 'Osetra Caviar'],
      allergyNote: '',
      elapsed: '31m',
      status: _KanbanStatus.ready,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTopBar(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: _buildColumn(
                        'PREP', _prep, const Color(0xFFE65100),
                        Icons.timer_outlined)),
                const SizedBox(width: 16),
                Expanded(
                    child: _buildColumn(
                        'COOK', _cook, const Color(0xFF1565C0),
                        Icons.local_fire_department_outlined)),
                const SizedBox(width: 16),
                Expanded(
                    child: _buildColumn(
                        'READY TO SERVE', _ready,
                        const Color(0xFF2E7D32),
                        Icons.check_circle_outline)),
              ],
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
            'Kitchen Board',
            style: GoogleFonts.playfairDisplay(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF031636),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F2F5),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '${_prep.length + _cook.length + _ready.length} Active Orders',
              style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF44474E)),
            ),
          ),
          const Spacer(),
          Text(
            'Last updated: just now',
            style: GoogleFonts.inter(
                fontSize: 12, color: const Color(0xFF9E9E9E)),
          ),
          const SizedBox(width: 16),
          IconButton(
            onPressed: () => setState(() {}),
            icon: const Icon(Icons.refresh,
                color: Color(0xFF031636), size: 20),
            tooltip: 'Refresh',
          ),
        ],
      ),
    );
  }

  Widget _buildColumn(
      String title, List<_KanbanCard> cards, Color color, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Column header
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: color,
                  ),
                ),
                const Spacer(),
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                  child: Center(
                    child: Text('${cards.length}',
                        style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
          // Cards
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: cards.length,
              itemBuilder: (_, i) =>
                  _buildKanbanCard(cards[i], color, i),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKanbanCard(
      _KanbanCard card, Color accentColor, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
        border: Border(
          left: BorderSide(color: accentColor, width: 3),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF031636),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(card.table,
                      style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('${card.guest} · ${card.guests} Guests',
                      style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF1A1C1C))),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.timer_outlined,
                          size: 11, color: accentColor),
                      const SizedBox(width: 3),
                      Text(card.elapsed,
                          style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: accentColor)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(height: 1, color: Color(0xFFF0F0F0)),
            const SizedBox(height: 10),
            // Items
            ...card.items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  children: [
                    const Icon(Icons.circle,
                        size: 6, color: Color(0xFFD4AF37)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(item,
                          style: GoogleFonts.inter(
                              fontSize: 13,
                              color: const Color(0xFF1A1C1C))),
                    ),
                  ],
                ),
              ),
            ),
            // Allergy note
            if (card.allergyNote.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFBA1A1A).withOpacity(0.06),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                      color:
                          const Color(0xFFBA1A1A).withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_outlined,
                        size: 14, color: Color(0xFFBA1A1A)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(card.allergyNote,
                          style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFFBA1A1A))),
                    ),
                  ],
                ),
              ),
            ],
            // Ready to serve actions
            if (card.status == _KanbanStatus.ready) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 34,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E7D32),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                          padding: EdgeInsets.zero,
                        ),
                        child: Text('Mark Completed',
                            style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SizedBox(
                      height: 34,
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.notifications_outlined,
                            size: 13),
                        label: Text('Waitstaff',
                            style: GoogleFonts.inter(fontSize: 11)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF1565C0),
                          side: const BorderSide(
                              color: Color(0xFF1565C0), width: 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

enum _KanbanStatus { prep, cook, ready }

class _KanbanCard {
  final String table;
  final String guest;
  final int guests;
  final List<String> items;
  final String allergyNote;
  final String elapsed;
  final _KanbanStatus status;

  const _KanbanCard({
    required this.table,
    required this.guest,
    required this.guests,
    required this.items,
    required this.allergyNote,
    required this.elapsed,
    required this.status,
  });
}
