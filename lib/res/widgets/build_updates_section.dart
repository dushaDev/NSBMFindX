import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../font_profile.dart';
import '../read_date.dart';

class BuildUpdatesSection extends StatelessWidget {
  final String title;
  final ColorScheme colorScheme;
  final List<Map<String, dynamic>> items;
  final VoidCallback onPressed;
  final ReadDate readDate;

  const BuildUpdatesSection(
      {super.key,
      required this.title,
      required this.colorScheme,
      required this.readDate,
      required this.items,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return _buildUpdatesSection(title, colorScheme, readDate, items, onPressed);
  }

  Widget _buildUpdatesSection(
      String title,
      ColorScheme colorScheme,
      ReadDate readDate,
      List<Map<String, dynamic>> items,
      VoidCallback onPressed) {
    return Card(
      color: colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: FontProfile.medium,
                        fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: onPressed,
                  style: TextButton.styleFrom(
                    splashFactory: NoSplash
                        .splashFactory, // This completely removes the splash effect
                    // Alternatively, you can use:
                    // splashColor: Colors.transparent,
                    // highlightColor: Colors.transparent,
                  ),
                  child: Text(
                    'View All',
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: FontProfile.medium,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 5),
            Container(
              height: 250,
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Column(
                    children: [
                      ListTile(
                        tileColor: colorScheme.surfaceContainer,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 3,
                        ),
                        horizontalTitleGap: 10,
                        isThreeLine: false,
                        minTileHeight: 30,
                        minLeadingWidth: 10,
                        minVerticalPadding: 5,
                        leading: Container(
                          alignment: Alignment.center,
                          width: 38,
                          height: 18,
                          padding:
                              EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                          decoration: BoxDecoration(
                            color: item['type']
                                ? colorScheme.primary
                                : colorScheme.secondary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Text(item['type'] ? 'found' : 'lost',
                              style: TextStyle(color: colorScheme.onPrimary)),
                        ),
                        title: Text(item['itemName']!,
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        subtitle: Text(
                          item['description']!,
                          style: TextStyle(overflow: TextOverflow.ellipsis),
                        ),
                        trailing: Text(readDate.getDuration(item['postedTime']),
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant)),
                      ),
                      Divider(
                        height: 0,
                        thickness: 1,
                        indent: 10.0,
                        endIndent: 5.0,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
