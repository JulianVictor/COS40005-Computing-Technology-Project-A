import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/database_models.dart';

class YieldService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<YieldRecord>> getAllYieldRecords() async {
    try {
      final response = await _client
          .from('yield_records')
          .select()
          .order('harvestdate', ascending: false);

      return (response as List<dynamic>)
          .map((e) => YieldRecord.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting all yield records: $e');
      return [];
    }
  }

  Future<bool> deleteYieldRecord(String recordId) async {
    try {
      await _client
          .from('yield_records')
          .delete()
          .eq('recordid', recordId.toLowerCase());
      return true;
    } catch (e) {
      print('Error deleting yield record: $e');
      return false;
    }
  }

  // Additional yield-specific methods you might need:
  Future<List<YieldRecord>> getYieldRecordsByFarm(String farmId) async {
    try {
      final response = await _client
          .from('yield_records')
          .select()
          .eq('farmid', farmId.toLowerCase())
          .order('harvestdate', ascending: false);

      return (response as List<dynamic>)
          .map((e) => YieldRecord.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting yield records by farm: $e');
      return [];
    }
  }

  Future<bool> createYieldRecord(YieldRecord record) async {
    try {
      await _client.from('yield_records').insert(record.toMap());
      return true;
    } catch (e) {
      print('Error creating yield record: $e');
      return false;
    }
  }

  Future<bool> updateYieldRecord(YieldRecord record) async {
    try {
      await _client
          .from('yield_records')
          .update(record.toMap())
          .eq('recordid', record.recordId.toLowerCase());
      return true;
    } catch (e) {
      print('Error updating yield record: $e');
      return false;
    }
  }
  Future<AppUser?> getUserById(String userId) async {
    try {
      final response = await _client
          .from('users')
          .select()
          .eq('userid', userId.toLowerCase())
          .single();

      return AppUser.fromMap(response);
    } catch (e) {
      print('Error getting user by ID: $e');
      return null;
    }
  }
  Future<Farm?> getFarmById(String farmId) async {
    try {
      final response = await _client
          .from('farms')
          .select()
          .eq('farmid', farmId.toLowerCase())
          .single();

      return Farm.fromMap(response);
    } catch (e) {
      print('Error getting farm by ID: $e');
      return null;
    }
  }
}