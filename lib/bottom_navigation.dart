import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final int _selectedIndex;
  final List<String> _labels;
  final Function(int) _onItemSelected;

  const BottomNavigation(
      {super.key,
      required int selectedIndex,
      required dynamic Function(int) onItemSelected,
      required List<String> labels})
      : _onItemSelected = onItemSelected,
        _labels = labels,
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
      margin: EdgeInsets.only(top: 5.0, bottom: 10.0, left: 60.0, right: 60.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: NavigationBar(
          shadowColor: Theme.of(context).colorScheme.shadow,
          onDestinationSelected: _onItemSelected,
          indicatorShape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(
                11.0), // Increase radius for a larger shape
            side: BorderSide(
              strokeAlign: BorderSide.strokeAlignOutside,
              color: Theme.of(context).colorScheme.primary, // Optional border
              width: 20.0,
            ),
          ),
          indicatorColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
          animationDuration: const Duration(milliseconds: 300),
          height: 40.0,
          selectedIndex: _selectedIndex,
          destinations: [
            Container(
              margin: EdgeInsets.only(bottom: 2.0),
              child: NavigationDestination(
                tooltip: _labels[_selectedIndex],
                selectedIcon: Icon(
                  Icons.home_rounded,
                  size: 32.0,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                icon: Icon(
                  Icons.home_rounded,
                  size: 32.0,
                  color: Theme.of(context).colorScheme.primary,
                ),
                label: '',
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 2.0),
              child: NavigationDestination(
                tooltip: _labels[_selectedIndex],
                selectedIcon: Icon(
                  Icons.search_rounded,
                  size: 32.0,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                icon: Icon(
                  Icons.search_rounded,
                  size: 32.0,
                  color: Theme.of(context).colorScheme.primary,
                ),
                label: '',
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 2.0),
              child: NavigationDestination(
                tooltip: _labels[_selectedIndex],
                selectedIcon: Icon(
                  Icons.notifications_rounded,
                  size: 32.0,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                icon: Badge(
                  smallSize: 8.0,
                  isLabelVisible: true,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  child: Icon(
                    Icons.notifications_rounded,
                    size: 32.0,
                    color: Theme.of(context).colorScheme.primary,
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
