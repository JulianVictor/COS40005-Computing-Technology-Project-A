import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/database_models.dart';
import '../models/notification_model.dart';

class NotificationService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<AdminNotification>> getPendingApprovalNotifications() async {
    try {
      final response = await _client
          .from('admin_notifications')
          .select()
          .eq('type', 'user_registration')
          .eq('is_read', false)
          .order('created_at', ascending: false);

      return (response as List<dynamic>)
          .map((e) => AdminNotification.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting pending approval notifications: $e');
      return [];
    }
  }

  Future<List<AdminNotification>> getAllNotifications() async {
    try {
      final response = await _client
          .from('admin_notifications')
          .select()
          .order('created_at', ascending: false)
          .limit(50);

      return (response as List<dynamic>)
          .map((e) => AdminNotification.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting all notifications: $e');
      return [];
    }
  }

  Future<bool> markNotificationAsRead(String notificationId) async {
    try {
      final response = await _client
          .from('admin_notifications')
          .update({'is_read': true})
          .eq('id', notificationId);

      // Supabase returns the updated rows, so if response is not empty, it worked
      if (response != null) {
        print('✅ Successfully marked notification $notificationId as read');
        return true;
      }
      print('❌ Failed to mark notification $notificationId as read - null response');
      return false;
    } catch (e) {
      print('❌ Error marking notification as read: $e');
      return false;
    }
  }

  Future<bool> markAllNotificationsAsRead() async {
    try {
      final response = await _client
          .from('admin_notifications')
          .update({'is_read': true})
          .eq('is_read', false);

      // Supabase returns the updated rows, so if response is not empty, it worked
      if (response != null) {
        print('✅ Successfully marked all notifications as read');
        return true;
      }
      print('❌ Failed to mark all notifications as read - null response');
      return false;
    } catch (e) {
      print('❌ Error marking all notifications as read: $e');
      return false;
    }
  }

  Future<int> getUnreadNotificationCount() async {
    try {
      final response = await _client
          .from('admin_notifications')
          .select('id')
          .eq('is_read', false);

      // Return the number of rows returned
      final list = response as List<dynamic>;
      return list.length;
    } catch (e) {
      print('Error getting unread notification count: $e');
      return 0;
    }
  }

  Future<bool> createUserRegistrationNotification(AppUser user) async {
    try {
      final notification = {
        'title': 'New User Registration',
        'message':
            '${user.firstName} ${user.lastName} has registered and is pending approval',
        'user_id': user.userId,
        'user_email': user.email,
        'type': 'user_registration',
        'is_read': false,
        'created_at': DateTime.now().toIso8601String(),
      };

      final response = await _client.from('admin_notifications').insert(notification);
      
      if (response != null) {
        print('✅ Successfully created user registration notification');
        return true;
      }
      return false;
    } catch (e) {
      print('Error creating user registration notification: $e');
      return false;
    }
  }
}