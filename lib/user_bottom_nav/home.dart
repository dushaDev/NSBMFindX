import 'package:find_x/firebase/auth_service.dart';
import 'package:find_x/firebase/fire_store_service.dart';
import 'package:find_x/found_post.dart';
import 'package:find_x/lost_post.dart';
import 'package:find_x/res/read_date.dart';
import 'package:find_x/res/font_profile.dart';
import 'package:find_x/user_profile_settings.dart';
import 'package:find_x/view_posts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../firebase/models/found_item.dart';
import '../firebase/models/lost_item.dart';
import '../navigation_provider.dart';
import '../res/items/build_shimmer_loading.dart';
import '../res/widgets/build_updates_section.dart';

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
                          builder: (context) => UserProfileSettings(
                            userId: _getId['id']!,
                            itemType: false,
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
                                  'assets/images/communication.png',
                                  () => LostPost())),
                          SizedBox(width: 5),
                          Expanded(
                              child: _buildReportCard(
                                  'Found Report',
                                  colorScheme,
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
                              } else if (snapshot.data!.isEmpty) {
                                return _showEmptyCard('No data to show', colorScheme);
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

                                return BuildUpdatesSection(
                                  title: 'Updates',
                                  colorScheme: colorScheme,
                                  readDate: _readDate,
                                  items: finalList,
                                  onPressed: () {
                                    // Navigate to the Posts page on bottom navigation bar
                                    Provider.of<NavigationProvider>(context,
                                            listen: false)
                                        .navigateTo(
                                      1,
                                    ); // 1 is Posts page without any data for now // 1 in the user bottom nav bar

                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => ViewPosts(
                                    //       userId: '',
                                    //       title: 'Updates',
                                    //     ),
                                    //   ),
                                    // );
                                  },
                                );
                              } else {
                                return _showEmptyCard(
                                    'Data not found', colorScheme);
                              }
                            }),
                        SizedBox(height: 10),
                        FutureBuilder(
                            future: _fireStoreService
                                .getLostAndFoundItemsByIdWithLimit(
                                    _getId['id']!, 7),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('error: ${snapshot.error}'));
                              } else if (snapshot.data!.isEmpty) {
                                return _showEmptyCard('No data to show', colorScheme);
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

                                return BuildUpdatesSection(
                                  title: 'Your history',
                                  colorScheme: colorScheme,
                                  readDate: _readDate,
                                  items: finalList,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ViewPosts(
                                          userId: _getId['id']!,
                                          title: 'History',
                                        ),
                                      ),
                                    );
                                  },
                                );
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

  Widget _buildReportCard(String title, ColorScheme colorScheme,
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
                height: 100.0,
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
