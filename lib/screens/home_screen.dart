import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../core/app_theme.dart';
import '../data/dummy_data.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/restaurant_card.dart';
import 'my_bookings_screen.dart';
import 'saved_screen.dart';
import 'profile_screen.dart';
import 'view_all_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;
  String _selectedCategory = 'Fine Dining';

  static const _categories = [
    'Fine Dining',
    'Omakase',
    'Steakhouse',
    'Rooftop',
    'Seafood',
  ];

  List get _filteredList => _selectedCategory == 'All'
      ? restaurants
      : restaurants
          .where((r) => r.category == _selectedCategory)
          .toList();

  void _onNavTap(int index) {
    if (index == _navIndex) return;
    Widget? screen;
    switch (index) {
      case 1:
        screen = const MyBookingsScreen();
        break;
      case 2:
        screen = const SavedScreen();
        break;
      case 3:
        screen = const ProfileScreen();
        break;
    }
    if (screen != null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => screen!));
    } else {
      setState(() => _navIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: BottomNavBar(
        currentIndex: _navIndex,
        onTap: _onNavTap,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildAppBar()),
          SliverToBoxAdapter(child: _buildGreeting()),
          SliverToBoxAdapter(child: _buildSearchBar()),
          SliverToBoxAdapter(child: _buildCategories()),
          SliverToBoxAdapter(child: _buildSectionHeader()),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, i) =>
                  RestaurantCard(restaurant: _filteredList[i] as dynamic),
              childCount: _filteredList.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SafeArea(
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            const Icon(Icons.menu, color: AppColors.midnightBlue, size: 26),
            Expanded(
              child: Center(
                child: Text('DineAndGo', style: headline(20)),
              ),
            ),
            Container(
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
        ),
      ),
    );
  }

  Widget _buildGreeting() {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Good evening',
                    style: body(14, color: AppColors.textGray)),
                const SizedBox(height: 2),
                Text('Hello, Alexander', style: headline(28)),
              ],
            ),
          ),
          Stack(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: cardShadow,
                ),
                child: const Icon(Icons.notifications_outlined,
                    size: 22, color: AppColors.midnightBlue),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.champagneGold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: cardShadow,
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            const Icon(Icons.search,
                color: AppColors.textGray, size: 20),
            const SizedBox(width: 12),
            Text(
              'Search restaurants, cuisines...',
              style: GoogleFonts.inter(
                  fontSize: 14.5, color: AppColors.textGray),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final cat = _categories[i];
          final isSelected = cat == _selectedCategory;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                  horizontal: 18, vertical: 9),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.midnightBlue
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: isSelected
                      ? AppColors.midnightBlue
                      : AppColors.borderGray,
                ),
              ),
              child: Text(
                cat,
                style: body(13,
                    color: isSelected
                        ? Colors.white
                        : AppColors.textPrimary,
                    fw: FontWeight.w500),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Row(
        children: [
          Expanded(
              child: Text('Curated For You', style: headline(22))),
          TextButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(
                    builder: (_) => const ViewAllScreen())),
            child: Text('View All',
                style: body(14,
                    color: AppColors.champagneGold,
                    fw: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
