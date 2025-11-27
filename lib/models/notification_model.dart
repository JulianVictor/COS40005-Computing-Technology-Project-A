// models/notification_model.dart
class AdminNotification {
  final String id;
  final String title;
  final String message;
  final String userId;
  final String userEmail;
  final DateTime createdAt;
  final bool isRead;
  final NotificationType type;

  AdminNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.userId,
    required this.userEmail,
    required this.createdAt,
    this.isRead = false,
    required this.type,
  });

  factory AdminNotification.fromMap(Map<String, dynamic> map) {
    return AdminNotification(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      message: map['message']?.toString() ?? '',
      userId: map['user_id']?.toString() ?? '',
      userEmail: map['user_email']?.toString() ?? '',
      createdAt: map['created_at'] != null 
          ? DateTime.parse(map['created_at'].toString())
          : DateTime.now(),
      isRead: map['is_read'] as bool? ?? false,
      type: _parseNotificationType(map['type']?.toString() ?? ''),
    );
  }

  static NotificationType _parseNotificationType(String type) {
    switch (type) {
      case 'user_registration':
        return NotificationType.userRegistration;
      case 'farm_registration':
        return NotificationType.farmRegistration;
      case 'scan_activity':
        return NotificationType.scanActivity;
      case 'system_alert':
        return NotificationType.systemAlert;
      default:
        return NotificationType.userRegistration;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'user_id': userId,
      'user_email': userEmail,
      'created_at': createdAt.toIso8601String(),
      'is_read': isRead,
      'type': _convertNotificationTypeToString(type),
    };
  }

  static String _convertNotificationTypeToString(NotificationType type) {
    switch (type) {
      case NotificationType.userRegistration:
        return 'user_registration';
      case NotificationType.farmRegistration:
        return 'farm_registration';
      case NotificationType.scanActivity:
        return 'scan_activity';
      case NotificationType.systemAlert:
        return 'system_alert';
    }
  }
}

enum NotificationType {
  userRegistration,
  farmRegistration,
  scanActivity,
  systemAlert,
}