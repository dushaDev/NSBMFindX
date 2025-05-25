import 'package:flutter/material.dart';
import 'package:find_x/res/font_profile.dart';
import 'package:find_x/firebase/models/notification_m.dart';
import '../../post_details.dart';
import '../read_date.dart';

void _handleNotificationTap(
    NotificationM notification, BuildContext context) async {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PostDetails(
        itemId: notification.matchedItemId,
        isFoundItem: notification.matchedItemType,
      ),
    ),
  );
}

class ItemNotification extends StatelessWidget {
  final NotificationM notification;
  final ColorScheme colorScheme;

  const ItemNotification({
    super.key,
    required this.notification,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    ReadDate _readDate = ReadDate();

    return Container(
      color: notification.read
          ? colorScheme.surface
          : colorScheme.onSurfaceVariant.withAlpha(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: GestureDetector(
              onTap: () => _handleNotificationTap(notification, context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        notification.read
                            ? Icons.notifications_none
                            : Icons.notifications_active,
                        color: notification.read
                            ? colorScheme.onSurfaceVariant.withAlpha(140)
                            : colorScheme.secondary,
                        size: 22,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          notification.notificationType == 'match'
                              ? 'New Match Found!'
                              : 'Important Notification',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: FontProfile.medium,
                            color: colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${notification.message}',
                    style: TextStyle(
                      fontSize: FontProfile.small,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: 38,
                        height: 18,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 1, vertical: 1),
                        decoration: BoxDecoration(
                          color: notification.targetItemType
                              ? colorScheme.primary
                              : colorScheme.secondary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Text(
                          notification.targetItemType ? 'found' : 'lost',
                          style: TextStyle(
                            color: colorScheme.onPrimary,
                            fontSize: FontProfile.extraSmall,
                          ),
                        ),
                      ),
                      Text(
                        '${_readDate.getDuration(notification.timestamp)} ago',
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: FontProfile.extraSmall,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Divider(
            height: 0,
            thickness: 1,
            indent: 10.0,
            endIndent: 5.0,
          ),
        ],
      ),
    );
  }
}
