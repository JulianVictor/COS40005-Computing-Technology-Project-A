import 'package:flutter/material.dart';
import '../widgets/notification_dialog.dart';
import '../services/notification_service.dart';
import '../services/auth_manager.dart';

class AdminHeader extends StatefulWidget {
  final String title;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const AdminHeader({
    super.key,
    required this.title,
    required this.scaffoldKey,
  });

  @override
  State<AdminHeader> createState() => _AdminHeaderState();
}

class _AdminHeaderState extends State<AdminHeader> {
  final NotificationService _notificationService = NotificationService();
  final AuthManager _authManager = AuthManager();
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    _loadUnreadCount();
  }

  Future<void> _loadUnreadCount() async {
    final count = await _notificationService.getUnreadNotificationCount();
    if (mounted) {
      setState(() {
        _unreadCount = count;
      });
    }
  }

  void _showNotifications() {
    showDialog(
      context: context,
      builder: (context) => const NotificationDialog(),
    ).then((_) {
      // Reload count when dialog is closed
      _loadUnreadCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Menu Button for Mobile
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => widget.scaffoldKey.currentState?.openDrawer(),
          ),
          const SizedBox(width: 16),

          // Title
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const Spacer(),

          // Search Bar
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
          ),

          // Notifications - FIXED VERSION
          Container(
            width: 40,
            height: 40,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Bell Icon
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                  onPressed: _showNotifications,
                ),
                
                // Notification Badge - FIXED POSITIONING AND SIZE
                if (_unreadCount > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                        maxWidth: 24,
                      ),
                      child: Text(
                        _unreadCount > 9 ? '9+' : _unreadCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          height: 1.0,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Simple Admin Display
          const SizedBox(width: 16),
          const Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.blue,
                child: Icon(
                  Icons.admin_panel_settings,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Administrator',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'System Admin',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}