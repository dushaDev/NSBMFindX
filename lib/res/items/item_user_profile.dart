import 'package:flutter/material.dart';

class ItemUserProfile extends StatefulWidget {
  final String name;
  final String role;
  final bool isApproved;
  final bool isRestricted;

  const ItemUserProfile({
    super.key,
    required this.name,
    required this.role,
    required this.isApproved,
    required this.isRestricted,
  });

  @override
  State<ItemUserProfile> createState() => _ItemUserProfileState();
}

class _ItemUserProfileState extends State<ItemUserProfile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage('https://cdn-icons-png.flaticon.com/128/17286/17286792.png'), // Replace with actual image URL
            backgroundColor: Colors.grey[300],
          )
          ,
    title: Text(widget.name,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Row(
            children: [
              Text(widget.role),
              const SizedBox(width: 8),
              Container(
                alignment: Alignment.center,
                width: 60,
                height: 18,
                padding:
                EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                decoration: BoxDecoration(
                  color: widget.isRestricted
                      ? _getStatusColor('restricted')
                      : widget.isApproved
                      ? _getStatusColor('approved')
                      : _getStatusColor('pending'),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(
                  widget.isRestricted
                      ? 'restricted'
                      : widget.isApproved
                      ? 'approved'
                      : 'pending',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          trailing: const Icon(Icons.chat_bubble_rounded),
        ),
        const Divider(),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Theme.of(context).colorScheme.secondary;
      case 'approved':
        return Theme.of(context).colorScheme.primary;
      case 'restricted':
        return Theme.of(context).colorScheme.error;
      default:
        return Colors.grey;
    }
  }
}
