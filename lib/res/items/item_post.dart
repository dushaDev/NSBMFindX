import 'package:find_x/firebase/models/lost_found_unified.dart';
import 'package:flutter/material.dart';

import '../../read_date.dart';

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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
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
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Title
                  Text(
                    item.itemName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 4),

              // Description
              Text(
                item.description,
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 8),

              // Footer with time and user
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _readDate.getDuration(item.postedTime),
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    'by ${item.userName ?? 'Anonymous'}',
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
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
