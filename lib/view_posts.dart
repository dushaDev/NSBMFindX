import 'package:find_x/firebase/models/found_item.dart';
import 'package:find_x/firebase/models/lost_item.dart';
import 'package:flutter/material.dart';
import '../firebase/fire_store_service.dart';
import '../firebase/models/lost_found_unified.dart';
import '../res/items/build_shimmer_loading.dart';
import '../res/items/item_post.dart';

class ViewPosts extends StatefulWidget {
  final String userId; // Replace with actual user ID
  final String title;
  const ViewPosts({super.key, required this.userId, required this.title});

  @override
  State<ViewPosts> createState() => _ViewPostsState();
}

class _ViewPostsState extends State<ViewPosts> {
  final FireStoreService _firestoreService = FireStoreService();
  String _currentFilter = 'All'; // 'All', 'Lost', 'Found', 'Completed'
  final List<String> _filters = ['All', 'Lost', 'Found', 'Completed'];

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.title}',
          style: TextStyle(color: colorScheme.primary),
        ),
        foregroundColor: colorScheme.onSurface,
      ),
      body: Column(
        children: [
          // Filter Bar
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final filter = _filters[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: FilterChip(
                    label: Text(filter),
                    selected: _currentFilter == filter,
                    onSelected: (selected) {
                      setState(() {
                        _currentFilter = filter;
                      });
                    },
                    backgroundColor: colorScheme.surface,
                    selectedColor: colorScheme.primaryContainer,
                    labelStyle: TextStyle(
                      color: _currentFilter == filter
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.onSurface,
                    ),
                  ),
                );
              },
            ),
          ),
          // End Filter Bar
          Expanded(
            child: FutureBuilder(
              future: widget.userId == ''
                  ? _firestoreService.getLostAndFoundItems()
                  : _firestoreService.getLostAndFoundItemsById(widget.userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return BuildShimmerLoading();
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  Map<String, List>? data = snapshot.data;
                  List<LostFoundUnified> unifiedItems =
                      combineLostAndFoundItems(
                          data!['userNames'], data['items']);

                  // Apply filters
                  final filteredItems = unifiedItems.where((item) {
                    if (_currentFilter == 'All') return true;
                    if (_currentFilter == 'Lost') return item.type == 'lost';
                    if (_currentFilter == 'Found') return item.type == 'found';
                    if (_currentFilter == 'Completed') {
                      // Assuming you have isCompleted in your unified model
                      return item.isCompleted;
                    }
                    return true;
                  }).toList();

                  return filteredItems.isEmpty
                      ? Center(
                          child: Text(
                            'No ${_currentFilter.toLowerCase()} posts',
                            style:
                                TextStyle(color: colorScheme.onSurfaceVariant),
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.only(bottom: 80.0),
                          itemCount: filteredItems.length,
                          itemBuilder: (context, index) {
                            final item = filteredItems[index];
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
          ),
        ],
      ),
    );
  }

  List<LostFoundUnified> combineLostAndFoundItems(
      List<dynamic>? userNames, List<dynamic>? data) {
    List<LostFoundUnified> lostFoundUnified = [];

    if (data == null || data.isEmpty) return lostFoundUnified;

    int count = 0;
    for (var item in data) {
      String userName = userNames?[count] ?? 'Unknown User';

      if (item is LostItem) {
        lostFoundUnified.add(LostFoundUnified(
          id: item.id,
          userId: item.userId,
          userName: userName,
          itemName: item.itemName,
          description: item.description,
          postedTime: item.postedTime,
          type: 'lost',
          isCompleted: item.isCompleted, // Add this if exists
        ));
      } else if (item is FoundItem) {
        lostFoundUnified.add(LostFoundUnified(
          id: item.id,
          userId: item.userId,
          userName: userName,
          itemName: item.itemName,
          description: item.description,
          postedTime: item.postedTime,
          type: 'found',
          isCompleted: item.isCompleted, // Add this if exists
        ));
      }
      count++;
    }
    return lostFoundUnified;
  }
}
