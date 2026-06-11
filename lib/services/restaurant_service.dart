import '../data/models/restaurant.dart';
import '../data/dummy_data.dart';
import 'supabase_client.dart';

class RestaurantService {
  static Future<List<Restaurant>> fetchAll() async {
    try {
      final data = await supabase
          .from('restaurants')
          .select()
          .order('rating', ascending: false);

      return (data as List).map((r) => Restaurant(
            id: r['id'] as String,
            name: r['name'] as String,
            cuisine: r['cuisine'] as String,
            address: r['address'] as String,
            imageUrl: r['image_url'] as String,
            category: r['category'] as String,
            priceRange: r['price_range'] as String,
            distance: r['distance'] as String,
            rating: (r['rating'] as num).toDouble(),
          )).toList();
    } catch (_) {
      // Supabase table not seeded yet — fall back to local dummy data
      return restaurants;
    }
  }
}
