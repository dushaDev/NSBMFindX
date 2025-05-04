import 'package:find_x/admin/add_user.dart';
import 'package:find_x/firebase/fire_store_service.dart';
import 'package:find_x/res/font_profile.dart';
import 'package:find_x/res/items/build_shimmer_loading.dart';
import 'package:find_x/res/items/item_user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../NavigationProvider.dart';

class Users extends StatefulWidget {
  final String filterText;
  Users({super.key, this.filterText = 'All'});

  @override
  State<Users> createState() => _UsersState(
        currentFilter: filterText,
      );
}

class _UsersState extends State<Users> {
  String _currentFilter;
  _UsersState({
    required String currentFilter,
  }) : _currentFilter = currentFilter;
  String _title = 'Users';
  FireStoreService _fireStoreService = FireStoreService();

  // Filter options
  final List<String> _filters = ['All', 'Approved', 'Pending', 'Restricted'];

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<NavigationProvider>(
        context); // this use for get data from other page

    if(navProvider.pageData != null) {
      _currentFilter =
          navProvider.pageData??'All'; // this use for get data from other page
    }
    navProvider.pageData = null;

    ColorScheme _colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$_title',
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: Column(
        children: [
          // filter bar
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
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    selectedColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    labelStyle: TextStyle(
                      color: _currentFilter == filter
                          ? Theme.of(context).colorScheme.onSurface
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                );
              },
            ),
          ),
          //end filter bar
          Expanded(
            child: FutureBuilder(
              future: _fireStoreService.getUsersWithLimit(20),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return BuildShimmerLoading();
                } else if (snapshot.hasError) {
                  return Center(child: Text('error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final models = snapshot.data!;
                  // Apply filter
                  final filteredModels = models.where((user) {
                    if (_currentFilter == 'All') return true;
                    if (_currentFilter == 'Approved') return user.isApproved;
                    if (_currentFilter == 'Pending')
                      return !user.isApproved && !user.isRestricted;
                    if (_currentFilter == 'Restricted') return user.isRestricted;
                    return true;
                  }).toList();

                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: filteredModels.length < 1
                        ? Center(
                            child: Text(
                              'No $_currentFilter users to show ',
                              style: TextStyle(
                                  fontSize: FontProfile.small,
                                  color: _colorScheme.onSurface),
                            ),
                          )
                        : ListView.builder(
                            itemCount: filteredModels.length,
                            itemBuilder: (context, index) {
                              final uModel = filteredModels[index];
                              return ItemUser(
                                name: uModel.name,
                                role: uModel.role,
                                isApproved: uModel.isApproved,
                                isRestricted: uModel.isRestricted,
                              );
                            },
                          ),
                  );
                } else {
                  return Center(
                    child: Text(
                      'Data not found',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 70.0),
        child: FloatingActionButton(
          onPressed: () {

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddUser(),
              ),
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
