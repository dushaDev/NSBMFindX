import 'package:find_x/bottom_nav/notifications.dart';
import 'package:flutter/material.dart';
import 'bottom_nav/search.dart';
import 'bottom_nav/home.dart';
import 'bottom_navigation.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int _selectedIndex = 0;
  final _tabs = [const Home(), const Search(), const Notifications()];
  final _label = [
    'Home',
    'Search',
    'Notifications',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigation(
          selectedIndex: _selectedIndex,
          onItemSelected: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          labels: _label,
        ),
        body: _tabs[_selectedIndex]);
  }
}
