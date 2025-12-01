// services/database_service.dart - CLEANED VERSION
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/database_models.dart';
// REMOVE: import '../models/yield_record.dart' as yield_model;

class DatabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  // User Operations
  Future<AppUser?> getUser(String userId) async {
    try {
      final response = await _client
          .from('users')
          .select()
          .eq('userid', userId)
          .single();

      return AppUser.fromMap(response);
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  // Farm Operations - FIXED
  Future<List<Farm>> getUserFarms(String userId) async {
    try {
      final response = await _client
          .from('farms')
          .select()
          .eq('ownerid', userId);

      return (response as List<dynamic>)
          .map((e) => Farm.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting farms: $e');
      return [];
    }
  }

  // CREATE Farm - FIXED
  Future<void> createFarm(Farm farm) async {
    try {
      final farmMap = {
        'ownerid': farm.ownerId,
        'farmname': farm.farmName,
        'state': farm.state,
        'district': farm.district,
        'village': farm.village,
        'postcode': farm.postcode,
        'areahectares': farm.areaHectares,
        'treecount': farm.treeCount,
        'isactive': farm.isActive,
        'createdat': farm.createdAt.toIso8601String(),
        'updatedat': farm.updatedAt.toIso8601String(),
      };

      await _client.from('farms').insert(farmMap);
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

  // Get farms for dropdown - FIXED
  Future<List<Map<String, dynamic>>> getUserFarmsForDropdown(String farmerId) async {
    try {
      final response = await _client
          .from('farms')
          .select('farmid, farmname')
          .eq('ownerid', farmerId)
          .eq('isactive', true);

      return (response as List<dynamic>).cast<Map<String, dynamic>>();
    } catch (e) {
      print('Error getting farms for dropdown: $e');
      return [];
    }
  }
}