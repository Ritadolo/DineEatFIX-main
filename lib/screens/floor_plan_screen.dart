import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../core/app_theme.dart';
import '../data/models/restaurant.dart';
import '../widgets/primary_button.dart';
import '../widgets/section_label.dart';
import 'pre_order_menu_screen.dart';

enum TableShape { rect, round }

enum TableStatus { available, booked }

class TableData {
  final String id;
  final String label;
  final double x, y, w, h;
  final TableShape shape;
  final TableStatus status;

  const TableData({
    required this.id,
    required this.label,
    required this.x,
    required this.y,
    required this.w,
    required this.h,
    required this.shape,
    required this.status,
  });
}

class FloorPlanScreen extends StatefulWidget {
  final Restaurant restaurant;
  final int guestCount;

  const FloorPlanScreen(
      {Key? key, required this.restaurant, required this.guestCount})
      : super(key: key);

  @override
  State<FloorPlanScreen> createState() => _FloorPlanScreenState();
}

class _FloorPlanScreenState extends State<FloorPlanScreen> {
  String _selectedTable = '14';

  static const _tables = [
    TableData(id: '11', label: '11', x: 0.08, y: 0.12, w: 0.22, h: 0.14, shape: TableShape.rect,  status: TableStatus.available),
    TableData(id: '12', label: '12', x: 0.32, y: 0.12, w: 0.22, h: 0.14, shape: TableShape.rect,  status: TableStatus.available),
    TableData(id: '13', label: '13', x: 0.56, y: 0.12, w: 0.22, h: 0.14, shape: TableShape.rect,  status: TableStatus.booked),
    TableData(id: '14', label: '14', x: 0.80, y: 0.12, w: 0.14, h: 0.14, shape: TableShape.rect,  status: TableStatus.available),
    TableData(id: '21', label: '21', x: 0.15, y: 0.42, w: 0.16, h: 0.18, shape: TableShape.round, status: TableStatus.available),
    TableData(id: '22', label: '22', x: 0.45, y: 0.42, w: 0.16, h: 0.18, shape: TableShape.round, status: TableStatus.booked),
    TableData(id: 'B1', label: 'B1', x: 0.10, y: 0.72, w: 0.28, h: 0.14, shape: TableShape.rect,  status: TableStatus.available),
    TableData(id: 'B2', label: 'B2', x: 0.42, y: 0.72, w: 0.28, h: 0.14, shape: TableShape.rect,  status: TableStatus.available),
  ];

  Color _tableColor(TableData t) {
    if (t.id == _selectedTable) return AppColors.midnightBlue;
    if (t.status == TableStatus.booked) return AppColors.surfaceHigh;
    return AppColors.champagneGold;
  }

  Color _tableLabelColor(TableData t) {
    if (t.id == _selectedTable) return Colors.white;
    if (t.status == TableStatus.booked) return AppColors.midnightBlue;
    return AppColors.midnightBlue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const BackButton(color: AppColors.midnightBlue),
        title: Text('Select Your Table', style: headline(20)),
        centerTitle: true,
        actions: const [SizedBox(width: 48)],
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          _buildLegend(),
          const SizedBox(height: 16),
          Expanded(child: _buildFloorPlan()),
          _buildBottomCard(),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendItem(AppColors.champagneGold, 'Available'),
        const SizedBox(width: 24),
        _legendItem(AppColors.surfaceHigh, 'Booked'),
        const SizedBox(width: 24),
        _legendItem(AppColors.midnightBlue, 'Selected'),
      ],
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 16,
            height: 16,
            decoration:
                BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textGray)),
      ],
    );
  }

  Widget _buildFloorPlan() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: cardShadow,
        ),
        child: LayoutBuilder(
          builder: (_, constraints) {
            final w = constraints.maxWidth;
            final h = constraints.maxHeight;
            return Stack(
              children: [
                // Section labels
                Positioned(
                  top: 8,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text('WINDOWS / CITY VIEW',
                        style: GoogleFonts.inter(
                            fontSize: 10,
                            letterSpacing: 2,
                            color: AppColors.textGray)),
                  ),
                ),
                Positioned(
                  right: 8,
                  top: h * 0.35,
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: Text('BAR AREA',
                        style: GoogleFonts.inter(
                            fontSize: 10,
                            letterSpacing: 2,
                            color: AppColors.textGray)),
                  ),
                ),
                // Tables
                ..._tables.map((t) {
                  final isSelected = t.id == _selectedTable;
                  final canTap = t.status == TableStatus.available;
                  return Positioned(
                    left: t.x * w,
                    top: t.y * h,
                    width: t.w * w,
                    height: t.h * h,
                    child: GestureDetector(
                      onTap: canTap
                          ? () =>
                              setState(() => _selectedTable = t.id)
                          : null,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: _tableColor(t),
                          borderRadius: BorderRadius.circular(
                            t.shape == TableShape.round
                                ? 100
                                : 8,
                          ),
                          border: isSelected
                              ? Border.all(
                                  color: AppColors.champagneGold,
                                  width: 2)
                              : null,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          t.label,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _tableLabelColor(t),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBottomCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
              color: Color(0x14000000),
              blurRadius: 10,
              offset: Offset(0, -4))
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionLabel('Selected'),
            const SizedBox(height: 6),
            Text('Table $_selectedTable', style: headline(20)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.deck_outlined,
                    size: 16, color: AppColors.champagneGold),
                const SizedBox(width: 6),
                Text(
                  'Window Seat · ${widget.guestCount} Guests',
                  style: body(13, color: AppColors.textGray),
                ),
              ],
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              label: 'Confirm Table & Pre-order',
              icon: Icons.arrow_forward,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const PreOrderMenuScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
