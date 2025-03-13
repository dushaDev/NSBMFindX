import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Posts extends StatefulWidget {
  const Posts({super.key});

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  String _title = 'Posts';
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
        body:  Center(child: Text('Posts',style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),));
  }
}
