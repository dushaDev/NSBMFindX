import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String _title = 'Dashboard';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
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
        body: Center(
          child: Text(
            'Dashboard',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
        ));
  }
}
