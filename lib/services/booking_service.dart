import 'supabase_client.dart';
import 'auth_service.dart';

class BookingService {
  static Future<List<Map<String, dynamic>>> fetchMyBookings() async {
    final uid = AuthService.currentUser?.id;
    if (uid == null) return [];
    final data = await supabase
        .from('bookings')
        .select('*, restaurants(name, image_url, cuisine)')
        .eq('user_id', uid)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(data as List);
  }

  static Future<void> createBooking({
    required String restaurantId,
    required String date,
    required String time,
    required int guests,
    String? tableNumber,
    String? specialRequests,
  }) async {
    final uid = AuthService.currentUser?.id;
    if (uid == null) throw Exception('Not logged in');
    await supabase.from('bookings').insert({
      'user_id': uid,
      'restaurant_id': restaurantId,
      'date': date,
      'time': time,
      'guests': guests,
      'table_number': tableNumber,
      'special_requests': specialRequests,
      'status': 'pending',
    });
  }

  static Future<void> cancelBooking(String bookingId) async {
    await supabase
        .from('bookings')
        .update({'status': 'cancelled'})
        .eq('id', bookingId);
  }
}
