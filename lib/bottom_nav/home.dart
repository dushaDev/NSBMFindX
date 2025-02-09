import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _title = 'Home';
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
          centerTitle: true,
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const Settings()),
                  // );
                },
                icon: const Icon(Icons.supervised_user_circle_outlined)),
          ],
        ),
        body: Center(
          child: Text('Home page here'),
        ));
  }
}
