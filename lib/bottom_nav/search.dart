import 'dart:async';

import 'package:flutter/material.dart';
import 'package:find_x/res/items/item_user.dart';
import 'package:find_x/res/items/item_post.dart';

import '../firebase/fire_store_service.dart';
import '../res/font_profile.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final FireStoreService _firestoreService = FireStoreService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;
  Timer? _debounceTimer;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          style: TextStyle(color: colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: 'Search users, lost & found items...',
            hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
            border: InputBorder.none,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: _clearSearch,
                  )
                : null,
          ),
          onChanged: (value) {
            _debounceTimer?.cancel();
            _debounceTimer = Timer(const Duration(milliseconds: 700), () {
              if (mounted) {
                setState(() {
                  _searchQuery = value.trim().toLowerCase();
                  _isSearching = value.isNotEmpty;
                });
              }
            });
          },
        ),
      ),
      body: _buildSearchResults(colorScheme),
    );
  }

  Widget _buildSearchResults(ColorScheme colorScheme) {
    if (!_isSearching) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 48, color: colorScheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text(
              'Search for users or items',
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      );
    }

    return FutureBuilder<Map<String, List<dynamic>>>(
      future: _firestoreService.searchAllCategories(_searchQuery),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline,
                    size: 48, color: colorScheme.secondary),
                const SizedBox(height: 16),
                Text(
                  'Search failed: ${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
                TextButton(
                  onPressed: _retrySearch,
                  child: Text(
                    'Retry',
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                  ),
                ),
              ],
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off,
                    size: 48, color: colorScheme.onSurfaceVariant),
                const SizedBox(height: 16),
                const Text('No results found'),
                const SizedBox(height: 8),
                Text(
                  'Try different search terms',
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          );
        } else if (isAllDataEmpty(snapshot.data)) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off,
                    size: 48, color: colorScheme.onSurfaceVariant),
                const SizedBox(height: 16),
                Text(
                  'No results found',
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        } else {
          final results = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.only(bottom: 20),
            children: [
              if (results['users']?.isNotEmpty ?? false) ...[
                _buildSectionHeader('Users', colorScheme),
                ...results['users']!.map((user) => ItemUser(
                      name: user.name,
                      role: user.role,
                      isRestricted: user.isRestricted,
                      isApproved: user.isApproved,
                    )),
              ],
              if (results['items']?.isNotEmpty ?? false) ...[
                _buildSectionHeader('Items', colorScheme),
                ...results['items']!.map((item) => ItemPost(
                      item: item,
                      colorScheme: colorScheme,
                    )),
              ],
            ],
          );
        }
      },
    );
  }

  Widget _buildSectionHeader(String title, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: FontProfile.medium,
          fontWeight: FontWeight.bold,
          color: colorScheme.primary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
      _isSearching = false;
    });
  }

  void _retrySearch() {
    setState(() {});
  }

  bool isAllDataEmpty(Map<String, List<dynamic>>? data) {
    if (data == null) return true;
    return data.values.every((list) => list.isEmpty);
  }
}
