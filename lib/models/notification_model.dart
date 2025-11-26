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
      type: NotificationType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => NotificationType.userRegistration,
      ),
    );
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
      'type': type.name,
    };
  }
}

enum NotificationType {
  userRegistration,
  farmRegistration,
  scanActivity,
  systemAlert,
}