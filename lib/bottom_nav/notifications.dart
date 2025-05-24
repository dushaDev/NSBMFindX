import 'package:find_x/firebase/auth_service.dart';
import 'package:find_x/firebase/models/notification_m.dart';
import 'package:find_x/res/font_profile.dart';
import 'package:find_x/res/items/item_notification.dart';
import 'package:flutter/material.dart';
import 'package:find_x/firebase/fire_store_service.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final FireStoreService _firestoreService = FireStoreService();
  final AuthService _authService = AuthService();

  late Future<List<NotificationM>> _notificationsFuture;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();

    _notificationsFuture = _loadNotificationsForUser();
  }

  Future<List<NotificationM>> _loadNotificationsForUser() async {
    try {
      _currentUserId = await _authService.getUserId();
      if (_currentUserId != null && _currentUserId!.isNotEmpty) {
        print("Fetching notifications for user ID: $_currentUserId");
        return await _firestoreService.getNotificationsById(_currentUserId!);
      } else {
        print("Warning: User ID is null or empty. Cannot fetch notifications.");
        return [];
      }
    } catch (e) {
      print("Error loading notifications: $e");

      throw Exception("Failed to load notifications: $e");
    }
  }

  Future<void> _refreshNotifications() async {
    setState(() {
      _notificationsFuture = _loadNotificationsForUser();
    });
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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Failed to load notifications.',
                      style: textTheme.bodyLarge
                          ?.copyWith(color: colorScheme.error)),
                  Text('${snapshot.error}',
                      style: textTheme.bodySmall
                          ?.copyWith(color: colorScheme.error.withAlpha(200))),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: _refreshNotifications,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off,
                      size: 48, color: colorScheme.onSurface.withAlpha(150)),
                  const SizedBox(height: 16),
                  Text('No notifications yet',
                      style: TextStyle(
                          fontSize: FontProfile.small,
                          color: colorScheme.onSurfaceVariant)),
                  Text('All caught up!',
                      style: TextStyle(
                          fontSize: FontProfile.small,
                          color: colorScheme.onSurfaceVariant)),
                ],
              ),
            );
          }

          final notifications = snapshot.data!;
          return RefreshIndicator(
            onRefresh: _refreshNotifications,
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 24),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return ItemNotification(
                  notification: notification,
                  colorScheme: colorScheme,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
