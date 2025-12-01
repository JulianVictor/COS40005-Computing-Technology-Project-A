// services/cocoa_yield_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/yield_record.dart' as yield_model;

class CocoaYieldService {
  final SupabaseClient _client = Supabase.instance.client;

  // Get yield records
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

  // Create yield record
  Future<String> createYieldRecord(yield_model.YieldRecord record) async {
    try {
      final recordMap = {
        'farmerid': record.farmerId,
        'farmid': record.farmId,
        'harvestdate': record.harvestDate.toIso8601String(),
        'beantype': record.beanType,
        'beangrade': record.beanGrade,
        'quantitykg': record.quantityKg,
        if (record.salesRevenue != null) 'salesrevenue': record.salesRevenue,
        if (record.remarks != null) 'remarks': record.remarks,
      };

      final response = await _client
          .from('yield_records')
          .insert(recordMap)
          .select();

      return response[0]['recordid'] as String;
    } catch (e) {
      print('Error creating yield record: $e');
      rethrow;
    }
  }

  // Update yield record
  Future<void> updateYieldRecord(yield_model.YieldRecord record) async {
    try {
      if (record.recordId == null) {
        throw Exception('Record ID is required for update');
      }

      final recordMap = {
        'farmerid': record.farmerId,
        'farmid': record.farmId,
        'harvestdate': record.harvestDate.toIso8601String(),
        'beantype': record.beanType,
        'beangrade': record.beanGrade,
        'quantitykg': record.quantityKg,
        if (record.salesRevenue != null) 'salesrevenue': record.salesRevenue,
        if (record.remarks != null) 'remarks': record.remarks,
      };

      await _client
          .from('yield_records')
          .update(recordMap)
          .eq('recordid', record.recordId!);
    } catch (e) {
      print('Error updating yield record: $e');
      rethrow;
    }
  }

  // Delete yield record
  Future<void> deleteYieldRecord(String recordId) async {
    try {
      await _client
          .from('yield_records')
          .delete()
          .eq('recordid', recordId);
    } catch (e) {
      print('Error deleting yield record: $e');
      rethrow;
    }
  }
}