import 'package:find_x/res/charts/lost_found_week.dart';
import 'package:find_x/res/items/build_shimmer_loading.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../firebase/auth_service.dart';
import '../firebase/fire_store_service.dart';
import '../firebase/models/found_item.dart';
import '../firebase/models/lost_item.dart';
import '../firebase/models/user_m.dart';
import '../found_post.dart';
import '../lost_post.dart';
import '../read_date.dart';
import '../res/font_profile.dart';
import '../user_profile.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  FireStoreService _fireStoreService = FireStoreService();
  AuthService _authService = AuthService();
  ReadDate _readDate = ReadDate();
  String _title = 'Dashboard';
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getIdName(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return BuildShimmerLoading();
          } else if (snapshot.hasError) {
            return Center(child: Text('error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            // _title = '${_readDate.getWishStatement()}, ${_getId['name']}!';
            return Scaffold(
              extendBody: true,
              appBar: AppBar(
                title: Text(
                  '$_title',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                foregroundColor: Theme.of(context).colorScheme.onSurface,
                actions: [
                  IconButton(
                    onPressed: () {
                      //sample profile route here.
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserProfile(
                            name: 'gdmBeligala',
                            role: 'Student',
                            isApproved: true,
                            isRestricted: false,
                            joinDate: DateTime(2024, 1, 15),
                            reportedItemsCount: 7,
                            email: 'john@example.com',
                            phone: '+1234567890',
                          ),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.manage_accounts_outlined,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
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
                                  'Today Lost Reports',
                                  '387',
                                  '45%',
                                  Icons.report,
                                  'assets/images/communication.png',
                                  () => LostPost())),
                          SizedBox(width: 5),
                          Expanded(
                              child: _buildReportCard(
                                  'Today Found Reports',
                                  '314',
                                  '38%',
                                  Icons.person_search,
                                  'assets/images/searching.png',
                                  () =>
                                      FoundPost())), //There should be a FoundPost page
                        ],
                      ),
                      SizedBox(height: 10),
                      Column(children: [
                        //pending verifications
                        FutureBuilder(
                          future:
                              _fireStoreService.getUsersNotApprovedWithLimit(5),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return _showEmptyCard('error: ${snapshot.error}');
                            } else if (snapshot.hasData) {
                              List<UserM>? usersNotApproved = snapshot.data;

                              if (usersNotApproved == null ||
                                  usersNotApproved.isEmpty) {
                                return _showEmptyCard('No new pending users');
                              }

                              // Build the UI with the list of users not approved
                              return _buildPendingVerificationSection(
                                  'Pending Verifications', usersNotApproved);
                            } else {
                              return _showEmptyCard('Data not found');
                            }
                          },
                        ),
                        SizedBox(height: 10),
                        FutureBuilder(
                            //recent updates
                            future: _fireStoreService
                                .getLostAndFoundItemsWithLimit(7),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return _showEmptyCard(
                                    'error: ${snapshot.error}');
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
                                    'Updates', finalList);
                              } else {
                                return _showEmptyCard('No new updates');
                              }
                            }),
                      ]),
                      SizedBox(height: 10),
                      FutureBuilder(
                          future: _fireStoreService.getPostedTimes(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('error: ${snapshot.error}'));
                            } else if (snapshot.hasData) {
                              int yAxisMax = 4;
                              Map<String, List<String>>? postedTimes =
                                  snapshot.data;

                              List<int> foundCountData = _countDatesInLast7Days(
                                  postedTimes!['found']!);
                              List<int> lostCountData =
                                  _countDatesInLast7Days(postedTimes['lost']!);

                              // Generate found items data with loop
                              final foundItemsData = List.generate(7, (index) {
                                yAxisMax <= foundCountData[index]
                                    ? yAxisMax = foundCountData[index]
                                    : null;
                                return FlSpot(
                                  (index + 1).toDouble(), // Day number (1-7)
                                  foundCountData[index]
                                      .toDouble(), // Count value
                                );
                              });

                              // Generate lost items data with loop
                              final lostItemsData = List.generate(7, (index) {
                                yAxisMax <= lostCountData[index]
                                    ? yAxisMax = lostCountData[index]
                                    : null;
                                return FlSpot(
                                  (index + 1).toDouble(), // Day number (1-7)
                                  lostCountData[index]
                                      .toDouble(), // Count value
                                );
                              });
                              return _buildLostFoundMonth(
                                  'Last Week Chart (Count/Date)',
                                  lostItemsData,
                                  foundItemsData,
                                  yAxisMax + 1);
                            } else {
                              return _showEmptyCard('No data to show');
                            }
                          }),
                      SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return _showEmptyCard('Data not found');
          }
        });
  }

  Widget _buildReportCard(String title, String count, String pres,
      IconData icon, String image, Widget Function() myPageHere) {
    return Card(
        color: Theme.of(context).colorScheme.surfaceContainer,
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(title,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: FontProfile.medium,
                        fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(count,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: FontProfile.large,
                                fontWeight: FontWeight.bold)),
                        Text(pres,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: FontProfile.medium,
                                fontWeight: FontWeight.normal)),
                      ],
                    ),
                  ),
                  Image.asset(
                    image,
                    height: 80.0,
                    fit: BoxFit.fitHeight,
                    scale: 1,
                    alignment: Alignment.center,
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _buildUpdatesSection(String title, List<Map<String, dynamic>> items) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainer,
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
                        color: Theme.of(context).colorScheme.onSurface,
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
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                        tileColor:
                            Theme.of(context).colorScheme.surfaceContainer,
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
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Text(item['type'] ? 'found' : 'lost',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary)),
                        ),
                        title: Text(item['itemName']!,
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        subtitle: Text(
                          item['description']!,
                          style: TextStyle(overflow: TextOverflow.ellipsis),
                        ),
                        trailing: Text(
                            _readDate.getDuration(item['postedTime']),
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant)),
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

  Widget _buildLostFoundMonth(String title, List<FlSpot> lostItemsData,
      List<FlSpot> foundItemsData, int yAxisMax) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainer,
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
                        color: Theme.of(context).colorScheme.onSurface,
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
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: FontProfile.medium,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 5),
            LostFoundWeek(
                foundItemsColor: Theme.of(context).colorScheme.primary,
                lostItemsColor: Theme.of(context).colorScheme.secondary,
                lostItemsData: lostItemsData,
                foundItemsData: foundItemsData,
                yAxisMax: yAxisMax)
          ],
        ),
      ),
    );
  }

  Widget _buildPendingVerificationSection(String title, List<UserM> items) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainer,
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
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: FontProfile.medium,
                        fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {},
                  child: Text('View All',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: FontProfile.medium,
                          fontWeight: FontWeight.normal)),
                )
              ],
            ),
            SizedBox(height: 5),
            Container(
              height: 180,
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Column(
                    children: [
                      ListTile(
                        tileColor:
                            Theme.of(context).colorScheme.surfaceContainer,
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
                          width: 45,
                          height: 20,
                          padding:
                              EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                          decoration: BoxDecoration(
                            color: item.role == 'student'
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Text(item.role,
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary)),
                        ),
                        title: Text(item.displayName,
                            style: TextStyle(fontWeight: FontWeight.normal)),
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

  Widget _showEmptyCard(String message) {
    return Card(
        color: Theme.of(context).colorScheme.surfaceContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Container(
            width: double.infinity,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(message,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
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

// This method counts the number of items in the last 7 days
  List<int> _countDatesInLast7Days(List<String> dateStrings) {
    DateTime now = DateTime.now();
    List<int> last7DaysCounts = List<int>.filled(7, 0); // Initialize with zeros

    List<String> last7Days = [];
    for (int i = 0; i < 7; i++) {
      DateTime date = now.subtract(Duration(days: i));
      String datePart = DateFormat('yyyy/M/d').format(date);
      last7Days.add(datePart);
    }
    last7Days = last7Days.reversed.toList(); // Reverse to have oldest day first

    for (String dateString in dateStrings) {
      String datePart = dateString.split('/').sublist(0, 3).join('/');
      // Check if the date is within the last 7 days
      if (last7Days.contains(datePart)) {
        int index = last7Days.indexOf(datePart);
        last7DaysCounts[index]++;
      }
    }

    return last7DaysCounts;
  }

}
