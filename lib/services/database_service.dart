import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/database_models.dart';

class DatabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  // User Operations
  Future<AppUser?> getUser(String userId) async {
    try {
      final response = await _client
          .from('users')
          .select()
          .eq('userId', userId)
          .single();
      
      return AppUser.fromMap(response);
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  Future<void> createUser(AppUser user) async {
    try {
      await _client.from('users').insert(user.toMap());
    } catch (e) {
      print('Error creating user: $e');
      rethrow;
    }
  }

  // Farm Operations
  Future<List<Farm>> getUserFarms(String userId) async {
    try {
      final response = await _client
          .from('farms')
          .select()
          .eq('ownerId', userId);
      
      return (response as List).map((e) => Farm.fromMap(e)).toList();
    } catch (e) {
      print('Error getting farms: $e');
      return [];
    }
  }

  Future<void> createFarm(Farm farm) async {
    try {
      await _client.from('farms').insert(farm.toMap());
    } catch (e) {
      print('Error creating farm: $e');
      rethrow;
    }
  }

  // Scan Operations
  Future<void> createScan(Map<String, dynamic> scanData) async {
    try {
      await _client.from('scans').insert(scanData);
    } catch (e) {
      print('Error creating scan: $e');
      rethrow;
    }
  }

  // Add other methods as needed...
}