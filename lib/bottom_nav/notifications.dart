import 'package:flutter/material.dart';

import '../res/font_profile.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  String _title = 'Notifications';
  bool _isDoNotDisturbEnabled = false;
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('$_title'),
            ],

          ),
          actions: [
            IconButton(
              icon: Icon(
                _isDoNotDisturbEnabled ? Icons.notifications_off_rounded : Icons.notifications_active_rounded,
              ),
              onPressed: _toggleDoNotDisturb,
              tooltip: 'Toggle Do Not Disturb',
            ),
          ],
          centerTitle: true,
          foregroundColor: Theme.of(context).colorScheme.onSurface,
        ),
        body: Center(
          child:Text('Notification page here', style: TextStyle( fontSize: FontProfile.medium,)),

        ));
  }
  void _toggleDoNotDisturb() {
    setState(() {
      _isDoNotDisturbEnabled = !_isDoNotDisturbEnabled;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isDoNotDisturbEnabled
              ? 'Do Not Disturb Enabled'
              : 'Do Not Disturb Disabled',
        ),
        duration: Duration(seconds: 1),
      ),
    );
  }
}
