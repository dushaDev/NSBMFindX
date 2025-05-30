import 'package:find_x/admin_bottom_nav/users.dart';
import 'package:find_x/admin_bottom_navigation.dart';
import 'package:find_x/firebase/auth_service.dart';
import 'package:find_x/user_bottom_nav/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'bottom_nav/notifications.dart';
import 'bottom_nav/posts.dart';
import 'bottom_nav/search.dart';
import 'navigation_provider.dart';
import 'admin_bottom_nav/dashboard.dart';
import 'user_bottom_navigation.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  // int _selectedIndex = 0;
  final _tabs = [
    const Home(),
    const Posts(),
    const Search(),
    const Notifications()
  ];
  Future<String?> _userRole = Future.value('student');
  final _admin_tabs = [
    Dashboard(),
    Users(),
    Posts(),
    Search(),
    Notifications()
  ];
  AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    _authService.getSignedUser();
    ColorScheme colorScheme = Theme.of(context).colorScheme;

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
              return Center(
                child: Text('An error occurred',
                    style: TextStyle(color: colorScheme.onSurface)),
              );
            } else if (snapshot.data == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('User not signed in or User not found',
                        style: TextStyle(color: colorScheme.onSurface)),
                    const SizedBox(height: 20),
                    OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            foregroundColor: colorScheme.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 24)),
                        onPressed: () async {
                          _authService.signOut().whenComplete(() {
                            setState(() {});
                          });
                        },
                        child: Text(' Try Cleaning Cache and Login Again')),
                  ],
                ),
              );
            } else if (snapshot.data == 'admin' || snapshot.data == 'staff') {
              return Stack(children: [
                //navProvider used for manage pages customly when click button on any page.
                _admin_tabs[navProvider.currentIndex],
                Align(
                    alignment: Alignment.bottomCenter,
                    child: AdminBottomNavigation(
                      selectedIndex: navProvider.currentIndex,
                      onItemSelected: (index) => navProvider.navigateTo(index,
                          data:
                              'All'), //true use for indicate if the navigation is from another page.
                      //that 'All' used for display data on Users page.
                    )),
              ]);
            } else if (snapshot.data == 'student') {
              return Stack(children: [
                _tabs[navProvider.currentIndex],
                Align(
                  alignment: Alignment.bottomCenter,
                  child: UserBottomNavigation(
                    selectedIndex: navProvider.currentIndex,
                    onItemSelected: (index) =>
                        navProvider.navigateTo(index, data: 'All'),
                  ),
                ),
              ]);
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('User role not recognized',
                        style: TextStyle(color: colorScheme.onSurface)),
                    const SizedBox(height: 20),
                    OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            foregroundColor: colorScheme.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 24)),
                        onPressed: () async {
                          _authService.signOut().whenComplete(() {
                            setState(() {});
                          });
                        },
                        child: Text(' Try Cleaning Cache and Login Again')),
                  ],
                ),
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
