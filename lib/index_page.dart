import 'package:find_x/admin_bottom_nav/admin_notifications.dart';
import 'package:find_x/admin_bottom_nav/admin_search.dart';
import 'package:find_x/admin_bottom_nav/posts.dart';
import 'package:find_x/admin_bottom_nav/users.dart';
import 'package:find_x/admin_bottom_navigation.dart';
import 'package:find_x/bottom_nav/notifications.dart';
import 'package:find_x/firebase/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'NavigationProvider.dart';
import 'admin_bottom_nav/dashboard.dart';
import 'bottom_nav/search.dart';
import 'bottom_nav/home.dart';
import 'bottom_navigation.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int _selectedIndex = 0;
  final _tabs = [const Home(), const Search(), const Notifications()];
  Future<String?> _userRole = Future.value('student');
  final _admin_tabs = [
    Dashboard(),
    Users(),
    Posts(),
    AdminSearch(),
    AdminNotifications()
  ];
  AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    _authService.getSignedUser();

    // provider for manage navigation
    // this provider use for manage pages customly when click button on any page.
    // only uses for admin yet.
    final navProvider = Provider.of<NavigationProvider>(context);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: FutureBuilder(
          future: _userRole,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('An error occurred'),
              );
            } else if (snapshot.data == null) {
              return const Center(
                child: Text('User not signed in'),
              );
            } else if (snapshot.data == 'admin' || snapshot.data == 'staff') {
              return Stack(children: [
                //navProvider used for manage pages customly when click button on any page.
                _admin_tabs[navProvider.currentIndex],
                Align(
                    alignment: Alignment.bottomCenter,
                    child: AdminBottomNavigation(
                      selectedIndex: navProvider.currentIndex,
                      onItemSelected: (index) =>
                          navProvider.setCurrentIndex(index),
                    )),
              ]);
            } else if (snapshot.data == 'student') {
              return Stack(children: [
                _tabs[_selectedIndex],
                Align(
                  alignment: Alignment.bottomCenter,
                  child: BottomNavigation(
                    selectedIndex: _selectedIndex,
                    onItemSelected: (int index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                  ),
                ),
              ]);
            } else {
              return const Center(
                child: Text('User role not recognized'),
              );
            }
          },
        ));
  }

  @override
  void initState() {
    super.initState();
    _userRole = _authService.getUserRole();
    // UserSyncService userSyncService =
    //     UserSyncService(_authService, _fireStoreService, _databaseHelper);
    // if (await _databaseHelper.isUsersTableEmpty()) {
    //   await userSyncService.syncUserDataFromFirebase();
    // }
    // _databaseHelper.close();
  }
}
