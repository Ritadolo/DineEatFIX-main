import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../core/app_theme.dart';
import '../data/models/restaurant.dart';
import '../widgets/section_label.dart';
import 'floor_plan_screen.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final Restaurant restaurant;
  const RestaurantDetailScreen({Key? key, required this.restaurant})
      : super(key: key);

  @override
  State<RestaurantDetailScreen> createState() =>
      _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState
    extends State<RestaurantDetailScreen> {
  int _selDate = 1;
  String _selTime = '18:00';
  int _guests = 2;
  bool _bookmarked = false;

  static const _days = [
    {'day': 'Mon', 'date': '16'},
    {'day': 'Tue', 'date': '17'},
    {'day': 'Wed', 'date': '18'},
    {'day': 'Thu', 'date': '19'},
    {'day': 'Fri', 'date': '20'},
    {'day': 'Sat', 'date': '21'},
    {'day': 'Sun', 'date': '22'},
  ];

  // Extra restaurant detail info
  static const _about =
      'An intimate fine-dining sanctuary where classic French technique meets modern creativity. Every dish is a carefully composed journey of flavour, texture and artistry.';
  static const _hours = 'Tue – Sun  18:00 – 23:00';
  static const _phone = '+1 (212) 555-0190';

  static const _slots = [
    {'time': '17:30', 'disabled': false},
    {'time': '18:00', 'disabled': false},
    {'time': '18:30', 'disabled': false},
    {'time': '19:00', 'disabled': true},
    {'time': '19:30', 'disabled': false},
    {'time': '20:00', 'disabled': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: _buildBottomButton(context),
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(child: _buildContentCard()),
        ],
      ),
    );
  }

  // ── SliverAppBar ────────────────────────────────────────────────────────────

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: widget.restaurant.imageUrl,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                  color: AppColors.surfaceVariant),
              errorWidget: (_, __, ___) => Container(
                color: AppColors.surfaceVariant,
                child: const Icon(Icons.restaurant,
                    color: AppColors.borderGray, size: 48),
              ),
            ),
            // Gradient overlay
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x66000000),
                    Colors.transparent,
                    Color(0x99000000),
                  ],
                  stops: [0.0, 0.4, 1.0],
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _overlayButton(
                        icon: Icons.arrow_back,
                        onTap: () => Navigator.pop(context)),
                    _overlayButton(
                      icon: _bookmarked
                          ? Icons.bookmark
                          : Icons.bookmark_border,
                      iconColor: _bookmarked
                          ? AppColors.champagneGold
                          : Colors.white,
                      onTap: () =>
                          setState(() => _bookmarked = !_bookmarked),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _overlayButton(
      {required IconData icon,
      Color iconColor = Colors.white,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 40,
          height: 40,
          color: const Color(0x33FFFFFF),
          child: Icon(icon, color: iconColor, size: 20),
        ),
      ),
    );
  }

  // ── Content Card ─────────────────────────────────────────────────────────────

  Widget _buildContentCard() {
    return Transform.translate(
      offset: const Offset(0, -20),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRestaurantInfo(),
            const Divider(height: 48, color: AppColors.borderGray),
            _buildReserveSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(widget.restaurant.name,
                  style: headline(28)),
            ),
            const SizedBox(width: 12),
            _ratingBadge(),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.location_on_outlined,
                size: 16, color: AppColors.textGray),
            const SizedBox(width: 4),
            Expanded(
              child: Text(widget.restaurant.address,
                  style: body(14, color: AppColors.textGray)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: [
            widget.restaurant.cuisine,
            widget.restaurant.priceRange,
            widget.restaurant.distance,
          ]
              .map((t) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.midnightBlue.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(t,
                        style: body(12,
                            color: AppColors.midnightBlue,
                            fw: FontWeight.w500)),
                  ))
              .toList(),
        ),
        const SizedBox(height: 20),
        // ── About ──────────────────────────────────────────────────
        Text('About', style: headline(16)),
        const SizedBox(height: 8),
        Text(_about,
            style: body(13,
                color: AppColors.textSecondary)),
        const SizedBox(height: 16),
        // ── Details grid ───────────────────────────────────────────
        Row(
          children: [
            _detailChip(Icons.schedule_outlined, _hours),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _detailChip(Icons.phone_outlined, _phone),
          ],
        ),
      ],
    );
  }

  Widget _detailChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.champagneGold),
        const SizedBox(width: 6),
        Text(text,
            style: body(13, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _ratingBadge() {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: AppColors.borderGray),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star,
              size: 14, color: AppColors.champagneGold),
          const SizedBox(width: 4),
          Text(
            widget.restaurant.rating.toString(),
            style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.midnightBlue),
          ),
        ],
      ),
    );
  }

  // ── Reserve section ─────────────────────────────────────────────────────────

  Widget _buildReserveSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Reserve a Table', style: headline(22)),
        const SizedBox(height: 20),
        _buildDatePicker(),
        const SizedBox(height: 24),
        _buildTimeSlots(),
        const SizedBox(height: 24),
        _buildGuestCounter(),
      ],
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const SectionLabel('MARCH 2026'),
            const Spacer(),
            const Icon(Icons.calendar_today_outlined,
                size: 16, color: AppColors.midnightBlue),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 84,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _days.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) {
              final sel = i == _selDate;
              return GestureDetector(
                onTap: () => setState(() => _selDate = i),
                child: Container(
                  width: 72,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: sel
                          ? AppColors.champagneGold
                          : AppColors.borderGray,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _days[i]['day']!,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.textGray,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _days[i]['date']!,
                        style: GoogleFonts.inter(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: sel
                              ? AppColors.champagneGold
                              : AppColors.midnightBlue,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSlots() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel('SELECT TIME'),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 3,
          childAspectRatio: 2.2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: _slots.map((s) {
            final time = s['time'] as String;
            final disabled = s['disabled'] as bool;
            final isSelected = time == _selTime && !disabled;

            Color bg, textColor, border;
            if (disabled) {
              bg = AppColors.surfaceVariant;
              textColor = AppColors.borderGray;
              border = AppColors.surfaceVariant;
            } else if (isSelected) {
              bg = AppColors.midnightBlue;
              textColor = Colors.white;
              border = AppColors.midnightBlue;
            } else {
              bg = Colors.white;
              textColor = AppColors.midnightBlue;
              border = AppColors.borderGray;
            }

            return GestureDetector(
              onTap: disabled
                  ? null
                  : () => setState(() => _selTime = time),
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: border),
                ),
                alignment: Alignment.center,
                child: Text(
                  time,
                  style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: textColor),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildGuestCounter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel('NUMBER OF GUESTS'),
        const SizedBox(height: 12),
        Container(
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.borderGray),
          ),
          child: Row(
            children: [
              _counterBtn(
                  icon: Icons.remove,
                  onTap: _guests > 1
                      ? () => setState(() => _guests--)
                      : null),
              const Spacer(),
              Text('$_guests',
                  style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.midnightBlue)),
              const Spacer(),
              _counterBtn(
                  icon: Icons.add,
                  onTap: _guests < 10
                      ? () => setState(() => _guests++)
                      : null),
            ],
          ),
        ),
      ],
    );
  }

  Widget _counterBtn(
      {required IconData icon, required VoidCallback? onTap}) {
    return IconButton(
      icon: Icon(icon,
          color: onTap != null
              ? AppColors.midnightBlue
              : AppColors.borderGray),
      onPressed: onTap,
    );
  }

  // ── Bottom button ────────────────────────────────────────────────────────────

  Widget _buildBottomButton(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 54,
          child: ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FloorPlanScreen(
                  restaurant: widget.restaurant,
                  guestCount: _guests,
                ),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.champagneGold,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'NEXT: SELECT TABLE',
                  style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
