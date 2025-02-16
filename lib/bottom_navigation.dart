import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final int _selectedIndex;
  final Function(int) _onItemSelected;
  const BottomNavigation(
      {super.key,
        required int selectedIndex,
        required dynamic Function(int) onItemSelected,})
      : _onItemSelected = onItemSelected,
        _selectedIndex = selectedIndex;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withAlpha(80),
            blurRadius: 8.0,
            spreadRadius: 1.0,
            offset: Offset(0, 3),
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      width: MediaQuery.of(context).size.width*0.66,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: NavigationBar(
          elevation: 2.0,
          shadowColor: Theme.of(context).colorScheme.shadow,
          onDestinationSelected: _onItemSelected,
          indicatorColor: Colors.transparent,
          backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
          animationDuration: const Duration(milliseconds: 300),
          height: 30.0,
          selectedIndex: _selectedIndex,
          destinations: [
            Expanded(
              flex: 1,
              child: NavigationDestination(
                tooltip: 'home',
                selectedIcon: Icon(
                  Icons.home_rounded,
                  size: 32.0,
                  color: Theme.of(context).colorScheme.primary,

                ),
                icon: Icon(
                  Icons.home_rounded,
                  size: 32.0,
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(70),
                ),
                label: '',
              ),
            ),
            Expanded(
              flex: 1,
              child: NavigationDestination(
                tooltip: 'search',
                selectedIcon: Icon(
                  Icons.search_rounded,
                  size: 32.0,
                  color: Theme.of(context).colorScheme.primary,
                ),
                icon: Icon(
                  Icons.search_rounded,
                  size: 32.0,
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(70),
                ),
                label: '',
              ),
            ),
            Expanded(
              flex: 1,
              child: NavigationDestination(
                tooltip: 'notifications',
                selectedIcon: Icon(
                  Icons.notifications_rounded,
                  size: 32.0,
                  color: Theme.of(context).colorScheme.primary,
                ),
                icon: Badge(
                  smallSize: 7.0,
                  isLabelVisible: true,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  child: Icon(
                    Icons.notifications_rounded,
                    size: 32.0,
                    color: Theme.of(context).colorScheme.onSurface.withAlpha(70),
                  ),
                ),
                label: '',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
