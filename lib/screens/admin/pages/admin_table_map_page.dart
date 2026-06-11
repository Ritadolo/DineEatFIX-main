import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum _TableStatus { available, occupied, reserved }

class _TableData {
  final String id;
  final String label;
  final Offset position;
  final Size size;
  final _TableStatus status;
  final int seats;
  final String? guestName;

  const _TableData({
    required this.id,
    required this.label,
    required this.position,
    required this.size,
    required this.status,
    required this.seats,
    this.guestName,
  });
}

class AdminTableMapPage extends StatefulWidget {
  const AdminTableMapPage({super.key});

  @override
  State<AdminTableMapPage> createState() => _AdminTableMapPageState();
}

class _AdminTableMapPageState extends State<AdminTableMapPage> {
  bool _editMode = false;
  String? _selectedId;

  final List<_TableData> _tables = const [
    _TableData(
      id: 'T1',
      label: 'T1',
      position: Offset(60, 70),
      size: Size(80, 80),
      status: _TableStatus.occupied,
      seats: 4,
      guestName: 'Sarah Smith',
    ),
    _TableData(
      id: 'T2',
      label: 'T2',
      position: Offset(200, 70),
      size: Size(80, 80),
      status: _TableStatus.available,
      seats: 2,
    ),
    _TableData(
      id: 'T3',
      label: 'T3',
      position: Offset(340, 70),
      size: Size(80, 80),
      status: _TableStatus.occupied,
      seats: 6,
      guestName: 'Chen Family',
    ),
    _TableData(
      id: 'T4',
      label: 'T4',
      position: Offset(60, 220),
      size: Size(80, 80),
      status: _TableStatus.available,
      seats: 4,
    ),
    _TableData(
      id: 'T5',
      label: 'T5',
      position: Offset(200, 220),
      size: Size(100, 60),
      status: _TableStatus.reserved,
      seats: 4,
      guestName: 'Alexander Wright',
    ),
    _TableData(
      id: 'T6',
      label: 'T6',
      position: Offset(360, 220),
      size: Size(80, 80),
      status: _TableStatus.available,
      seats: 2,
    ),
    _TableData(
      id: 'T8',
      label: 'T8',
      position: Offset(130, 370),
      size: Size(100, 60),
      status: _TableStatus.occupied,
      seats: 2,
      guestName: 'Marcus Reid',
    ),
    _TableData(
      id: 'T14',
      label: 'T14',
      position: Offset(300, 370),
      size: Size(100, 60),
      status: _TableStatus.occupied,
      seats: 4,
      guestName: 'Sarah Smith',
    ),
  ];

  Color _statusColor(_TableStatus s) {
    switch (s) {
      case _TableStatus.available:
        return const Color(0xFF2E7D32);
      case _TableStatus.occupied:
        return const Color(0xFFBA1A1A);
      case _TableStatus.reserved:
        return const Color(0xFFD4AF37);
    }
  }

  String _statusLabel(_TableStatus s) {
    switch (s) {
      case _TableStatus.available:
        return 'Available';
      case _TableStatus.occupied:
        return 'Occupied';
      case _TableStatus.reserved:
        return 'Reserved';
    }
  }

  @override
  Widget build(BuildContext context) {
    final selected = _selectedId != null
        ? _tables.firstWhere((t) => t.id == _selectedId,
            orElse: () => _tables.first)
        : null;

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
                  flex: 3,
                  child: _buildMapCanvas(),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: 240,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLegend(),
                      const SizedBox(height: 16),
                      if (selected != null) _buildTableDetail(selected),
                    ],
                  ),
                ),
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
            'Live Table Map',
            style: GoogleFonts.playfairDisplay(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF031636),
            ),
          ),
          const Spacer(),
          // Toggle
          Container(
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F2F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _modeBtn('Live View', !_editMode),
                _modeBtn('Edit Mode', _editMode),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _modeBtn(String label, bool active) {
    return GestureDetector(
      onTap: () => setState(
          () => _editMode = label == 'Edit Mode'),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.all(3),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF031636) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: active ? Colors.white : const Color(0xFF75777F),
          ),
        ),
      ),
    );
  }

  Widget _buildMapCanvas() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                Text('Main Dining Room',
                    style: GoogleFonts.playfairDisplay(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF031636))),
                const Spacer(),
                if (_editMode)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4AF37).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text('Editing...',
                        style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFD4AF37))),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(16)),
              child: CustomPaint(
                painter: _GridPainter(),
                child: Stack(
                  children: _tables
                      .map((t) => Positioned(
                            left: t.position.dx,
                            top: t.position.dy,
                            child: GestureDetector(
                              onTap: () => setState(
                                  () => _selectedId = t.id),
                              child: _TableWidget(
                                data: t,
                                isSelected: _selectedId == t.id,
                                editMode: _editMode,
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Legend',
              style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                  color: const Color(0xFF9E9E9E))),
          const SizedBox(height: 10),
          ..._TableStatus.values.map((s) => _legendItem(s)),
        ],
      ),
    );
  }

  Widget _legendItem(_TableStatus s) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: _statusColor(s),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 10),
          Text(_statusLabel(s),
              style: GoogleFonts.inter(
                  fontSize: 13, color: const Color(0xFF1A1C1C))),
        ],
      ),
    );
  }

  Widget _buildTableDetail(_TableData t) {
    final color = _statusColor(t.status);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Table ${t.label}',
                style: GoogleFonts.playfairDisplay(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF031636)),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  _statusLabel(t.status),
                  style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: color),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _detailRow(Icons.people_outline, '${t.seats} Seats'),
          if (t.guestName != null)
            _detailRow(Icons.person_outline, t.guestName!),
          const SizedBox(height: 12),
          if (t.status != _TableStatus.available)
            SizedBox(
              width: double.infinity,
              height: 34,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7)),
                ),
                child: Text('View Details',
                    style: GoogleFonts.inter(
                        fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            )
          else
            SizedBox(
              width: double.infinity,
              height: 34,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF2E7D32),
                  side: const BorderSide(color: Color(0xFF2E7D32)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7)),
                ),
                child: Text('Assign Guest',
                    style: GoogleFonts.inter(
                        fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _detailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 15, color: const Color(0xFF9E9E9E)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text,
                style: GoogleFonts.inter(
                    fontSize: 13, color: const Color(0xFF1A1C1C))),
          ),
        ],
      ),
    );
  }
}

class _TableWidget extends StatelessWidget {
  final _TableData data;
  final bool isSelected;
  final bool editMode;

  const _TableWidget({
    required this.data,
    required this.isSelected,
    required this.editMode,
  });

  Color get _color {
    switch (data.status) {
      case _TableStatus.available:
        return const Color(0xFF2E7D32);
      case _TableStatus.occupied:
        return const Color(0xFFBA1A1A);
      case _TableStatus.reserved:
        return const Color(0xFFD4AF37);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: data.size.width,
      height: data.size.height,
      decoration: BoxDecoration(
        color: _color.withOpacity(isSelected ? 0.25 : 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _color,
          width: isSelected ? 2.5 : 1.5,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                    color: _color.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 1)
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(data.label,
              style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: _color)),
          if (data.guestName != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                data.guestName!.split(' ').first,
                style: GoogleFonts.inter(
                    fontSize: 9, color: _color.withOpacity(0.7)),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          if (editMode)
            Icon(Icons.open_with, size: 12, color: _color.withOpacity(0.6)),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE0E0E0).withOpacity(0.5)
      ..strokeWidth = 0.5;

    const step = 40.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter _) => false;
}
