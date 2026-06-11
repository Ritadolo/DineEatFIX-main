import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../core/app_theme.dart';
import '../data/models/restaurant.dart';
import '../widgets/bottom_nav_bar.dart';
import 'home_screen.dart';
import 'my_bookings_screen.dart';
import 'profile_screen.dart';
import 'restaurant_detail_screen.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({Key? key}) : super(key: key);

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final List<bool> _saved = [true, true];

  static const _savedRestaurants = [
    Restaurant(
      id: 'r2',
      name: 'Kintaro',
      cuisine: 'Japanese • Omakase',
      address: '88 Sakura Lane, Midtown',
      imageUrl:
          'https://images.unsplash.com/photo-1617196034183-421b4040ed20?w=800&q=80',
      category: 'Omakase',
      priceRange: r'$$$$',
      distance: '0.8 mi',
      rating: 4.9,
    ),
    Restaurant(
      id: 'r3',
      name: 'Le Bernardin',
      cuisine: 'French • Seafood',
      address: '55 Ocean Drive, West Side',
      imageUrl:
          'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800&q=80',
      category: 'Seafood',
      priceRange: r'$$$$',
      distance: '1.2 mi',
      rating: 4.8,
    ),
  ];

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
      case 1:
        screen = const MyBookingsScreen();
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
        title: Text('DineAndGo', style: headline(20)),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.champagneGold,
            ),
            child: const Icon(Icons.person,
                size: 20, color: Colors.white),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.champagneGold,
          indicatorWeight: 2,
          labelStyle: GoogleFonts.inter(
              fontSize: 14, fontWeight: FontWeight.bold),
          unselectedLabelStyle: GoogleFonts.inter(fontSize: 14),
          labelColor: AppColors.midnightBlue,
          unselectedLabelColor: AppColors.textGray,
          tabs: const [
            Tab(text: 'Restaurants'),
            Tab(text: 'Dishes'),
          ],
        ),
      ),
      bottomNavigationBar:
          BottomNavBar(currentIndex: 2, onTap: _onNavTap),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRestaurantsTab(),
          _buildDishesTab(),
        ],
      ),
    );
  }

  Widget _buildRestaurantsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _savedRestaurants.length,
      itemBuilder: (_, i) {
        final r = _savedRestaurants[i];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    RestaurantDetailScreen(restaurant: r)),
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: cardShadow,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(r.name,
                          style: GoogleFonts.playfairDisplay(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.midnightBlue)),
                      const SizedBox(height: 4),
                      Text('${r.cuisine} · ${r.distance}',
                          style: body(13,
                              color: AppColors.textGray)),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: AppColors.borderGray),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star,
                              size: 13,
                              color: AppColors.champagneGold),
                          const SizedBox(width: 4),
                          Text(r.rating.toString(),
                              style: body(12,
                                  color: AppColors.midnightBlue,
                                  fw: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () =>
                          setState(() => _saved[i] = !_saved[i]),
                      child: Icon(
                        _saved[i]
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: AppColors.champagneGold,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDishesTab() {
    return Center(
      child: Text('No saved dishes',
          style: body(14, color: AppColors.textGray)),
    );
  }
}
