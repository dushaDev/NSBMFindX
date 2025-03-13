import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminSearch extends StatefulWidget {
  const AdminSearch({super.key});

  @override
  State<AdminSearch> createState() => _AdminSearchState();
}

class _AdminSearchState extends State<AdminSearch> {
  String _title = 'Search';
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
        body:  Center(child: Text('Search',style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),));
  }
}
