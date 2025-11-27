import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/database_models.dart';

class DashboardService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      // Get total users count
      final usersResponse = await _client
          .from('users')
          .select()
          .count(CountOption.exact);

      // Get total farms count
      final farmsResponse = await _client
          .from('farms')
          .select()
          .count(CountOption.exact);

      // Get total scans count
      final scansResponse = await _client
          .from('scans')
          .select()
          .count(CountOption.exact);

      // Get active farms count
      final activeFarmsResponse = await _client
          .from('farms')
          .select()
          .eq('isactive', true)
          .count(CountOption.exact);

      // Get pending approval users count
      final pendingUsersResponse = await _client
          .from('users')
          .select()
          .eq('accountstatus', 'pending_approved')
          .count(CountOption.exact);

      return {
        'totalUsers': usersResponse.count ?? 0,
        'totalFarms': farmsResponse.count ?? 0,
        'totalScans': scansResponse.count ?? 0,
        'activeFarms': activeFarmsResponse.count ?? 0,
        'pendingUsers': pendingUsersResponse.count ?? 0,
      };
    } catch (e) {
      print('Error getting dashboard stats: $e');
      return {
        'totalUsers': 0,
        'totalFarms': 0,
        'totalScans': 0,
        'activeFarms': 0,
        'pendingUsers': 0,
      };
    }
  }

  Future<List<Map<String, dynamic>>> getRecentActivity() async {
    try {
      // Get recent scans with user and farm info
      final response = await _client
          .from('scans')
          .select('''
          *,
          users:farmerid(firstname, lastname),
          farms:farmid(farmname)
        ''')
          .order('scandate', ascending: false)
          .limit(10);

      return (response as List<dynamic>).map((scan) {
        final scanMap = scan as Map<String, dynamic>;
        final userData = scanMap['users'] as Map<String, dynamic>?;
        final farmData = scanMap['farms'] as Map<String, dynamic>?;

        return {
          'scan': Scan.fromMap(scanMap),
          'userName': userData != null
              ? '${userData['firstname']} ${userData['lastname']}'
              : 'Unknown User',
          'farmName': farmData?['farmname'] ?? 'Unknown Farm',
        };
      }).toList();
    } catch (e) {
      print('Error getting recent activity: $e');
      return [];
    }
  }
}