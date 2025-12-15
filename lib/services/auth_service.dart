import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/supabase_config.dart';

class AuthService {
  User? get currentUser => SupabaseConfig.client.auth.currentUser;

  Stream<AuthState> get authStateChanges => SupabaseConfig.client.auth.onAuthStateChange;

  // Static/Singleton to hold the current integer cust_id session
  static int? currentCustomerId;

  Future<AuthResponse> signUp(String email, String password) async {
    final response = await SupabaseConfig.client.auth.signUp(
      email: email,
      password: password,
    );
    
    if (response.user != null) {
      await _ensureCustomerRecord(response.user!.email!);
    }
    
    return response;
  }

  Future<AuthResponse> signIn(String email, String password) async {
    final response = await SupabaseConfig.client.auth.signInWithPassword(
      email: email,
      password: password,
    );

     if (response.user != null) {
      await _ensureCustomerRecord(response.user!.email!);
    }

    return response;
  }

  Future<void> signOut() async {
    currentCustomerId = null;
    await SupabaseConfig.client.auth.signOut();
  }

  // Helper to sync Auth User with SQL Customer Table
  Future<void> _ensureCustomerRecord(String email) async {
    try {
      // 1. Check if customer exists by email
      final response = await SupabaseConfig.client
          .from('customers')
          .select('cust_id')
          .eq('email', email)
          .maybeSingle();

      if (response != null) {
        currentCustomerId = response['cust_id'] as int;
      } else {
        // 2. Create new customer
        // Generate a random int ID (simple approach for this context)
        final newId = DateTime.now().millisecondsSinceEpoch % 2147483647; 
        
        await SupabaseConfig.client.from('customers').insert({
          'cust_id': newId,
          'email': email,
          // Optional fields can be updated later in Profile
          'f_name': '',
          'l_name': '',
        });
        
        currentCustomerId = newId;
      }
    } catch (e) {
      print('Error syncing customer: $e');
      // Fallback or rethrow depending on severity
    }
  }
  
  // Method to manually load ID if needed (e.g. on app restart)
  Future<void> loadSession() async {
    final user = currentUser;
    if (user != null && user.email != null) {
      await _ensureCustomerRecord(user.email!);
    }
  }
}
