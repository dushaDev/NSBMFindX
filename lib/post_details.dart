import 'package:find_x/chat_page.dart';
import 'package:find_x/res/read_date.dart';
import 'package:find_x/res/font_profile.dart';
import 'package:find_x/user_profile_settings.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:find_x/firebase/fire_store_service.dart';
import 'firebase/auth_service.dart';
import 'firebase/models/user_m.dart';

class PostDetails extends StatefulWidget {
  final String itemId;
  final bool isFoundItem;

  const PostDetails(
      {super.key, required this.itemId, required this.isFoundItem});

  @override
  State<PostDetails> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  final FireStoreService _firestoreService = FireStoreService();
  final AuthService _authService = AuthService();
  ReadDate _readDate = ReadDate();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: FutureBuilder(
        future: widget.isFoundItem
            ? _firestoreService.getFoundItem(widget.itemId)
            : _firestoreService.getLostItem(widget.itemId),
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

    return FutureBuilder(
      future: _getLoggedUser(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: Text('Please wait..',
                  style: TextStyle(
                      fontSize: FontProfile.small,
                      color: colorScheme.onSurface)));
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData) {
          return Center(
              child: Text('User not found',
                  style: TextStyle(
                      fontSize: FontProfile.small,
                      color: colorScheme.onSurface)));
        }

        bool isThisUser = false;
        final userData = snapshot.data!;
        final userId = userData['userId'];
        final userRole = userData['userRole'];

        if (userId == post.userId) {
          isThisUser = true;
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Gallery (existing)
              post.images.isEmpty
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 100,
                          child: Center(
                            child: Column(
                              children: [
                                Text('No images to show',
                                    style: TextStyle(
                                        color: colorScheme.onSurface,
                                        fontSize: FontProfile.small)),
                                const SizedBox(height: 8),
                                Icon(
                                  Icons.sentiment_dissatisfied_rounded,
                                  size: 50,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : _buildImageGallery(post.images, colorScheme, context),
              const SizedBox(height: 20),

              // Item Name (existing)
              Text(
                post.itemName,
                style: TextStyle(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                    fontSize: FontProfile.large),
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: 60,
                    height: 24,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                    decoration: BoxDecoration(
                      color: widget.isFoundItem
                          ? colorScheme.primary
                          : colorScheme.secondary,
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
                  if (post.isCompleted)
                    Icon(
                      Icons.check_circle,
                      color: colorScheme.primary,
                      size: 25,
                    ),
                ],
              ),
              const SizedBox(height: 8),

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
                  text:
                      '${_readDate.getDateStringToDisplay(post.postedTime)} at ${_readDate.getTimeStringToDisplay(post.postedTime)}',
                  colorScheme: colorScheme),
              _buildDetailRow(
                  icon: Icons.location_pin,
                  typeText:
                      widget.isFoundItem ? 'Current location: ' : 'Last seen: ',
                  text: widget.isFoundItem
                      ? post.currentLocation
                      : post.lastKnownLocation,
                  colorScheme: colorScheme),
              const SizedBox(height: 16),

              // Description (existing)
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

              // NEW: User Details Section
              FutureBuilder(
                  future: _firestoreService.getUser(post.userId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: Text('Please wait..'));
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData) {
                      return const Center(child: Text('User not found'));
                    }

                    final user = snapshot.data!;

                    return isThisUser
                        ? Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'User Details',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSurface,
                                    fontSize: FontProfile.medium,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Posted by You',
                                  style: TextStyle(
                                      fontSize: FontProfile.small,
                                      color: colorScheme.onSurface),
                                ),
                              ],
                            ),
                          )
                        : _buildUserDetailsSection(user, colorScheme, context);
                  }),
              const SizedBox(height: 20),

              isThisUser
                  ? Container()
                  : _buildContactSection(
                      post.contactNumber, colorScheme, context),
              const SizedBox(height: 20),

              userRole == 'admin'
                  ? _buildDeleteButton(colorScheme, context)
                  : Container(),
              userRole == 'student' && isThisUser
                  ? _buildDeleteButton(colorScheme, context)
                  : Container(),
            ],
          ),
        );
      },
    );
  }

  // NEW: User Details Section Widget
  Widget _buildUserDetailsSection(
      UserM userModel, ColorScheme colorScheme, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'User Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
            fontSize: FontProfile.medium,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundImage: AssetImage('assets/images/user.png'),
              backgroundColor: Colors.transparent,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                userModel.name,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: FontProfile.small,
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.message,
                color: colorScheme.primary,
                size: 30.0,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(),
                  ),
                );
              },
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(
                Icons.person,
                color: colorScheme.primary,
                size: 30.0,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserProfileSettings(
                        userId: userModel.id, itemType: false),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  // NEW: Delete Post Button Widget
  Widget _buildDeleteButton(ColorScheme colorScheme, BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          _showDialog(context);
        },
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.error,
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.delete),
            SizedBox(width: 8),
            Text('Delete Post'),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showDialog(BuildContext context) async {
    final colorScheme = Theme.of(context).colorScheme;

    return await showDialog<bool>(
      context: context,
      barrierDismissible: true, // User can tap outside to cancel
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        title: Row(
          children: [
            Icon(
              Icons.delete,
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
          'Are you sure you want to delete this post?',
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
            onPressed: () {
              _deletePost();
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
        actionsAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }

  void _deletePost() async {
    try {
      if (widget.isFoundItem) {
        await _firestoreService.deleteFoundItem(widget.itemId);
      } else {
        await _firestoreService.deleteLostItem(widget.itemId);
      }
      Navigator.of(context).pop(); // Go back after deletion
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting post: $e')),
      );
    }
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
            Icon(
              Icons.phone,
              color: colorScheme.onSurface,
            ),
            const SizedBox(width: 12),
            Text(
              contact,
              style: TextStyle(
                  color: colorScheme.onSurface, fontSize: FontProfile.small),
            ),
            const Spacer(),
            IconButton(
              icon: Icon(
                Icons.content_copy,
                color: colorScheme.onSurface,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImageGallery(
      List<String> images, ColorScheme colorScheme, BuildContext context) {
    if (images[0] == "" && images[1] == "") {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 100,
            child: Center(
              child: Column(
                children: [
                  Text('No images to show',
                      style: TextStyle(
                          color: colorScheme.onSurface,
                          fontSize: FontProfile.small)),
                  const SizedBox(height: 8),
                  Icon(
                    Icons.sentiment_dissatisfied_rounded,
                    size: 50,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return SizedBox(
      height: 210,
      child: PageView.builder(
        padEnds: false,
        controller: PageController(viewportFraction: 0.85),
        itemCount: images.length,
        itemBuilder: (context, index) {
          if (images[index] == '' || images[index] == "") {
            return null;
          }
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
                    if (images[0] != "" && images[1] != "")
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

  Future<Map<String, dynamic>> _getLoggedUser() async {
    final userId = await _authService.getUserId();
    final userRole = await _authService.getUserRole();

    return {
      'userId': userId,
      'userRole': userRole,
    };
  }
}
