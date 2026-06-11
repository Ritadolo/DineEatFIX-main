import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../core/app_theme.dart';

// ── Shared menu data (same as pre_order but importable) ─────────────────────

class MenuItemData {
  final String name;
  final String description;
  final double price;
  final String tab;
  final String imageUrl;

  const MenuItemData(
      this.name, this.description, this.price, this.tab, this.imageUrl);
}

const allMenuItems = [
  // Appetizers
  MenuItemData('Pan-Seared Scallops', 'Cauliflower purée, caper-golden raisin emulsion, brown butter.', 42.0, 'Appetizers', 'https://images.unsplash.com/photo-1559847844-5315695dadae?w=400&q=80'),
  MenuItemData('Foie Gras Torchon', 'Brioche toast, Sauternes jelly, pickled grapes, micro herbs.', 55.0, 'Appetizers', 'https://images.unsplash.com/photo-1572441713132-c542fc4fe282?w=400&q=80'),
  MenuItemData('Truffle Arancini', 'Black truffle, aged Parmigiano, saffron aioli.', 28.0, 'Appetizers', 'https://images.unsplash.com/photo-1595295333158-4742f28fbd85?w=400&q=80'),
  // Mains
  MenuItemData('Wagyu Beef Tenderloin', 'Truffle potato mousseline, glazed heirloom carrots, bordelaise sauce.', 85.0, 'Mains', 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=400&q=80'),
  MenuItemData('Wild Caught Halibut', 'White asparagus, morel mushrooms, champagne velouté.', 48.0, 'Mains', 'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=400&q=80'),
  MenuItemData('Duck à l\'Orange', 'Confit duck leg, orange gastrique, lentils du Puy, crispy skin.', 58.0, 'Mains', 'https://images.unsplash.com/photo-1518492104633-130d0cc84637?w=400&q=80'),
  MenuItemData('Lobster Thermidor', 'Half Maine lobster, cognac cream, gruyère crust, pommes dauphine.', 120.0, 'Mains', 'https://images.unsplash.com/photo-1565680018434-b513d5e5fd47?w=400&q=80'),
  // Wine
  MenuItemData('Sommelier Wine Pairing', 'Curated selection matching each course.', 85.0, 'Wine', 'https://images.unsplash.com/photo-1510812431401-41d2bd2722f3?w=400&q=80'),
  MenuItemData('Château Margaux 2015', 'Premier Grand Cru Classé, Bordeaux.', 220.0, 'Wine', 'https://images.unsplash.com/photo-1568213816046-0ee1c42bd559?w=400&q=80'),
  MenuItemData('Opus One 2018', 'Napa Valley Bordeaux blend, blackcurrant, dark plum, cedar.', 180.0, 'Wine', 'https://images.unsplash.com/photo-1553361371-9b22f78e8b1d?w=400&q=80'),
  MenuItemData('Krug Grande Cuvée', 'Prestige champagne, toasted brioche, dried fruits, almonds.', 145.0, 'Wine', 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400&q=80'),
  // Desserts
  MenuItemData('Mille-Feuille Vanille', 'Tahitian vanilla cream, caramelised puff pastry.', 22.0, 'Desserts', 'https://images.unsplash.com/photo-1517093787686-0e5f05a82999?w=400&q=80'),
  MenuItemData('Soufflé au Chocolat', 'Valrhona dark chocolate, crème anglaise.', 24.0, 'Desserts', 'https://images.unsplash.com/photo-1586985289688-ca3cf47d3e6e?w=400&q=80'),
  MenuItemData('Crème Brûlée', 'Classic Madagascar vanilla, caramelised sugar crust.', 18.0, 'Desserts', 'https://images.unsplash.com/photo-1470124182917-cc6e71b22ecc?w=400&q=80'),
  MenuItemData('Tarte Tatin', 'Caramelised apple, warm puff pastry, crème fraîche.', 20.0, 'Desserts', 'https://images.unsplash.com/photo-1621743478914-cc8a86d7e7b5?w=400&q=80'),
];

const _tabs = ['Appetizers', 'Mains', 'Wine', 'Desserts'];

// ── Screen ───────────────────────────────────────────────────────────────────

class ModifyPreOrderScreen extends StatefulWidget {
  const ModifyPreOrderScreen({super.key});

  @override
  State<ModifyPreOrderScreen> createState() =>
      _ModifyPreOrderScreenState();
}

class _ModifyPreOrderScreenState extends State<ModifyPreOrderScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final Map<String, int> _counts = {
    'Wagyu Beef Tenderloin': 1,
    'Sommelier Wine Pairing': 1,
  };

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
        leading: const BackButton(color: AppColors.midnightBlue),
        title: Text('Modify Pre-order', style: headline(20)),
        centerTitle: true,
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
                Text("L'Aura",
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
          _buildSummaryBar(),
        ],
      ),
    );
  }

  Widget _vDivider() {
    return Container(
        width: 1,
        height: 14,
        margin: const EdgeInsets.symmetric(horizontal: 12),
        color: AppColors.borderGray);
  }

  Widget _buildTabContent(String tab) {
    final items =
        allMenuItems.where((m) => m.tab == tab).toList();
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      itemCount: items.length,
      itemBuilder: (_, i) => _MenuCard(
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
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Pre-order updated!',
                          style: GoogleFonts.inter(
                              color: Colors.white)),
                      backgroundColor: AppColors.confirmed,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.champagneGold,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Text('Save Changes',
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 13)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Menu card with image ─────────────────────────────────────────────────────

class _MenuCard extends StatelessWidget {
  final MenuItemData item;
  final int qty;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _MenuCard({
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
          // Image
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
                    Text(
                        '\$${item.price.toStringAsFixed(0)}',
                        style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.midnightBlue)),
                    const Spacer(),
                    qty == 0 ? _addBtn() : _counterRow(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _addBtn() {
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
