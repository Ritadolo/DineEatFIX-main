import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_client.dart';

class AuthService {
  // ── Current user ─────────────────────────────────────────────────────────
  static User? get currentUser => supabase.auth.currentUser;
  static bool get isLoggedIn => currentUser != null;

  // ── Sign up ───────────────────────────────────────────────────────────────
  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  }) async {
    final res = await supabase.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName, 'phone': phone ?? ''},
    );
    // Upsert profile row
    if (res.user != null) {
      await supabase.from('profiles').upsert({
        'id': res.user!.id,
        'full_name': fullName,
        'phone': phone ?? '',
      });
    }
    return res;
  }

  // ── Sign in ───────────────────────────────────────────────────────────────
  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // ── Sign out ──────────────────────────────────────────────────────────────
  static Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  // ── Fetch profile ─────────────────────────────────────────────────────────
  static Future<Map<String, dynamic>?> fetchProfile() async {
    final uid = currentUser?.id;
    if (uid == null) return null;
    final res = await supabase
        .from('profiles')
        .select()
        .eq('id', uid)
        .maybeSingle();
    return res;
  }
}
