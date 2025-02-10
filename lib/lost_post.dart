import 'package:flutter/material.dart';

class LostPost extends StatefulWidget {
  const LostPost({super.key});

  @override
  State<LostPost> createState() => _LostPostState();
}

class _LostPostState extends State<LostPost> {
  String _title = 'Lost Post';
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('$_title'),
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          actions:[
            IconButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const Settings()),
                  // );
                },
                icon: Icon(Icons.account_circle_outlined,color: Theme.of(context).colorScheme.onSurface,),iconSize: 35.0,),
          ],
        ),
        body: Center(
         child:
            Text('Lost post page here', style: TextStyle(fontSize: 18.0)),
        ));
  }
}
