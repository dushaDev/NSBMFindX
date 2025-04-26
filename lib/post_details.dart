import 'package:find_x/read_date.dart';
import 'package:find_x/res/font_profile.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'firebase/fire_store_service.dart';

class PostDetails extends StatefulWidget {
  final String id;
  final bool isFoundItem;

  const PostDetails({super.key, required this.id, required this.isFoundItem});

  @override
  State<PostDetails> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  final FireStoreService _firestoreService = FireStoreService();
  ReadDate _readDate = ReadDate();
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),
      body: FutureBuilder(
        future: widget.isFoundItem
            ? _firestoreService.getFoundItem(widget.id)
            : _firestoreService.getLostItem(widget.id),
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

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Gallery
          _buildImageGallery(post.images, colorScheme, context),
          const SizedBox(height: 20),

          // Item Name
          Text(
            post.itemName,
            style: TextStyle(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
                fontSize: FontProfile.large),
          ),
          const SizedBox(height: 8),

          // Status Chip
          Row(
            children: [
              Container(
                alignment: Alignment.center,
                width: 65,
                height: 26,
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                decoration: BoxDecoration(
                  color: widget.isFoundItem ? colorScheme.primary : colorScheme.secondary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  widget.isFoundItem ? 'Found' : 'Lost',
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                    fontSize: FontProfile.small,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              //isCompleted with green color icon
              if (post.isCompleted)
                Icon(
                  Icons.check_circle,
                  color: colorScheme.primary,
                  size: 27,
                ),
            ],
          ),
          const SizedBox(height: 8),

          // Time and Location
          _buildDetailRow(
              icon: Icons.access_time,
              typeText: widget.isFoundItem ? 'Found on: ' : 'Lost on: ',
              text: widget.isFoundItem
                  ? '${_readDate.getDateStringToDisplay(post.foundTime)} at ${_readDate.getTimeStringToDisplay(post.foundTime)}'
                  : '${_readDate.getDateStringToDisplay(post.lostTime)} at ${_readDate.getTimeStringToDisplay(post.lostTime)}',
              colorScheme: colorScheme),
          _buildDetailRow(
              icon: Icons.access_time,
              typeText: 'Posted on: ',
              text:  '${_readDate.getDateStringToDisplay(post.postedTime)} at ${_readDate.getTimeStringToDisplay(post.postedTime)}'
                 ,
              colorScheme: colorScheme),
          _buildDetailRow(
              icon: Icons.location_pin,
              typeText: widget.isFoundItem ? 'Current location: ' : 'Last seen: ',
              text: widget.isFoundItem
                  ? post.currentLocation
                  : post.lastKnownLocation,
              colorScheme: colorScheme),
          const SizedBox(height: 16),

          // Description
          Text('Description',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
                fontSize: FontProfile.medium,
              )),
          const SizedBox(height: 8),
          Text(
            post.description,
            style: TextStyle(
                color: colorScheme.onSurface, fontSize: FontProfile.small),
          ),
          const SizedBox(height: 20),

          // Contact Section
          _buildContactSection(post.contactNumber, colorScheme, context),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
      {required IconData icon,
      required String typeText,
      required String text,
      required ColorScheme colorScheme}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: colorScheme.onSurface),
          const SizedBox(width: 8),
          Expanded(
              child: Row(
                children: [
                  Text(typeText,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                          fontSize: FontProfile.small)),
                  Text(text,
                      style: TextStyle(
                          color: colorScheme.onSurface,
                          fontSize: FontProfile.small)),
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildContactSection(
      String contact, ColorScheme colorScheme, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Information',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
            fontSize: FontProfile.medium,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
             Icon(Icons.phone,color: colorScheme.onSurface,),
            const SizedBox(width: 12),
            Text(contact),
            const Spacer(),
            IconButton(
              icon: Icon(Icons.content_copy,color: colorScheme.onSurface,),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImageGallery(
      List<String> images, ColorScheme colorScheme, BuildContext context) {
    if (images.isEmpty) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: colorScheme.onSurfaceVariant,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          Icons.image,
          size: 60,
          color: colorScheme.onSurfaceVariant,
        ),
      );
    }

    return SizedBox(
      height: 210,
      child: PageView.builder(
        padEnds: false,
        controller: PageController(viewportFraction: 0.85),
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Stack(
                children: [
                  // Main Image
                  CachedNetworkImage(
                    imageUrl: images[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    placeholder: (context, url) => Container(
                      color: colorScheme.onSurfaceVariant,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: colorScheme.onSurfaceVariant.withAlpha(80),
                      child: Icon(
                        Icons.error,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),

                  // Image Counter
                  if (images.length > 1)
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${index + 1}/${images.length}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: FontProfile.extraSmall,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
