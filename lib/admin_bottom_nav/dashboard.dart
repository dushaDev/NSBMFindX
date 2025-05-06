import 'package:find_x/res/charts/lost_found_week.dart';
import 'package:find_x/res/items/build_shimmer_loading.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../navigation_provider.dart';
import '../firebase/auth_service.dart';
import '../firebase/fire_store_service.dart';
import '../firebase/models/user_m.dart';
import '../found_post.dart';
import '../lost_post.dart';
import '../res/read_date.dart';
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
  int _lostFoundCount = 0;
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
                      //sample profile route here.
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
              body: RefreshIndicator(
                onRefresh: () async {
                  setState(() {});
                },
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder(
                            future:
                                _fireStoreService.getTodayLostAndFoundItemsCount(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                        child: _buildReportCard(
                                            'Today Lost Reports',
                                            '0',
                                            '...',
                                            Icons.report,
                                            'assets/images/communication.png',
                                            colorScheme,
                                            () => LostPost())),
                                    SizedBox(width: 5),
                                    Expanded(
                                        child: _buildReportCard(
                                            'Today Found Reports',
                                            '0',
                                            '...',
                                            Icons.person_search,
                                            'assets/images/searching.png',
                                            colorScheme,
                                            () =>
                                                LostPost())), //There should be a FoundPost page
                                  ],
                                );
                              } else if (snapshot.hasData) {
                                Map<String, int> _lostFoundCountMap =
                                    snapshot.data as Map<String, int>;
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                        child: _buildReportCard(
                                            'Today Lost Reports',
                                            '${_lostFoundCountMap['lostCount']!}',
                                            '${_getPercentage(_lostFoundCountMap['lostCount']!, _lostFoundCountMap['wholeCount']!)}%',
                                            Icons.report,
                                            'assets/images/communication.png',
                                            colorScheme,
                                            () => LostPost())),
                                    SizedBox(width: 5),
                                    Expanded(
                                        child: _buildReportCard(
                                            'Today Found Reports',
                                            '${_lostFoundCountMap['foundCount']!}',
                                            '${_getPercentage(_lostFoundCountMap['foundCount']!, _lostFoundCountMap['wholeCount']!)}%',
                                            Icons.person_search,
                                            'assets/images/searching.png',
                                            colorScheme,
                                            () =>
                                                LostPost())), //There should be a FoundPost page
                                  ],
                                );
                              } else {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                        child: _buildReportCard(
                                            'Today Lost Reports',
                                            '-',
                                            'No data',
                                            Icons.report,
                                            'assets/images/communication.png',
                                            colorScheme,
                                            () => LostPost())),
                                    SizedBox(width: 5),
                                    Expanded(
                                        child: _buildReportCard(
                                            'Today Found Reports',
                                            '-',
                                            'No data',
                                            Icons.person_search,
                                            'assets/images/searching.png',
                                            colorScheme,
                                            () =>
                                                LostPost())), //There should be a FoundPost page
                                  ],
                                );
                              }
                            }),
                        SizedBox(height: 10),
                        Column(children: [
                          //pending verifications
                          FutureBuilder(
                            future: _fireStoreService
                                .getUsersNotApprovedWithLimit(5),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return _showEmptyCard(
                                    'error: ${snapshot.error}', colorScheme);
                              } else if (snapshot.hasData) {
                                List<UserM>? usersNotApproved = snapshot.data;

                                if (usersNotApproved == null ||
                                    usersNotApproved.isEmpty) {
                                  return _showEmptyCard(
                                      'No new pending users', colorScheme);
                                }

                                // Build the UI with the list of users not approved
                                return _buildPendingVerificationSection(
                                    'Pending Verifications',
                                    colorScheme,
                                    usersNotApproved, () {
                                  // Navigate to the Users page on bottom navigation bar
                                  Provider.of<NavigationProvider>(context,
                                          listen: false)
                                      .navigateTo(1,
                                          data:
                                              'Pending'); // 1 is Users page with selected Pending option
                                });
                              } else {
                                return _showEmptyCard(
                                    'Data not found', colorScheme);
                              }
                            },
                          ),
                          SizedBox(height: 10),
                          FutureBuilder(
                              future: _fireStoreService.getPostedTimes(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(
                                      child: Text('error: ${snapshot.error}'));
                                } else if (snapshot.hasData) {
                                  int yAxisMax = 4;
                                  Map<String, List<String>>? postedTimes =
                                      snapshot.data;

                                  List<int> foundCountData =
                                      _countDatesInLast7Days(
                                          postedTimes!['found']!);
                                  List<int> lostCountData =
                                      _countDatesInLast7Days(
                                          postedTimes['lost']!);

                                  // Generate found items data with loop
                                  final foundItemsData =
                                      List.generate(7, (index) {
                                    yAxisMax <= foundCountData[index]
                                        ? yAxisMax = foundCountData[index]
                                        : null;
                                    return FlSpot(
                                      (index + 1)
                                          .toDouble(), // Day number (1-7)
                                      foundCountData[index]
                                          .toDouble(), // Count value
                                    );
                                  });

                                  // Generate lost items data with loop
                                  final lostItemsData =
                                      List.generate(7, (index) {
                                    yAxisMax <= lostCountData[index]
                                        ? yAxisMax = lostCountData[index]
                                        : null;
                                    return FlSpot(
                                      (index + 1)
                                          .toDouble(), // Day number (1-7)
                                      lostCountData[index]
                                          .toDouble(), // Count value
                                    );
                                  });
                                  return _buildLostFoundWeek(
                                      'Last Week Chart (Count/Date)',
                                      colorScheme,
                                      lostItemsData,
                                      foundItemsData,
                                      yAxisMax + 1);
                                } else {
                                  return _showEmptyCard(
                                      'No data to show', colorScheme);
                                }
                              }),
                          SizedBox(height: 10),
                          FutureBuilder(
                              //recent updates
                              future: _fireStoreService
                                  .getLostAndFoundItemsWithLimit(3),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return _showEmptyCard(
                                      'error: ${snapshot.error}', colorScheme);
                                } else if (snapshot.hasData) {
                                  List? allItemsList = snapshot.data;
                                  final List<Map<String, dynamic>> finalList =
                                      [];
                                  for (var item in allItemsList!) {
                                    finalList.add(item.toFirestore());
                                  }

                                  return _buildUpdatesSection(
                                      'Updates', colorScheme, finalList, () {
                                    // Navigate to the Posts page on bottom navigation bar
                                    Provider.of<NavigationProvider>(context,
                                            listen: false)
                                        .navigateTo(
                                      2,
                                    ); // 2 is Posts page without any data for now
                                  });
                                } else {
                                  return _showEmptyCard(
                                      'No new updates', colorScheme);
                                }
                              }),
                        ]),
                        SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return _showEmptyCard('Data not found', colorScheme);
          }
        });
  }

  Widget _buildReportCard(
      String title,
      String count,
      String pres,
      IconData icon,
      String image,
      ColorScheme colorScheme,
      Widget Function() myPageHere) {
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(title,
                    style: TextStyle(
                        color: colorScheme.onSurface,
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
                                color: colorScheme.onSurface,
                                fontSize: FontProfile.large,
                                fontWeight: FontWeight.bold)),
                        Text(pres,
                            style: TextStyle(
                                color: colorScheme.onSurface,
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

  Widget _buildUpdatesSection(String title, ColorScheme colorScheme,
      List<Map<String, dynamic>> items, VoidCallback onPressed) {
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
                  onPressed: onPressed,
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

  Widget _buildLostFoundWeek(String title, ColorScheme colorScheme,
      List<FlSpot> lostItemsData, List<FlSpot> foundItemsData, int yAxisMax) {
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
            LostFoundWeek(
                foundItemsColor: colorScheme.primary,
                lostItemsColor: colorScheme.secondary,
                lostItemsData: lostItemsData,
                foundItemsData: foundItemsData,
                yAxisMax: yAxisMax)
          ],
        ),
      ),
    );
  }

  Widget _buildPendingVerificationSection(String title, ColorScheme colorScheme,
      List<UserM> items, VoidCallback onPressed) {
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
                  onPressed: onPressed,
                  child: Text('View All',
                      style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: FontProfile.medium,
                          fontWeight: FontWeight.normal)),
                )
              ],
            ),
            SizedBox(height: 5),
            Container(
              height: 140,
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
                          width: 45,
                          height: 20,
                          padding:
                              EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                          decoration: BoxDecoration(
                            color: item.role == 'student'
                                ? colorScheme.primary
                                : colorScheme.secondary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Text(item.role,
                              style: TextStyle(color: colorScheme.onPrimary)),
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

  int _getPercentage(int count, int total) {
    if (total == 0) return 0;
    return ((count / total) * 100).round();
  }
}
