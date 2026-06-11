import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../core/app_theme.dart';
import 'confirmation_screen.dart';
import 'modify_pre_order_screen.dart' show allMenuItems, MenuItemData;

const _tabs = ['Appetizers', 'Mains', 'Wine', 'Desserts'];

class PreOrderMenuScreen extends StatefulWidget {
  const PreOrderMenuScreen({super.key});

  @override
  State<PreOrderMenuScreen> createState() => _PreOrderMenuScreenState();
}

class _PreOrderMenuScreenState extends State<PreOrderMenuScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final Map<String, int> _counts = {'Wagyu Beef Tenderloin': 1};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  int get _totalItems =>
      _counts.values.fold(0, (sum, v) => sum + v);

  double get _totalPrice {
    double t = 0;
    _counts.forEach((name, qty) {
      final item = allMenuItems.firstWhere((m) => m.name == name,
          orElse: () =>
              const MenuItemData('', '', 0, '', ''));
      t += item.price * qty;
    });
    return t;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const Icon(Icons.menu, color: AppColors.midnightBlue),
        title: Text('DineAndGo', style: headline(20)),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.account_circle_outlined,
                color: AppColors.midnightBlue, size: 28),
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Container(
            color: AppColors.midnightBlue.withOpacity(0.05),
            padding: const EdgeInsets.symmetric(
                horizontal: 24, vertical: 10),
            child: Row(
              children: [
                Text('Mar 24, 7:30 PM',
                    style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.midnightBlue)),
                _vDivider(),
                Text('Le Bernardin',
                    style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.midnightBlue)),
                _vDivider(),
                Text('Table 14',
                    style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.midnightBlue)),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            indicatorColor: AppColors.champagneGold,
            indicatorWeight: 2,
            labelStyle: GoogleFonts.inter(
                fontSize: 14, fontWeight: FontWeight.bold),
            unselectedLabelStyle: GoogleFonts.inter(fontSize: 14),
            labelColor: AppColors.midnightBlue,
            unselectedLabelColor: AppColors.textGray,
            tabs: _tabs.map((t) => Tab(text: t)).toList(),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children:
                  _tabs.map((tab) => _buildTabContent(tab)).toList(),
            ),
          ),
          if (_totalItems > 0) _buildSummaryBar(),
        ],
      ),
    );
  }

  Widget _vDivider() => Container(
      width: 1,
      height: 14,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      color: AppColors.borderGray);

  Widget _buildTabContent(String tab) {
    final items =
        allMenuItems.where((m) => m.tab == tab).toList();
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      itemCount: items.length,
      itemBuilder: (_, i) => _MenuItemCard(
        item: items[i],
        qty: _counts[items[i].name] ?? 0,
        onIncrement: () => setState(() =>
            _counts[items[i].name] =
                (_counts[items[i].name] ?? 0) + 1),
        onDecrement: () => setState(() {
          final cur = _counts[items[i].name] ?? 0;
          if (cur <= 1) {
            _counts.remove(items[i].name);
          } else {
            _counts[items[i].name] = cur - 1;
          }
        }),
      ),
    );
  }

  Widget _buildSummaryBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Color(0x14000000),
              blurRadius: 10,
              offset: Offset(0, -4))
        ],
      ),
      padding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('$_totalItems items selected',
                      style: GoogleFonts.inter(
                          fontSize: 12, color: AppColors.textGray)),
                  Text(
                      'Total: \$${_totalPrice.toStringAsFixed(2)}',
                      style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.midnightBlue)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 140,
              height: 44,
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const ConfirmationScreen()),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.champagneGold,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Text('Proceed →',
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Menu card with image ─────────────────────────────────────────────────────

class _MenuItemCard extends StatelessWidget {
  final MenuItemData item;
  final int qty;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _MenuItemCard({
    required this.item,
    required this.qty,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Food image
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(14)),
            child: CachedNetworkImage(
              imageUrl: item.imageUrl,
              width: double.infinity,
              height: 160,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                  height: 160, color: AppColors.surfaceVariant),
              errorWidget: (_, __, ___) => Container(
                height: 160,
                color: AppColors.surfaceVariant,
                child: const Icon(Icons.restaurant,
                    color: AppColors.borderGray, size: 36),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name,
                    style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.midnightBlue)),
                const SizedBox(height: 4),
                Text(item.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                        fontSize: 12, color: AppColors.textGray)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text('\$${item.price.toStringAsFixed(0)}',
                        style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.midnightBlue)),
                    const Spacer(),
                    qty == 0 ? _addButton() : _counterRow(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _addButton() {
    return GestureDetector(
      onTap: onIncrement,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
                color: AppColors.champagneGold, width: 1.5)),
        child: const Icon(Icons.add,
            size: 18, color: AppColors.champagneGold),
      ),
    );
  }

  Widget _counterRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _circleBtn(Icons.remove, onDecrement),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text('$qty',
              style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.champagneGold)),
        ),
        _circleBtn(Icons.add, onIncrement),
      ],
    );
  }

  Widget _circleBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(
            shape: BoxShape.circle, color: AppColors.champagneGold),
        child: Icon(icon, size: 16, color: Colors.white),
      ),
    );
  }
}
