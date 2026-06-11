import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _laserController;
  late Animation<double> _laserAnim;
  bool _checkedIn = false;

  @override
  void initState() {
    super.initState();
    _laserController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _laserAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _laserController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _laserController.dispose();
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: _buildQrScanner()),
                const SizedBox(width: 20),
                Expanded(flex: 2, child: _buildGuestPanel()),
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
            'QR Check-in',
            style: GoogleFonts.playfairDisplay(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF031636),
            ),
          ),
          const Spacer(),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32).withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(width: 6),
                Text('Scanner Active',
                    style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2E7D32))),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'Fri, June 9 · 19:00',
            style: GoogleFonts.inter(
                fontSize: 13, color: const Color(0xFF75777F)),
          ),
        ],
      ),
    );
  }

  Widget _buildQrScanner() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0A1628),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
            child: Row(
              children: [
                Text(
                  'QR Scanner Viewport',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                const Spacer(),
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFD4AF37),
                  ),
                ),
                const SizedBox(width: 6),
                Text('Ready',
                    style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFFD4AF37))),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Dark scanning area
                  Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFFD4AF37).withOpacity(0.4),
                        width: 1,
                      ),
                    ),
                  ),
                  // Corner brackets
                  ..._buildCorners(280),
                  // Laser line
                  AnimatedBuilder(
                    animation: _laserAnim,
                    builder: (_, __) {
                      return Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Transform.translate(
                          offset: Offset(0, _laserAnim.value * 280),
                          child: Container(
                            width: 280,
                            height: 2,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  const Color(0xFFD4AF37)
                                      .withOpacity(0.9),
                                  Colors.transparent,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFD4AF37)
                                      .withOpacity(0.5),
                                  blurRadius: 6,
                                  spreadRadius: 1,
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  // Center QR icon
                  Opacity(
                    opacity: 0.15,
                    child: const Icon(Icons.qr_code_2,
                        size: 160, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Text(
              'Position guest\'s QR code within the frame to check in',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.white.withOpacity(0.4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCorners(double size) {
    const cornerSize = 24.0;
    const color = Color(0xFFD4AF37);
    const thickness = 3.0;

    return [
      // Top-left
      Positioned(
        top: (MediaQuery.sizeOf(context).height / 2 - size / 2 - 20),
        left: (MediaQuery.sizeOf(context).width / 2 - size / 2 - 20),
        child: _corner(
            top: 0, left: 0, size: cornerSize, color: color, t: thickness),
      ),
      Positioned(
        top: 0,
        left: 0,
        child: SizedBox(
          width: size,
          height: size,
          child: Stack(
            children: [
              // TL
              Positioned(
                  top: 0,
                  left: 0,
                  child: _cornerPiece(
                      right: false, bottom: false, color: color, t: thickness)),
              // TR
              Positioned(
                  top: 0,
                  right: 0,
                  child: _cornerPiece(
                      right: true, bottom: false, color: color, t: thickness)),
              // BL
              Positioned(
                  bottom: 0,
                  left: 0,
                  child: _cornerPiece(
                      right: false, bottom: true, color: color, t: thickness)),
              // BR
              Positioned(
                  bottom: 0,
                  right: 0,
                  child: _cornerPiece(
                      right: true, bottom: true, color: color, t: thickness)),
            ],
          ),
        ),
      ),
    ];
  }

  Widget _corner(
      {required double top,
      required double left,
      required double size,
      required Color color,
      required double t}) {
    return Container();
  }

  Widget _cornerPiece(
      {required bool right,
      required bool bottom,
      required Color color,
      required double t}) {
    const len = 24.0;
    return SizedBox(
      width: len,
      height: len,
      child: CustomPaint(
        painter: _CornerPainter(
            right: right, bottom: bottom, color: color, thickness: t),
      ),
    );
  }

  Widget _buildGuestPanel() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildArrivalCard(),
          const SizedBox(height: 16),
          _buildStatsRow(),
        ],
      ),
    );
  }

  Widget _buildArrivalCard() {
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: const BoxDecoration(
              color: Color(0xFF031636),
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                const Icon(Icons.person_pin_circle_outlined,
                    color: Color(0xFFD4AF37), size: 20),
                const SizedBox(width: 8),
                Text(
                  'Guest Arrival Detected',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _checkedIn
                        ? const Color(0xFF2E7D32)
                        : const Color(0xFFD4AF37),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor:
                          const Color(0xFFD4AF37).withOpacity(0.15),
                      child: Text(
                        'SS',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFD4AF37),
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Sarah Smith',
                            style: GoogleFonts.playfairDisplay(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF031636))),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            _guestBadge('Table 14'),
                            const SizedBox(width: 6),
                            _guestBadge('19:00'),
                            const SizedBox(width: 6),
                            _guestBadge('2 Guests'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text('PRE-ORDERED',
                    style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                        color: const Color(0xFF75777F))),
                const SizedBox(height: 10),
                _preOrderItem('Truffle Arancini', '\$32'),
                _preOrderItem('Wagyu Ribeye A5 Med Rare', '\$185'),
                _preOrderItem('Dom Perignon 2012', '\$340'),
                const SizedBox(height: 6),
                const Divider(color: Color(0xFFEEEEEE), height: 1),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text('Total',
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF031636))),
                    const Spacer(),
                    Text('\$557',
                        style: GoogleFonts.playfairDisplay(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFD4AF37))),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () => setState(() => _checkedIn = !_checkedIn),
                    icon: Icon(
                        _checkedIn
                            ? Icons.check_circle
                            : Icons.qr_code_scanner,
                        size: 18),
                    label: Text(
                        _checkedIn ? 'Checked In ✓' : 'Confirm Check-in',
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _checkedIn
                          ? const Color(0xFF2E7D32)
                          : const Color(0xFFD4AF37),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _guestBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F2F5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(text,
          style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF44474E))),
    );
  }

  Widget _preOrderItem(String name, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          const Icon(Icons.restaurant_menu,
              size: 14, color: Color(0xFFD4AF37)),
          const SizedBox(width: 8),
          Expanded(
              child: Text(name,
                  style: GoogleFonts.inter(
                      fontSize: 13, color: const Color(0xFF1A1C1C)))),
          Text(price,
              style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF031636))),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
            child: _statCard('Tonight', '28', 'Reservations',
                Icons.event_available_outlined, const Color(0xFF031636))),
        const SizedBox(width: 12),
        Expanded(
            child: _statCard('Checked In', '14', 'Guests',
                Icons.how_to_reg_outlined, const Color(0xFF2E7D32))),
      ],
    );
  }

  Widget _statCard(String title, String value, String sub, IconData icon,
      Color color) {
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
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: GoogleFonts.playfairDisplay(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF031636))),
              Text('$title $sub',
                  style: GoogleFonts.inter(
                      fontSize: 11, color: const Color(0xFF75777F))),
            ],
          ),
        ],
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final bool right;
  final bool bottom;
  final Color color;
  final double thickness;

  const _CornerPainter(
      {required this.right,
      required this.bottom,
      required this.color,
      required this.thickness});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    final x1 = right ? size.width : 0.0;
    final y1 = bottom ? size.height : 0.0;
    final x2 = right ? 0.0 : size.width;
    final y2 = bottom ? 0.0 : size.height;

    canvas.drawLine(Offset(x1, y1), Offset(x2, y1), paint);
    canvas.drawLine(Offset(x1, y1), Offset(x1, y2), paint);
  }

  @override
  bool shouldRepaint(_CornerPainter old) =>
      old.color != color || old.right != right || old.bottom != bottom;
}
