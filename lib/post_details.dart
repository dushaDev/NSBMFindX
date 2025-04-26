import 'package:find_x/res/font_profile.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'firebase/fire_store_service.dart';

class PostDetails extends StatelessWidget {
  final String id;
  final bool isFoundItem;

  const PostDetails({super.key, required this.id, required this.isFoundItem});

  @override
  Widget build(BuildContext context) {
    final FireStoreService _firestoreService = FireStoreService();
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),
      body: FutureBuilder(
        future: isFoundItem
            ? _firestoreService.getFoundItem(id)
            : _firestoreService.getLostItem(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Item not found'));
          }

          final post = snapshot.data!;
          return _buildPostContent(context, post);
        },
      ),
    );
  }

  Widget _buildPostContent(BuildContext context, dynamic post) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Gallery
          _buildImageGallery(post.images),
          const SizedBox(height: 20),

          // Status Chip
          Chip(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            backgroundColor: isFoundItem
                ? colorScheme.primary.withAlpha(170)
                : colorScheme.secondary.withAlpha(170),
            label: Text(
              isFoundItem ? 'Found Item' : 'Lost Item',
              style: TextStyle(
                fontSize: FontProfile.small,
                color:
                    colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Item Name
          Text(
            post.itemName,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          // Time and Location
          _buildDetailRow(
            icon: Icons.access_time,
            text: isFoundItem
                ? 'Found: ${_formatDateTime(post.foundTime)}'
                : 'Lost: ${_formatDateTime(post.lostTime)}',
          ),
          _buildDetailRow(
            icon: Icons.location_pin,
            text: isFoundItem
                ? 'Current location: ${post.currentLocation}'
                : 'Last seen: ${post.lastKnownLocation}',
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            'Description',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            post.description,
            style: textTheme.bodyLarge,
          ),
          const SizedBox(height: 20),

          // Contact Section
          _buildContactSection(post.contactNumber, colorScheme),
        ],
      ),
    );
  }

  Widget _buildDetailRow({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _buildContactSection(String contact, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Information',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.onSurfaceVariant,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.phone),
              const SizedBox(width: 12),
              Text(contact),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.content_copy),
                onPressed: (){},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImageGallery(List<String> images) {
    if (images.isEmpty) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.image, size: 60, color: Colors.grey),
      );
    }

    return SizedBox(
      height: 300,
      child: PageView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: images[index],
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatDateTime(String dateTimeStr) {
    final parts = dateTimeStr.split('/');
    if (parts.length != 5) return dateTimeStr;

    final year = parts[0];
    final month = parts[1];
    final day = parts[2];
    final hour = parts[3];
    final minute = parts[4];

    return '$year-$month-$day at ${int.parse(hour)}:${minute.padLeft(2, '0')}';
  }

// Reuse all the helper methods from previous implementation:
// _buildImageGallery(), _buildDetailRow(), _buildContactSection(),
// _formatDateTime(), _copyToClipboard()
}