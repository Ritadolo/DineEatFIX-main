import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../core/app_theme.dart';
import '../data/models/restaurant.dart';
import '../screens/restaurant_detail_screen.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantCard({Key? key, required this.restaurant})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                RestaurantDetailScreen(restaurant: restaurant),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            boxShadow: cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImage(),
              _buildInfoRow(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(18)),
          child: CachedNetworkImage(
            imageUrl: restaurant.imageUrl,
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
            placeholder: (_, __) => Container(
              height: 200,
              color: AppColors.surfaceVariant,
              child: const Center(
                child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.champagneGold),
              ),
            ),
            errorWidget: (_, __, ___) => Container(
              height: 200,
              color: AppColors.surfaceVariant,
              child: const Icon(Icons.restaurant,
                  color: AppColors.borderGray, size: 48),
            ),
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2))
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star,
                    size: 14, color: AppColors.champagneGold),
                const SizedBox(width: 4),
                Text(
                  restaurant.rating.toString(),
                  style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.midnightBlue),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurant.name,
                  style: GoogleFonts.playfairDisplay(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.midnightBlue),
                ),
                const SizedBox(height: 3),
                Text(
                  '${restaurant.cuisine} • ${restaurant.distance}',
                  style: GoogleFonts.inter(
                      fontSize: 13, color: AppColors.textGray),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    RestaurantDetailScreen(restaurant: restaurant),
              ),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.champagneGold,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Book',
                style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
