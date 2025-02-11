import 'package:find_x/lost_post.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Map<String, String>> updates = [
    {'status': 'lost', 'item': 'Laptop', 'desc': 'A silver MacBook Pro (2021 model) with a 14-inch display, an Apple logo sticker on the back, and slight scratches on the right corner.', 'time': '2m'},
    {'status': 'lost', 'item': 'ID', 'desc': 'My ID Stolen at the edge canteen', 'time': '1h'},
    {'status': 'found', 'item': 'I phone', 'desc': ' A black iPhone 14 Pro Max with a cracked back cover and no SIM card inside.', 'time': '9h'},
    {'status': 'found', 'item': 'Wallet', 'desc': 'A black leather wallet containing an ID', 'time': '2d'},
    {'status': 'lost', 'item': 'Wallet', 'desc': 'A brown leather wallet with a metal clip', 'time': '2d'},
  ];

  String _title = 'Good morning User!';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('$_title',style: TextStyle(color: Theme.of(context).colorScheme.primary),),
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          actions:[
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LostPost()),
                  );
                },
                icon: Icon(Icons.account_circle_outlined,color: Theme.of(context).colorScheme.secondary,),iconSize: 35.0,),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: _buildReportCard('Lost Report', Icons.report,'assets/images/communication.png')),
                    SizedBox(width: 5),
                    Expanded(child: _buildReportCard('Found Report', Icons.person_search,'assets/images/searching.png')),
                  ],
                ),
                SizedBox(height: 20),
                Column(
                  children: [ _buildUpdatesSection('Updates', updates),
                    SizedBox(height: 10),
                    _buildUpdatesSection('Your history', updates),]

                ),
                SizedBox(height: 80),
              ],
            ),
          ),
        ),

    );
  }
  Widget _buildReportCard(String title, IconData icon, String image) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Image.asset(
            image,
            height: 130.0,
            fit: BoxFit.fitHeight,
            scale: 1,
            alignment: Alignment.center,
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdatesSection(String title, List<Map<String, String>> items) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Container(
              height: 250,
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Column(
                    children: [
                      ListTile(
                        tileColor: Theme.of(context).colorScheme.surfaceContainer,
                        contentPadding: EdgeInsets.symmetric(horizontal: 3,),
                        horizontalTitleGap: 10,
                        isThreeLine: false,
                        minTileHeight: 30,
                        minLeadingWidth: 10,
                        minVerticalPadding: 5,
                        leading: Container(
                          alignment: Alignment.center,
                          width: 40,
                          height: 20,
                          padding: EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                          decoration: BoxDecoration(
                            color: item['status'] == 'lost' ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Text(item['status']!, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
                        ),
                        title: Text(item['item']!, style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(item['desc']!,style: TextStyle(overflow:TextOverflow.ellipsis),),
                        trailing: Text(item['time']!, style: TextStyle(color: Colors.grey)),
                      ),
                      Divider(height: 0, thickness: 1,indent: 10.0,endIndent: 5.0,),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
