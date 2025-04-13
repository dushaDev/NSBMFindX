import 'package:find_x/firebase/fire_store_service.dart';
import 'package:find_x/read_date.dart';
import 'package:find_x/res/font_profile.dart';
import 'package:find_x/res/items/build_shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserProfile extends StatelessWidget {
  final String userId;
  final bool myProf;
  final bool item;

  const UserProfile({
    super.key,
    required this.userId,
    required this.myProf,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final String _title = 'Profile';
    FireStoreService _fireStoreService = FireStoreService();
    final _colorScheme = Theme.of(context).colorScheme;
    final _readDate = ReadDate();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '$_title',
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: FutureBuilder(
          future: _fireStoreService.getUser(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return BuildShimmerLoading();
            } else if (snapshot.hasError) {
              return Center(child: Text('error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final mUser = snapshot.data!;

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
                            radius: 70,
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
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: mUser.isRestricted
                                      ? _colorScheme.error
                                      : mUser.isApproved
                                          ? _colorScheme.primary
                                          : _colorScheme.secondary,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  mUser.isRestricted
                                      ? 'Restricted'
                                      : mUser.isApproved
                                          ? 'Verified'
                                          : 'Pending',
                                  style: TextStyle(
                                      color: _colorScheme.surfaceContainer),
                                ),
                              ),
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
                          _buildDetailRow(
                              Icons.send_rounded, 'Email', mUser.email, context),
                          _buildDetailRow(
                            Icons.calendar_month_rounded,
                            'date',
                            '${_readDate.getDateStringToDisplay(mUser.joinDate)}, ${_readDate.getTimeStringToDisplay(mUser.joinDate)}'
                            ,
                            context,
                          ),
                          // _buildDetailRow(
                          //   Icons.list_alt_rounded,
                          //   'Reports',
                          //   '$reportedItemsCount items',
                          //   context,
                          // ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Action Buttons
                    myProf? Container():
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 200,
                          child: OutlinedButton(
                            onPressed: () {},
                            child: Text('Message'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              backgroundColor: _colorScheme.surface,
                              side: BorderSide(color: _colorScheme.primary),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Activity Section
                    myProf?
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
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
                              color: _colorScheme.primary.withAlpha(10),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.add_box_outlined,
                                color: _colorScheme.primary),
                          ),
                          title: Text('Sample activity ui card',
                              style: TextStyle(color: _colorScheme.onSurface)),
                          subtitle: Text('2 days ago',
                              style:
                              TextStyle(color: _colorScheme.onSurfaceVariant)),
                          trailing: Container(
                            alignment: Alignment.center,
                            width: 38,
                            height: 18,
                            padding:
                            EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                            decoration: BoxDecoration(
                              color: item
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: Text(item ? 'found' : 'lost',
                                style: TextStyle(
                                    color:
                                    Theme.of(context).colorScheme.onPrimary)),
                          ),
                        ),
                        Divider()
                      ],
                    ):Container(),

                  ],
                ),
              );
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
}
