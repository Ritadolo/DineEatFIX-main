import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../core/app_theme.dart';
import '../data/dummy_data.dart';
import '../data/models/restaurant.dart';
import 'restaurant_detail_screen.dart';

class ViewAllScreen extends StatefulWidget {
  const ViewAllScreen({super.key});

  @override
  State<ViewAllScreen> createState() => _ViewAllScreenState();
}

class _ViewAllScreenState extends State<ViewAllScreen> {
  String _query = '';
  String _selectedCategory = 'All';

  static const _categories = [
    'All',
    'Fine Dining',
    'Omakase',
    'Seafood',
  ];

  List<Restaurant> get _filtered {
    return restaurants.where((r) {
      final matchCat =
          _selectedCategory == 'All' || r.category == _selectedCategory;
      final matchQ = _query.isEmpty ||
          r.name.toLowerCase().contains(_query.toLowerCase()) ||
          r.cuisine.toLowerCase().contains(_query.toLowerCase());
      return matchCat && matchQ;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const BackButton(color: AppColors.midnightBlue),
        title: Text('All Restaurants', style: headline(20)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildCategoryChips(),
          Expanded(child: _buildList()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: cardShadow,
        ),
        child: TextField(
          onChanged: (v) => setState(() => _query = v),
          style: body(14),
          decoration: InputDecoration(
            hintText: 'Search restaurants, cuisines...',
            hintStyle: body(14, color: AppColors.textGray),
            prefixIcon: const Icon(Icons.search,
                color: AppColors.textGray, size: 20),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final cat = _categories[i];
          final sel = cat == _selectedCategory;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                  horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: sel
                    ? AppColors.midnightBlue
                    : Colors.white,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                    color: sel
                        ? AppColors.midnightBlue
                        : AppColors.borderGray),
              ),
              child: Text(cat,
                  style: body(13,
                      color: sel
                          ? Colors.white
                          : AppColors.textPrimary,
                      fw: FontWeight.w500)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildList() {
    if (_filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off,
                size: 48, color: AppColors.borderGray),
            const SizedBox(height: 12),
            Text('No restaurants found',
                style: body(15, color: AppColors.textGray)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filtered.length,
      itemBuilder: (_, i) => _RestaurantListCard(
          restaurant: _filtered[i]),
    );
  }
}

class _RestaurantListCard extends StatelessWidget {
  final Restaurant restaurant;
  const _RestaurantListCard({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) =>
                RestaurantDetailScreen(restaurant: restaurant)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: cardShadow,
        ),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(16)),
              child: CachedNetworkImage(
                imageUrl: restaurant.imageUrl,
                width: 110,
                height: 110,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                    width: 110,
                    height: 110,
                    color: AppColors.surfaceVariant),
                errorWidget: (_, __, ___) => Container(
                    width: 110,
                    height: 110,
                    color: AppColors.surfaceVariant,
                    child: const Icon(Icons.restaurant,
                        color: AppColors.borderGray, size: 32)),
              ),
            ),
            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(restaurant.name,
                              style: GoogleFonts.playfairDisplay(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.midnightBlue)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.champagneGold
                                .withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star,
                                  size: 11,
                                  color: AppColors.champagneGold),
                              const SizedBox(width: 3),
                              Text(
                                restaurant.rating.toString(),
                                style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.midnightBlue),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(restaurant.cuisine,
                        style: body(12, color: AppColors.textGray)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 12, color: AppColors.textGray),
                        const SizedBox(width: 3),
                        Text(restaurant.distance,
                            style: body(12,
                                color: AppColors.textGray)),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.midnightBlue
                                .withOpacity(0.05),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(restaurant.priceRange,
                              style: body(11,
                                  color: AppColors.midnightBlue,
                                  fw: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.chevron_right,
                  color: AppColors.borderGray),
            ),
          ],
        ),
      ),
    );
  }
}
