import 'package:flutter/material.dart';

class AdminBottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const AdminBottomNavigation({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      child: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onItemSelected,
        type: BottomNavigationBarType.fixed,
        selectedItemColor:
            Theme.of(context).colorScheme.primary, // Selected item color
        unselectedItemColor: Theme.of(context)
            .colorScheme
            .onSurfaceVariant, // Unselected item color
        backgroundColor: Theme.of(context)
            .colorScheme
            .surfaceContainerHigh, // Background color
        iconSize: 32.0,
        selectedFontSize: 14.0,
        unselectedFontSize: 12.0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            activeIcon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_rounded),
            activeIcon: Icon(Icons.people_rounded),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_rounded),
            activeIcon: Icon(Icons.article_rounded),
            label: 'Posts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_rounded),
            activeIcon: Icon(Icons.search_rounded),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.notifications_rounded,
            ),
            activeIcon: Icon(Icons.notifications_rounded),
            label: 'Notifications',
          ),
        ],
      ),
    );
  }
}
