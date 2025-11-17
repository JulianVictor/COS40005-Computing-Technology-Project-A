import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseClient {
  static final supabase = Supabase.instance.client;

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'YOUR_SUPABASE_URL',
      anonKey: 'YOUR_ANON_KEY',
    );
  }
}