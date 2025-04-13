import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

class UserProfile extends StatelessWidget {
  final String name;
  final String role;
  final bool isApproved;
  final bool isRestricted;
  final DateTime joinDate;
  final int reportedItemsCount;
  final String email;
  final String? phone;

  const UserProfile({
    super.key,
    required this.name,
    required this.role,
    required this.isApproved,
    required this.isRestricted,
    required this.joinDate,
    required this.reportedItemsCount,
    required this.email,
    this.phone,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final formattedDate = DateFormat('MMM dd, yyyy').format(joinDate);

    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile', style: TextStyle(color: colorScheme.onPrimary)),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: const NetworkImage(
                      'https://cdn-icons-png.flaticon.com/128/17286/17286792.png',
                    ),
                    backgroundColor: colorScheme.surfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: isRestricted
                          ? colorScheme.errorContainer
                          : isApproved
                          ? colorScheme.primaryContainer
                          : colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isRestricted
                          ? 'Restricted'
                          : isApproved
                          ? 'Verified'
                          : 'Pending',
                      style: TextStyle(
                        color: isRestricted
                            ? colorScheme.onErrorContainer
                            : isApproved
                            ? colorScheme.onPrimaryContainer
                            : colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // User Details Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(Icons.person_outline, 'Role', role, context),
                    _buildDetailRow(Icons.email_outlined, 'Email', email, context),
                    if (phone != null)
                      _buildDetailRow(Icons.phone_outlined, 'Phone', phone!, context),
                    _buildDetailRow(
                      Icons.calendar_today_outlined,
                      'Joined',
                      formattedDate,
                      context,
                    ),
                    _buildDetailRow(
                      Icons.list_alt_outlined,
                      'Reports',
                      '$reportedItemsCount items',
                      context,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: Icon(Icons.chat_outlined, color: colorScheme.primary),
                    label: Text('Message', style: TextStyle(color: colorScheme.primary)),
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: colorScheme.primary),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton.icon(
                    icon: const Icon(Icons.admin_panel_settings_outlined),
                    label: const Text('Manage'),
                    onPressed: () {},
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Activity Section
            Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 1,
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.add_box_outlined, color: colorScheme.primary),
                ),
                title: Text('Reported new item', style: TextStyle(color: colorScheme.onSurface)),
                subtitle: Text('2 days ago', style: TextStyle(color: colorScheme.outline)),
                trailing: Text('Lost', style: TextStyle(color: colorScheme.secondary)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: colorScheme.onSurface.withOpacity(0.6)),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.outline,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}