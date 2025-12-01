import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/database_models.dart';
import '../models/yield_record.dart' as yield_model;

class DatabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  // User Operations
  Future<AppUser?> getUser(String userId) async {
    try {
      final response = await _client
          .from('users')
          .select()
          .eq('userid', userId) // FIXED: lowercase 'userid'
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
          .eq('ownerid', userId); // FIXED: lowercase 'ownerid'

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

  // Yield Records Operations
  Future<List<yield_model.YieldRecord>> getYieldRecords(String farmerId, {String? farmId}) async {
    try {
      var query = _client
          .from('yield_records')
          .select()
          .eq('farmerid', farmerId); // lowercase

      if (farmId != null) {
        query = query.eq('farmid', farmId); // lowercase
      }

      final response = await query.order('harvestdate', ascending: false); // lowercase

      return (response as List<dynamic>)
          .map((e) => yield_model.YieldRecord.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting yield records: $e');
      return [];
    }
  }

  // ✅ ADD THIS METHOD - Yield Record Delete
  Future<void> deleteYieldRecord(String recordId) async {
    try {
      await _client
          .from('yield_records')
          .delete()
          .eq('recordid', recordId); // lowercase 'recordid'
    } catch (e) {
      print('Error deleting yield record: $e');
      rethrow;
    }
  }

  // Get farms for dropdown - FIXED
  Future<List<Map<String, dynamic>>> getUserFarmsForDropdown(String farmerId) async {
    try {
      final response = await _client
          .from('farms')
          .select('farmid, farmname') // lowercase
          .eq('ownerid', farmerId) // lowercase
          .eq('isactive', true); // lowercase

      return (response as List<dynamic>).cast<Map<String, dynamic>>();
    } catch (e) {
      print('Error getting farms for dropdown: $e');
      return [];
    }
  }
}