import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/farm_selection_models.dart';

class FarmSelectionService {
  final SupabaseClient _client = Supabase.instance.client;

  // Get all farms for a user
  Future<List<FarmSelection>> getUserFarms(String userId) async {
    try {
      final response = await _client
          .from('farms')
          .select()
          .eq('ownerid', userId)
          .order('createdat', ascending: false);

      if (response == null || response.isEmpty) {
        return [];
      }

      return (response as List)
          .map((farmData) => FarmSelection.fromMap(farmData))
          .toList();
    } catch (e) {
      print('Error fetching farm selections: $e');
      return [];
    }
  }

  // Add a new farm
  Future<FarmSelection?> addFarm(FarmSelection farm) async {
    try {
      final response = await _client
          .from('farms')
          .insert(farm.toSupabaseMap())
          .select()
          .single();

      if (response == null) return null;
      return FarmSelection.fromMap(response);
    } catch (e) {
      print('Error adding farm: $e');
      return null;
    }
  }

  // Update existing farm
  Future<FarmSelection?> updateFarm(FarmSelection farm) async {
    try {
      final updateData = farm.toSupabaseMap();
      updateData['updatedat'] = DateTime.now().toIso8601String();

      final response = await _client
          .from('farms')
          .update(updateData)
          .eq('farmid', farm.farmId)
          .select()
          .single();

      if (response == null) return null;
      return FarmSelection.fromMap(response);
    } catch (e) {
      print('Error updating farm: $e');
      return null;
    }
  }

  // Delete farm
  Future<bool> deleteFarm(String farmId) async {
    try {
      await _client
          .from('farms')
          .delete()
          .eq('farmid', farmId);
      return true;
    } catch (e) {
      print('Error deleting farm: $e');
      return false;
    }
  }

  // Get single farm by ID
  Future<FarmSelection?> getFarmById(String farmId) async {
    try {
      final response = await _client
          .from('farms')
          .select()
          .eq('farmid', farmId)
          .single();

      if (response == null) return null;
      return FarmSelection.fromMap(response);
    } catch (e) {
      print('Error fetching farm: $e');
      return null;
    }
  }
}