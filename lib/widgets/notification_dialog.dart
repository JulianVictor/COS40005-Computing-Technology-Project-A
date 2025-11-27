// widgets/notification_dialog.dart
import 'package:flutter/material.dart';
import '../models/notification_model.dart';
import '../services/notification_service.dart';

class NotificationDialog extends StatefulWidget {
  const NotificationDialog({super.key});

  @override
  State<NotificationDialog> createState() => _NotificationDialogState();
}

class _NotificationDialogState extends State<NotificationDialog> {
  final NotificationService _notificationService = NotificationService();
  List<AdminNotification> _notifications = [];
  bool _isLoading = true;
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final notifications = await _notificationService.getAllNotifications();
      final unreadCount = await _notificationService
          .getUnreadNotificationCount();

      setState(() {
        _notifications = notifications;
        _unreadCount = unreadCount;
      });
    } catch (e) {
      print('Error loading notifications: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _markAsRead(String notificationId) async {
  print('🔄 Marking notification $notificationId as read...');
  final success = await _notificationService.markNotificationAsRead(notificationId);
  
  if (success) {
    print('✅ Successfully marked notification as read in database');
    // Create a new list with the updated notification
    setState(() {
      _notifications = _notifications.map((notification) {
        if (notification.id == notificationId) {
          // Create a new AdminNotification with isRead = true
          return AdminNotification(
            id: notification.id,
            title: notification.title,
            message: notification.message,
            userId: notification.userId,
            userEmail: notification.userEmail,
            createdAt: notification.createdAt,
            isRead: true, // Mark as read
            type: notification.type,
          );
        }
        return notification;
      }).toList();
      
      // Update unread count
      _unreadCount = _notifications.where((n) => !n.isRead).length;
      print('📊 Updated unread count: $_unreadCount');
    });
  } else {
    print('❌ Failed to mark notification as read in database');
    // Show error message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Failed to mark notification as read'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

Future<void> _markAllAsRead() async {
  print('🔄 Marking all notifications as read...');
  final success = await _notificationService.markAllNotificationsAsRead();
  
  if (success) {
    print('✅ Successfully marked all notifications as read in database');
    // Update all notifications to read
    setState(() {
      _notifications = _notifications.map((notification) {
        return AdminNotification(
          id: notification.id,
          title: notification.title,
          message: notification.message,
          userId: notification.userId,
          userEmail: notification.userEmail,
          createdAt: notification.createdAt,
          isRead: true, // Mark all as read
          type: notification.type,
        );
      }).toList();
      
      _unreadCount = 0;
      print('📊 Updated unread count: $_unreadCount');
    });
  } else {
    print('❌ Failed to mark all notifications as read in database');
    // Show error message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Failed to mark all notifications as read'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

  void _handleNotificationTap(
    AdminNotification notification,
    BuildContext context,
  ) {
    // Mark as read when tapped
    _markAsRead(notification.id);

    // Navigate to user management for approval
    if (notification.type == NotificationType.userRegistration) {
      Navigator.of(context).pop(); // Close notification dialog
      // You might want to add navigation logic here to user management page
      // with focus on the specific user
    }
  }

  Widget _buildNotificationItem(AdminNotification notification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: notification.isRead ? Colors.white : Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: notification.isRead ? Colors.grey[200]! : Colors.blue[100]!,
        ),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _getNotificationColor(notification.type),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getNotificationIcon(notification.type),
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: notification.isRead
                ? FontWeight.normal
                : FontWeight.bold,
            fontSize: 14,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.message,
              style: const TextStyle(fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              _formatTimeAgo(notification.createdAt),
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: !notification.isRead
            ? Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              )
            : null,
        onTap: () => _handleNotificationTap(notification, context),
      ),
    );
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.userRegistration:
        return Colors.orange;
      case NotificationType.farmRegistration:
        return Colors.green;
      case NotificationType.scanActivity:
        return Colors.blue;
      case NotificationType.systemAlert:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.userRegistration:
        return Icons.person_add;
      case NotificationType.farmRegistration:
        return Icons.agriculture;
      case NotificationType.scanActivity:
        return Icons.camera_alt;
      case NotificationType.systemAlert:
        return Icons.warning;
      default:
        return Icons.notifications;
    }
  }

  String _formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';

    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 400,
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.notifications, color: Colors.blue),
                  const SizedBox(width: 8),
                  const Text(
                    'Notifications',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const Spacer(),
                  if (_unreadCount > 0)
                    TextButton(
                      onPressed: _markAllAsRead,
                      child: const Text(
                        'Mark all as read',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                ],
              ),
            ),

            // Notifications List
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _notifications.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications_none,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No notifications',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _notifications.length,
                      itemBuilder: (context, index) {
                        return _buildNotificationItem(_notifications[index]);
                      },
                    ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                border: Border(top: BorderSide(color: Colors.grey[300]!)),
              ),
              child: Row(
                children: [
                  Text(
                    '$_unreadCount unread',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
