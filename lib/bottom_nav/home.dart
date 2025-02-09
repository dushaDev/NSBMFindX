import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _title = 'Good morning User!';
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
            Text('Home page here', style: TextStyle(fontSize: 18.0)),
        ));
  }
}
