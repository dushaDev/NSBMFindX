import 'dart:async';

import 'package:find_x/firebase/auth_service.dart';
import 'package:find_x/firebase/fire_store_service.dart';
import 'package:find_x/login.dart';
import 'package:find_x/res/read_date.dart';
import 'package:find_x/res/font_profile.dart';
import 'package:find_x/res/items/build_shimmer_loading.dart';
import 'package:flutter/material.dart';

class UserProfileSettings extends StatefulWidget {
  final String userId;
  final bool itemType; // true for found item, false for lost item

  const UserProfileSettings({
    super.key,
    required this.userId,
    required this.itemType,
  });

  @override
  State<UserProfileSettings> createState() => _UserProfileSettingsState();
}

class _UserProfileSettingsState extends State<UserProfileSettings> {
  FireStoreService _fireStoreService = FireStoreService();
  AuthService _authService = AuthService();
  StreamController<bool> _badgeController = StreamController<bool>.broadcast();
  StreamController<bool> _buttonController = StreamController<bool>.broadcast();
  final _readDate = ReadDate();
  final String _title = 'Profile';

  @override
  Widget build(BuildContext context) {
    final _colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$_title',
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        actions: [
          FutureBuilder(
              future: _getLoggedUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container();
                } else if (snapshot.hasError) {
                  return Center(child: Text('error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  bool isThisUser = false;
                  final userData = snapshot.data!;
                  final userId = userData['userId'];

                  if (userId == widget.userId) {
                    isThisUser = true;
                  }

                  if (isThisUser) {
                    return IconButton(
                      icon: const Icon(Icons.logout_rounded),
                      onPressed: () async {
                        final shouldLogout = await _showLogoutDialog(context);
                        if (shouldLogout == true) {
                          _authService.signOut().whenComplete(() {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (_) => const Login()),
                              (route) => false, // Remove all previous routes
                            );
                            _showSnackBar('Logged out successfully', false);
                          });
                        }
                      },
                    );
                  } else {
                    return Container();
                  }
                } else {
                  return Container();
                }
              })
        ],
      ),
      body: FutureBuilder(
          future: _fireStoreService.getUser(widget.userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return BuildShimmerLoading();
            } else if (snapshot.hasError) {
              return Center(child: Text('error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final mUser = snapshot.data!;

              return FutureBuilder(
                  future: _getLoggedUser(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: Text('Please wait..',
                              style: TextStyle(
                                  fontSize: FontProfile.small,
                                  color: _colorScheme.onSurface)));
                    } else if (snapshot.hasError) {
                      return Center(child: Text('error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      bool isThisUser = false;
                      final userData = snapshot.data!;
                      final userId = userData['userId'];
                      final userRole = userData['userRole'];

                      if (userId == mUser.id) {
                        isThisUser = true;
                      }

                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Profile Header
                            Center(
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 60,
                                    backgroundImage:
                                        AssetImage('assets/images/user.png'),
                                    backgroundColor: Colors.transparent,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    mUser.name,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.normal,
                                      color: _colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        mUser.role,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: _colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      StreamBuilder(
                                          stream: _badgeController.stream,
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              if (snapshot.data == true) {
                                                mUser.isApproved = true;
                                              }
                                              // mUser.isRestricted
                                              //     ? mUser.isRestricted = false
                                              //     : mUser.isRestricted = true;
                                            }

                                            return Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 2),
                                              decoration: BoxDecoration(
                                                color: mUser.isRestricted
                                                    ? _colorScheme.error
                                                    : mUser.isApproved
                                                        ? _colorScheme.primary
                                                        : _colorScheme
                                                            .secondary,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                mUser.isRestricted
                                                    ? 'Restricted'
                                                    : mUser.isApproved
                                                        ? 'Verified'
                                                        : 'Pending',
                                                style: TextStyle(
                                                    color: _colorScheme
                                                        .surfaceContainer),
                                              ),
                                            );
                                          }),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            // User Details Card
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildDetailRow(Icons.email_rounded, 'Email',
                                      mUser.email, context),
                                  _buildDetailRow(
                                    Icons.calendar_month_rounded,
                                    'date',
                                    '${_readDate.getDateStringToDisplay(mUser.joinDate)}, ${_readDate.getTimeStringToDisplay(mUser.joinDate)}',
                                    context,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Action Buttons
                            isThisUser
                                ? Container()
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      userRole == 'admin' && mUser.isApproved
                                          ? SizedBox(
                                              width:
                                                  200, // Match your message button width
                                              child: OutlinedButton(
                                                onPressed: () {
                                                  if (userRole == 'admin' &&
                                                      mUser.isRestricted) {
                                                    _fireStoreService
                                                        .setUserRestriction(
                                                            mUser.id, false);
                                                    mUser.isRestricted = false;
                                                    _badgeController.sink
                                                        .add(true);
                                                    _buttonController.sink
                                                        .add(true);
                                                  } else {
                                                    _fireStoreService
                                                        .setUserRestriction(
                                                            mUser.id, true);
                                                    mUser.isRestricted = true;
                                                    _badgeController.sink
                                                        .add(true);
                                                    _buttonController.sink
                                                        .add(true);
                                                  }
                                                },
                                                child: StreamBuilder(
                                                    stream: _buttonController
                                                        .stream,
                                                    builder:
                                                        (context, snapshot) {
                                                      return Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .admin_panel_settings,
                                                            color: _colorScheme
                                                                .primary,
                                                            size:
                                                                20, // Adjust size to match your design
                                                          ),
                                                          const SizedBox(
                                                              width: 8),
                                                          Text(
                                                            userRole == 'admin' &&
                                                                    mUser
                                                                        .isRestricted
                                                                ? 'Unrestrict'
                                                                : 'Restrict',
                                                            style: TextStyle(
                                                              color:
                                                                  _colorScheme
                                                                      .primary,
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    }),
                                                style: OutlinedButton.styleFrom(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 8,
                                                      horizontal: 16),
                                                  backgroundColor:
                                                      _colorScheme.surface,
                                                  side: BorderSide(
                                                      color:
                                                          _colorScheme.primary),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : userRole == 'admin'
                                              ? SizedBox(
                                                  width:
                                                      200, // Match your message button width
                                                  child: OutlinedButton(
                                                    onPressed: () {
                                                      if (userRole == 'admin') {
                                                        _fireStoreService
                                                            .approveUser(
                                                                mUser.id);
                                                        mUser.isApproved = true;
                                                        _badgeController.sink
                                                            .add(true);
                                                        _buttonController.sink
                                                            .add(true);
                                                      } else {
                                                        null;
                                                      }
                                                    },
                                                    child: StreamBuilder(
                                                        stream:
                                                            _buttonController
                                                                .stream,
                                                        builder: (context,
                                                            snapshot) {
                                                          return Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .admin_panel_settings,
                                                                color:
                                                                    _colorScheme
                                                                        .primary,
                                                                size:
                                                                    20, // Adjust size to match your design
                                                              ),
                                                              const SizedBox(
                                                                  width: 8),
                                                              Text(
                                                                'Approve User',
                                                                style:
                                                                    TextStyle(
                                                                  color: _colorScheme
                                                                      .primary,
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        }),
                                                    style: OutlinedButton
                                                        .styleFrom(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 8,
                                                          horizontal: 16),
                                                      backgroundColor:
                                                          _colorScheme.surface,
                                                      side: BorderSide(
                                                          color: _colorScheme
                                                              .primary),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                      // Modified Message Button
                                      IconButton(
                                        icon: Icon(Icons.message),
                                        color: _colorScheme.primary,
                                        onPressed: () {
                                          // Message functionality
                                        },
                                      ),
                                    ],
                                  ),
                            const SizedBox(height: 24),
                            // Activity Section
                            isThisUser
                                ? Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Recent Activities',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: _colorScheme.onSurface,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      ListTile(
                                        leading: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: _colorScheme.primary
                                                .withAlpha(10),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(Icons.add_box_outlined,
                                              color: _colorScheme.primary),
                                        ),
                                        title: Text('Sample activity ui card',
                                            style: TextStyle(
                                                color: _colorScheme.onSurface)),
                                        subtitle: Text('2 days ago',
                                            style: TextStyle(
                                                color: _colorScheme
                                                    .onSurfaceVariant)),
                                        trailing: Container(
                                          alignment: Alignment.center,
                                          width: 38,
                                          height: 18,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 1, vertical: 1),
                                          decoration: BoxDecoration(
                                            color: widget.itemType
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                            borderRadius:
                                                BorderRadius.circular(2),
                                          ),
                                          child: Text(
                                              widget.itemType
                                                  ? 'found'
                                                  : 'lost',
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary)),
                                        ),
                                      ),
                                      Divider()
                                    ],
                                  )
                                : Container(),
                          ],
                        ),
                      );
                    } else {
                      return Center(child: Text('error: ${snapshot.error}'));
                    }
                  });
            } else {
              return Center(
                child: Text('Data not found',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface)),
              );
            }
          }),
    );
  }

  // Existing helper methods remain unchanged...
  Widget _buildDetailRow(
      IconData icon, String label, String value, BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: colorScheme.primary, size: 32),
          const SizedBox(width: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: FontProfile.medium,
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w100,
            ),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showLogoutDialog(BuildContext context) async {
    final colorScheme = Theme.of(context).colorScheme;

    return await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        title: Row(
          children: [
            Icon(
              Icons.logout_rounded,
              color: colorScheme.secondary,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              'Confirmation',
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: FontProfile.medium,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to sign out?',
          style: TextStyle(
              color: colorScheme.onSurfaceVariant, fontSize: FontProfile.small),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: Text(
              'Cancel',
              style: TextStyle(color: colorScheme.onSurface),
            ),
          ),
          FilledButton.tonal(
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.secondary,
              foregroundColor: colorScheme.onSecondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Log Out'),
          ),
        ],
        actionsAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }

  void _showSnackBar(String msg, bool isError) {
    final _colorScheme = Theme.of(context).colorScheme;
    final snackBar = SnackBar(
      content: Text(msg,
          style: TextStyle(
            color: _colorScheme.onSecondary,
          )),
      duration: const Duration(seconds: 3),
      backgroundColor: isError ? _colorScheme.secondary : _colorScheme.primary,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<Map<String, dynamic>> _getLoggedUser() async {
    final userId = await _authService.getUserId();
    final userRole = await _authService.getUserRole();

    return {
      'userId': userId,
      'userRole': userRole,
    };
  }
}
