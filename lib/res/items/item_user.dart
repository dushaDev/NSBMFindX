import 'package:find_x/res/font_profile.dart';
import 'package:flutter/material.dart';

class ItemUser extends StatefulWidget {
  final String name;
  final String role;
  final bool isApproved;
  final bool isRestricted;

  const ItemUser({
    super.key,
    required this.name,
    required this.role,
    required this.isApproved,
    required this.isRestricted,
  });

  @override
  State<ItemUser> createState() => _ItemUserState();
}

class _ItemUserState extends State<ItemUser> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            radius: 28,
            backgroundImage: AssetImage('assets/images/user.png'),
            backgroundColor: Colors.transparent,
          )
          ,
    title: Text(widget.name,
              style: TextStyle(fontSize: FontProfile.medium,fontWeight: FontWeight.w600)),
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
