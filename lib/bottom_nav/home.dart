import 'package:find_x/firebase/auth_service.dart';
import 'package:find_x/firebase/fire_store_service.dart';
import 'package:find_x/found_post.dart';
import 'package:find_x/lost_post.dart';
import 'package:find_x/read_date.dart';
import 'package:find_x/res/font_profile.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../firebase/models/found_item.dart';
import '../firebase/models/lost_item.dart';
import '../res/items/build_shimmer_loading.dart';
import '../user_profile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FireStoreService _fireStoreService = FireStoreService();
  AuthService _authService = AuthService();
  ReadDate _readDate = ReadDate();
  String _title = 'Hello!';
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return FutureBuilder(
        future: _getIdName(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return BuildShimmerLoading();
          } else if (snapshot.hasError) {
            return Center(child: Text('error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            Map<String, String?> _getId = snapshot.data as Map<String, String?>;
            _title = '${_readDate.getWishStatement()}, ${_getId['name']}!';
            return Scaffold(
              extendBody: true,
              appBar: AppBar(
                title: Text(
                  '$_title',
                  style: TextStyle(color: colorScheme.primary),
                ),
                foregroundColor: colorScheme.onSurface,
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserProfile(
                            userId: _getId['id']!,
                            myProf: true,
                            item: false,
                          ),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.manage_accounts_outlined,
                      color: colorScheme.onSecondaryContainer,
                    ),
                    iconSize: 32.0,
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: _buildReportCard(
                                  'Lost Report',
                                  colorScheme,
                                  Icons.report,
                                  'assets/images/communication.png',
                                  () => LostPost())),
                          SizedBox(width: 5),
                          Expanded(
                              child: _buildReportCard(
                                  'Found Report',
                                  colorScheme,
                                  Icons.person_search,
                                  'assets/images/searching.png',
                                  () =>
                                      FoundPost())), //There should be a FoundPost page
                        ],
                      ),
                      SizedBox(height: 10),
                      Column(children: [
                        FutureBuilder(
                            future: _fireStoreService
                                .getLostAndFoundItemsWithLimit(4),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('error: ${snapshot.error}'));
                              } else if (snapshot.hasData) {
                                List? allItemsList = snapshot.data;
                                final List<Map<String, dynamic>> finalList = [];
                                for (var item in allItemsList!) {
                                  if (item is LostItem) {
                                    finalList.add(item.toFirestore());
                                  } else if (item is FoundItem) {
                                    finalList.add(item.toFirestore());
                                  }
                                }

                                return _buildUpdatesSection(
                                    'Updates', colorScheme, finalList);
                              } else {
                                return _showEmptyCard(
                                    'Data not found', colorScheme);
                              }
                            }),
                        SizedBox(height: 10),
                        FutureBuilder(
                            future: _fireStoreService.getLostAndFoundItemsById(
                                _getId['id']!, 7),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('error: ${snapshot.error}'));
                              } else if (snapshot.hasData) {
                                List? allItemsList = snapshot.data;
                                final List<Map<String, dynamic>> finalList = [];
                                for (var item in allItemsList!) {
                                  if (item is LostItem) {
                                    finalList.add(item.toFirestore());
                                  } else if (item is FoundItem) {
                                    finalList.add(item.toFirestore());
                                  }
                                }

                                return _buildUpdatesSection(
                                    'Your history', colorScheme, finalList);
                              } else {
                                return _showEmptyCard(
                                    'Data not found', colorScheme);
                              }
                            }),
                      ]),
                      SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return _showEmptyCard('Data not found', colorScheme);
          }
        });
  }

  Widget _buildReportCard(String title, ColorScheme colorScheme, IconData icon,
      String image, Widget Function() myPageHere) {
    return Card(
        color: colorScheme.surfaceContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: InkResponse(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => myPageHere()),
            );
          },
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
                child: Text(title,
                    style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: FontProfile.medium,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ));
  }

  Widget _buildUpdatesSection(
      String title, ColorScheme colorScheme, List<Map<String, dynamic>> items) {
    return Card(
      color: colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: FontProfile.medium,
                        fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    splashFactory: NoSplash
                        .splashFactory, // This completely removes the splash effect
                    // Alternatively, you can use:
                    // splashColor: Colors.transparent,
                    // highlightColor: Colors.transparent,
                  ),
                  child: Text(
                    'View All',
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: FontProfile.medium,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                )
              ],
            ),
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
                        tileColor: colorScheme.surfaceContainer,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 3,
                        ),
                        horizontalTitleGap: 10,
                        isThreeLine: false,
                        minTileHeight: 30,
                        minLeadingWidth: 10,
                        minVerticalPadding: 5,
                        leading: Container(
                          alignment: Alignment.center,
                          width: 38,
                          height: 18,
                          padding:
                              EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                          decoration: BoxDecoration(
                            color: item['type']
                                ? colorScheme.primary
                                : colorScheme.secondary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Text(item['type'] ? 'found' : 'lost',
                              style: TextStyle(color: colorScheme.onPrimary)),
                        ),
                        title: Text(item['itemName']!,
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        subtitle: Text(
                          item['description']!,
                          style: TextStyle(overflow: TextOverflow.ellipsis),
                        ),
                        trailing: Text(
                            _readDate.getDuration(item['postedTime']),
                            style: TextStyle(color: Colors.grey)),
                      ),
                      Divider(
                        height: 0,
                        thickness: 1,
                        indent: 10.0,
                        endIndent: 5.0,
                      ),
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

  Widget _showEmptyCard(String message, ColorScheme colorScheme) {
    return Card(
        color: colorScheme.surfaceContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Container(
            width: double.infinity,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(message,
                    style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: FontProfile.medium,
                        fontWeight: FontWeight.normal)),
              ),
            )));
  }

  Future<Map<String, String?>> _getIdName() async {
    String? id = await _authService.getUserId();
    String? name = await _authService.getUserDisplayName();
    return {'id': id, 'name': name};
  }
}
