import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/database_models.dart';

class FarmService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<Farm>> getUserFarms(String userId) async {
    try {
      final response = await _client
          .from('farms')
          .select()
          .eq('ownerid', userId.toLowerCase());

      return (response as List<dynamic>)
          .map((e) => Farm.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting farms: $e');
      return [];
    }
  }

  Future<bool> createFarm(Farm farm) async {
    try {
      await _client.from('farms').insert(farm.toMap());
      return true;
    } catch (e) {
      print('Error creating farm: $e');
      return false;
    }
  }

  Future<List<Farm>> getAllFarms() async {
    try {
      final response = await _client
          .from('farms')
          .select()
          .order('createdat', ascending: false);

      return (response as List<dynamic>)
          .map((e) => Farm.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting all farms: $e');
      return [];
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

  Future<bool> updateFarmStatus(String farmId, bool isActive) async {
    try {
      await _client
          .from('farms')
          .update({
            'isactive': isActive,
            'updatedat': DateTime.now().toIso8601String(),
          })
          .eq('farmid', farmId.toLowerCase());
      return true;
    } catch (e) {
      print('Error updating farm status: $e');
      return false;
    }
  }

  Future<bool> deleteFarm(String farmId) async {
    try {
      await _client.from('farms').delete().eq('farmid', farmId.toLowerCase());
      return true;
    } catch (e) {
      print('Error deleting farm: $e');
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
  Future<List<Scan>> getFarmScans(String farmId) async {
    try {
      final response = await _client
          .from('scans')
          .select()
          .eq('farmid', farmId.toLowerCase())
          .order('scandate', ascending: false);

      return (response as List<dynamic>)
          .map((e) => Scan.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting farm scans: $e');
      return [];
    }
  }
}