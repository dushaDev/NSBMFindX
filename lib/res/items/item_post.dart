import 'package:find_x/firebase/models/lost_found_unified.dart';
import 'package:find_x/res/font_profile.dart';
import 'package:flutter/material.dart';

import '../../post_details.dart';
import '../read_date.dart';

class ItemPost extends StatelessWidget {
  final LostFoundUnified item;
  final ColorScheme colorScheme;

  const ItemPost({
    super.key,
    required this.item,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    ReadDate _readDate = ReadDate();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostDetails(
                    itemId: item.id, // Your LostItem or FoundItem object
                    isFoundItem: item.type == 'lost'
                        ? false
                        : true, // true for FoundItem, false for LostItem
                  ),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Post Type Badge
                Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: 38,
                      height: 18,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 1, vertical: 1),
                      decoration: BoxDecoration(
                        color: item.type == 'found'
                            ? colorScheme.primary
                            : colorScheme.secondary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Text(
                        item.type,
                        style: TextStyle(
                          color: colorScheme.onPrimary,
                          fontSize: FontProfile.extraSmall,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    if (item.isCompleted)
                      Icon(
                        Icons.check_circle,
                        color: colorScheme.primary,
                        size: 20,
                      ),
                    const SizedBox(width: 8),
                    // Title
                    Text(
                      item.itemName,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: FontProfile.medium,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // Description
                Text(
                  item.description,
                  style: TextStyle(
                      fontSize: FontProfile.small,
                      color: colorScheme.onSurfaceVariant,
                      overflow: TextOverflow.ellipsis),
                ),
                const SizedBox(height: 8),

                // Footer with time and user
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'by ${item.userName ?? 'Anonymous'}',
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: FontProfile.extraSmall,
                      ),
                    ),
                    Text(
                      '${_readDate.getDuration(item.postedTime)} ago',
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
    );
  }
}
