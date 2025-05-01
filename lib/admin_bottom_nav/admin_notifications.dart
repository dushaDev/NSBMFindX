import 'package:find_x/firebase/models/notification_m.dart';
import 'package:find_x/read_date.dart';
import 'package:flutter/material.dart';
import 'package:find_x/firebase/fire_store_service.dart'; // Assume this exists

class AdminNotifications extends StatefulWidget {
  const AdminNotifications({super.key});

  @override
  State<AdminNotifications> createState() => _AdminNotificationsState();
}

class _AdminNotificationsState extends State<AdminNotifications> {
  final FireStoreService _firestoreService = FireStoreService();
  final ReadDate _readDate = ReadDate();
  late Future<List<NotificationM>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    _notificationsFuture = _firestoreService.getNotificationsById('28232');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshNotifications,
          ),
        ],
      ),
      body: FutureBuilder<List<NotificationM>>(
        future: _notificationsFuture,
        builder: (context, snapshot) {
          // Handle loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Handle error state
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Failed to load notifications'),
                  TextButton(
                    onPressed: _refreshNotifications,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Handle empty state
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off,
                      size: 48,
                      color: colorScheme.onSurface.withAlpha(150)),
                  const SizedBox(height: 16),
                  Text('No notifications yet',
                      style: textTheme.titleMedium),
                  Text('All caught up!',
                      style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant)),
                ],
              ),
            );
          }

          // Build notifications list
          final notifications = snapshot.data!;
          return RefreshIndicator(
            onRefresh: _refreshNotifications,
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 24),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return _buildNotificationCard(
                  notification,
                  colorScheme,
                  textTheme,
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationCard(
      NotificationM notification,
      ColorScheme colorScheme,
      TextTheme textTheme,
      ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outline.withAlpha(100),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _getNotificationColor(notification.type, colorScheme),
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
          style: textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.message,
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Text(
              _readDate.getDateStringToDisplay(notification.postedTime),
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        trailing: !notification.isRead
            ? Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            shape: BoxShape.circle,
          ),
        )
            : null,
        onTap: () => _handleNotificationTap(notification),
      ),
    );
  }

  Future<void> _refreshNotifications() async {
    setState(() {
      _notificationsFuture = _firestoreService.getNotificationsById('28232');
    });
  }

  void _handleNotificationTap(NotificationM notification) {
    // Handle notification tap based on type
    switch (notification.type) {
      case 'new_user':
      // Navigate to user profile
        break;
      case 'report':
      // Navigate to reported item
        break;
      case 'system':
      // Show system alert
        break;
    }
  }

  Color _getNotificationColor(String type, ColorScheme colorScheme) {
    switch (type) {
      case 'alert':
        return colorScheme.error;
      case 'warning':
        return colorScheme.tertiary;
      case 'info':
      default:
        return colorScheme.primary;
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'new_user':
        return Icons.person_add;
      case 'report':
        return Icons.flag;
      case 'system':
        return Icons.settings;
      default:
        return Icons.notifications;
    }
  }
}