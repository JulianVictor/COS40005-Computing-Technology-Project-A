import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/database_models.dart';

class ScanService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<bool> createScan(Map<String, dynamic> scanData) async {
    try {
      await _client.from('scans').insert(scanData);
      return true;
    } catch (e) {
      print('Error creating scan: $e');
      return false;
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

  Future<List<Scan>> getAllScans() async {
    try {
      final response = await _client
          .from('scans')
          .select()
          .order('scandate', ascending: false);

      return (response as List<dynamic>)
          .map((e) => Scan.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting all scans: $e');
      return [];
    }
  }

  Future<List<ScanSession>> getAllScanSessions() async {
    try {
      final response = await _client
          .from('scan_sessions')
          .select()
          .order('sessiondate', ascending: false);

      return (response as List<dynamic>)
          .map((e) => ScanSession.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting all scan sessions: $e');
      return [];
    }
  }
}