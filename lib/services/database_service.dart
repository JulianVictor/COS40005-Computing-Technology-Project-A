import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/database_models.dart';
import '../models/yield_record.dart' as yield_model; // Alias to avoid conflict

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

      return (response as List<dynamic>).map((e) => Farm.fromMap(e as Map<String, dynamic>)).toList();
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

  // === NEW YIELD RECORDS OPERATIONS ===
  Future<List<yield_model.YieldRecord>> getYieldRecords(String farmerId, {String? farmId}) async {
    try {
      var query = _client
          .from('yield_records')
          .select()
          .eq('farmerId', farmerId);

      if (farmId != null) {
        query = query.eq('farmId', farmId);
      }

      final response = await query.order('harvestDate', ascending: false);

      return (response as List<dynamic>)
          .map((e) => yield_model.YieldRecord.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting yield records: $e');
      return [];
    }
  }

  Future<String> createYieldRecord(yield_model.YieldRecord record) async {
    try {
      final response = await _client
          .from('yield_records')
          .insert(record.toMap())
          .select();

      return response[0]['recordId'] as String;
    } catch (e) {
      print('Error creating yield record: $e');
      rethrow;
    }
  }

  Future<void> updateYieldRecord(yield_model.YieldRecord record) async {
    try {
      await _client
          .from('yield_records')
          .update(record.toMap())
          .eq('recordId', record.recordId!);
    } catch (e) {
      print('Error updating yield record: $e');
      rethrow;
    }
  }

  Future<void> deleteYieldRecord(String recordId) async {
    try {
      await _client
          .from('yield_records')
          .delete()
          .eq('recordId', recordId);
    } catch (e) {
      print('Error deleting yield record: $e');
      rethrow;
    }
  }

  // Get farms for dropdown selection
  Future<List<Map<String, dynamic>>> getUserFarmsForDropdown(String farmerId) async {
    try {
      final response = await _client
          .from('farms')
          .select('farmId, farmName')
          .eq('ownerId', farmerId)
          .eq('isActive', true);

      return (response as List<dynamic>).cast<Map<String, dynamic>>();
    } catch (e) {
      print('Error getting farms for dropdown: $e');
      return [];
    }
  }

// Add other methods as needed...
}