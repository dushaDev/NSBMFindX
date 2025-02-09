import 'package:flutter/material.dart';

import '../../read_date.dart';

class ItemWishList extends StatefulWidget {
  final String id;
  final String type;
  final String name;
  final String date;
  final String release; //movie released date
  final String img;
  final bool status; //is movie watched or not
  final VoidCallback markAsWatched;
  final VoidCallback markAsUnwatched;
  final VoidCallback deleteItem;

  const ItemWishList({
    super.key,
    required this.id,
    required this.type,
    required this.name,
    required this.date,
    required this.release,
    required this.img,
    required this.status,
    required this.markAsWatched,
    required this.markAsUnwatched,
    required this.deleteItem,
  });

  @override
  State<ItemWishList> createState() => _ItemWishListState();
}

class _ItemWishListState extends State<ItemWishList> {
  ReadDate _readDate = ReadDate();
  @override
  Widget build(BuildContext context) {
    bool status = widget.status;
    return InkWell(
      onTap: () {
        showPopupDialog(context, status);
      },
      child: Card(
        elevation: status ? 0.0 : 2.0,
        color: status
            ? Theme.of(context).colorScheme.surfaceContainer.withOpacity(0.3)
            : Theme.of(context).colorScheme.surfaceContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(
                    8.0,
                  ),
                  bottomLeft: Radius.circular(8.0)),
              child: Image.network(
                widget.img,
                width: 70.0,
                height: 130.0,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return Image.asset(
                    'lib/assets/images/hotlink.jpeg',
                    fit: BoxFit.cover,
                    width: 70.0,
                    height: 130.0,
                  );
                },
                filterQuality: FilterQuality.low,
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Text(
                        widget.release,
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, bottom: 4.0),
                        child: Card(
                          margin: EdgeInsets.zero,
                          color: widget.type == 'movie'
                              ? Colors.green.shade700
                              : Colors.red.shade400,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0)),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 3.0, right: 3.0),
                            child: Text(
                              widget.type,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 13.0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 4.0,
                right: 8.0,
                top: 4.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _readDate.getDuration(
                      widget.date,
                    ),
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  status
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.check_circle_rounded,
                              color: Theme.of(context).colorScheme.secondary),
                        )
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  int toInt(bool status) {
    if (status) {
      return 1;
    } else {
      return 0;
    }
  }

  bool fromInt(int status) {
    if (status > 0) {
      return true;
    } else {
      return false;
    }
  }

  void showPopupDialog(BuildContext context, bool status) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          title: Text(
            widget.name,
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface, fontSize: 18.0),
          ),
          content: Row(
            children: [
              Card(
                margin: EdgeInsets.zero,
                color: widget.type == 'movie'
                    ? Colors.green.shade700
                    : Colors.red.shade400,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 3.0, right: 3.0),
                  child: Text(
                    widget.type,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 13.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              TextButton(
                onPressed:
                    status ? widget.markAsUnwatched : widget.markAsWatched,
                child: status
                    ? const Text(
                        'Mark As Unwatched',
                        style: TextStyle(fontWeight: FontWeight.normal),
                      )
                    : Text(
                        'Mark As Watched',
                        style: TextStyle(
                            color: status
                                ? Theme.of(context).colorScheme.secondary
                                : Theme.of(context).colorScheme.onSurface),
                      ),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0))),
                child: const Text('View'),
                onPressed: () {
                  // Navigator.of(context).pop();
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => ViewPost(
                  //             movieId: widget.id,
                  //           )),
                  // );
                },
              ),
            ]),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: widget.deleteItem,
                    child: const Text('Delete'),
                  ),
                  FilledButton(
                    style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0))),
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
