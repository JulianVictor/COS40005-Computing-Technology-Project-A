import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/database_models.dart';

class UserService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<AppUser?> getUser(String userId) async {
    try {
      final response = await _client
          .from('users')
          .select()
          .eq('userid', userId.toLowerCase())
          .single();

      return AppUser.fromMap(response);
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  Future<List<AppUser>> getAllUsers() async {
    try {
      final response = await _client
          .from('users')
          .select()
          .order('createdat', ascending: false);

      return (response as List<dynamic>)
          .map((e) => AppUser.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting all users: $e');
      return [];
    }
  }

  Future<bool> createUser(AppUser user) async {
    try {
      await _client.from('users').insert(user.toMap());
      return true;
    } catch (e) {
      print('Error creating user: $e');
      return false;
    }
  }

  Future<bool> updateUserStatus(String userId, String newStatus) async {
    try {
      final user = await getUser(userId);
      final oldStatus = user?.accountStatus;

      await _client
          .from('users')
          .update({
            'accountstatus': newStatus,
            'updatedat': DateTime.now().toIso8601String(),
          })
          .eq('userid', userId.toLowerCase());

      // Create notification when status changes to approved
      if (newStatus == 'approved' && oldStatus != 'approved' && user != null) {
        await _createApprovalNotification(user);

        // Send approval email if user has email
        if (user.email != null && user.email!.isNotEmpty) {
          await _sendApprovalEmail(user);
        }
      }

      return true;
    } catch (e) {
      print('Error updating user status: $e');
      return false;
    }
  }

  Future<bool> updateUserRole(String userId, String newRole) async {
    try {
      await _client
          .from('users')
          .update({
            'role': newRole,
            'updatedat': DateTime.now().toIso8601String(),
          })
          .eq('userid', userId.toLowerCase());
      return true;
    } catch (e) {
      print('Error updating user role: $e');
      return false;
    }
  }

  Future<bool> deleteUser(String userId) async {
    try {
      await _client.from('users').delete().eq('userid', userId.toLowerCase());
      return true;
    } catch (e) {
      print('Error deleting user: $e');
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

  Future<List<Farm>> getUserFarms(String userId) async {
    try {
      final response = await _client
          .from('farms')
          .select()
          .eq('ownerid', userId.toLowerCase())
          .order('createdat', ascending: false);

      return (response as List<dynamic>)
          .map((e) => Farm.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting user farms: $e');
      return [];
    }
  }

  Future<void> _createApprovalNotification(AppUser user) async {
    try {
      final notification = {
        'title': 'User Account Approved',
        'message':
            '${user.firstName} ${user.lastName} account has been approved',
        'user_id': user.userId,
        'user_email': user.email ?? '',
        'type': 'system_alert',
        'is_read': false,
        'created_at': DateTime.now().toIso8601String(),
      };

      await _client.from('admin_notifications').insert(notification);
    } catch (e) {
      print('Error creating approval notification: $e');
    }
  }

  Future<void> _sendApprovalEmail(AppUser user) async {
    try {
      print('📧 Starting approval email process for ${user.email}...');

      // Use Supabase Edge Function
      final response = await _client.functions.invoke(
        'send-approval-email',
        body: {
          'email': user.email!,
          'user_name': '${user.firstName} ${user.lastName}',
          'phone_number': user.phoneNumber ?? 'N/A',
        },
      );

      if (response.status == 200) {
        final data = response.data;
        print('✅ Edge Function Success!');
        print('   Message: ${data['message']}');
        print('   User: ${data['data']['user_name']}');
        print('   Email: ${data['data']['to']}');
        print('   Time: ${data['data']['logged_at']}');

        // Log to database for admin reference
        await _logEmailToDatabase(user, 'edge_function_success');
      } else {
        print('❌ Edge Function Failed with status: ${response.status}');
        // FunctionResponse doesn't expose an 'error' getter; print available response data for debugging
        print('   Response Data: ${response.data}');
        await _logEmailToDatabase(user, 'edge_function_failed');
        _logEmailFallback(user);
      }
    } catch (e) {
      print('❌ Edge Function Exception: $e');
      await _logEmailToDatabase(user, 'edge_function_exception');
      _logEmailFallback(user);
    }
  }

  Future<void> _logEmailToDatabase(AppUser user, String status) async {
    try {
      await _client.from('email_logs').insert({
        'user_id': user.userId,
        'user_email': user.email,
        'user_name': '${user.firstName} ${user.lastName}',
        'phone_number': user.phoneNumber,
        'email_type': 'account_approval',
        'status': status,
        'created_at': DateTime.now().toIso8601String(),
      });
      print('📝 Email logged to database with status: $status');
    } catch (e) {
      print('⚠️ Failed to log email to database: $e');
    }
  }

  void _logEmailFallback(AppUser user) {
    print('''
📧 EMAIL NOTIFICATION (Fallback)
===========================================
TO: ${user.email}
SUBJECT: Your CPBAiVision App Account Has Been Approved

CONTENT:
Dear ${user.firstName} ${user.lastName},

Your CPBAiVision App Account has been approved!

You can now login to the app using your registered credentials.

Account Details:
- Name: ${user.firstName} ${user.lastName}
- Email: ${user.email}
- Phone: ${user.phoneNumber ?? 'N/A'}

Best regards,
CPBAiVision Team
===========================================
  ''');
  }
}