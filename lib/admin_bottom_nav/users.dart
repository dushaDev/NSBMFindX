import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  String _title = 'Users';
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
        body:  Center(child: Text('Users',style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),));
  }
}
