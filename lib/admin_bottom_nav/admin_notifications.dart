import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminNotifications extends StatefulWidget {
  const AdminNotifications({super.key});

  @override
  State<AdminNotifications> createState() => _AdminNotificationsState();
}

class _AdminNotificationsState extends State<AdminNotifications> {
  String _title = 'Notifications';
  @override
  Widget build(BuildContext context) {
    return Scaffold(  appBar: AppBar(
      title: Text(
        '$_title',
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
      ),
      foregroundColor: Theme.of(context).colorScheme.onSurface,
      actions: [
        IconButton(
          onPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => const LostPost()),
            // );
          },
          icon: Icon(
            Icons.manage_accounts_outlined,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
          iconSize: 32.0,
        ),
      ],
    ),
        body:  Center(child: Text('Notifications',style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),));
  }
}
