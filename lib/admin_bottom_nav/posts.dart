import 'package:find_x/firebase/models/found_item.dart';
import 'package:find_x/firebase/models/lost_item.dart';
import 'package:flutter/material.dart';

import '../firebase/fire_store_service.dart';
import '../firebase/models/lost_found_unified.dart';
import '../res/items/build_shimmer_loading.dart';
import '../res/items/item_post.dart';

class Posts extends StatefulWidget {
  const Posts({super.key});

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  final FireStoreService _firestoreService = FireStoreService();

  String _title = 'Posts';
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$_title',
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: FutureBuilder(
        future: _firestoreService.getLostAndFoundItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return BuildShimmerLoading();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            Map<String, List>? data = snapshot.data;
            List<LostFoundUnified> unifiedItems =
                combineLostAndFoundItems(data!['userNames'],data['items']);

            return ListView.builder(
              itemCount: unifiedItems.length,
              itemBuilder: (context, index) {
                final item = unifiedItems[index];
                return ItemPost(
                  item: item,
                  colorScheme: colorScheme,
                );
              },
            );
          } else {
            return Center(
              child: Text(
                'No posts available',
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
            );
          }
        },
      ),
    );
  }

  List<LostFoundUnified> combineLostAndFoundItems(List<dynamic>? userNames,List<dynamic>? data) {
    List<LostFoundUnified> lostFoundUnified = [];

    if (data == null || data.isEmpty) {
      return lostFoundUnified;
    }

    // Extract LostItem and FoundItem from the data
    int count = 0;
    for (var item in data) {

      String userName = userNames?[count] ?? 'Unknown User';

      if (item is LostItem) {
        // Add LostItem to the unified list
        lostFoundUnified.add(LostFoundUnified(
          id: item.id,
          userId: item.userId,
          userName: userName,
          itemName: item.itemName,
          description: item.description,
          postedTime: item.postedTime,
          type: 'lost',
        ));
      } else if (item is FoundItem) {
        // Add FoundItem to the unified list
        lostFoundUnified.add(LostFoundUnified(
          id: item.id,
          userId: item.userId,
          userName: userName,
          itemName: item.itemName,
          description: item.description,
          postedTime: item.postedTime,
          type: 'found',
        ));
      }
      count++;
    }
    return lostFoundUnified;
  }
}
