import 'package:flutter/material.dart';
class BottomNavigation extends StatelessWidget {
  final int _selectedIndex;
  final List<String> _labels;
  final Function(int) _onItemSelected;

  const BottomNavigation(
      {super.key, required int selectedIndex, required dynamic Function(int) onItemSelected, required List<String> labels}) : _onItemSelected = onItemSelected, _labels = labels, _selectedIndex = selectedIndex;
  @override
  Widget build(BuildContext context) {

    return BottomNavigationBar(

      selectedItemColor: Theme.of(context).colorScheme.primary,
        iconSize: 33.0,
        currentIndex: _selectedIndex,
        onTap: _onItemSelected,
        type: BottomNavigationBarType.fixed,
        items: [
      BottomNavigationBarItem(icon: const Icon(Icons.task_alt), label: _labels[0]),
      BottomNavigationBarItem(icon: const Icon(Icons.search), label: _labels[1]),
          BottomNavigationBarItem(icon: const Icon(Icons.notifications_outlined), label: _labels[2]),
    ]);
  }
}
