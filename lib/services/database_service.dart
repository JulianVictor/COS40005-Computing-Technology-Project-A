import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  // Core database connection check
  Future<bool> checkConnection() async {
    try {
      await _client.from('users').select().limit(1);
      return true;
    } catch (e) {
      print('Database connection error: $e');
      return false;
    }
  }

  // Get the Supabase client instance (if needed by other services)
  SupabaseClient get client => _client;
}