import 'package:flutter/material.dart';

class ItemSearch extends StatelessWidget {
  final String name;
  final String id;
  final String year;
  final String rating; //movie released date
  final String img;
  final String type;

  const ItemSearch({
    super.key,
    required this.name,
    required this.id,
    required this.year,
    required this.rating,
    required this.img,
    required this.type,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => ViewPost(
        //             movieId: id,
        //           )),
        // );
      },
      child: Card(
          elevation: 2.0,
          color: Theme.of(context).colorScheme.surfaceContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0)),
                child: AspectRatio(
                  aspectRatio: 100.0 / 160.0,
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            filterQuality: FilterQuality.medium,
                            onError: (exception, stackTrace) => Image.asset(
                                  'lib/assets/images/hotlink.jpeg',
                                ),
                            fit: BoxFit.cover,
                            image: NetworkImage(img))),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, top: 2.0, bottom: 2.0),
                child: Text(
                  name,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(year, style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            ),),
                        Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0)),
                            color: type == 'movie'
                                ? Colors.green.shade700
                                : Colors.red.shade400,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 4.0, right: 4.0),
                              child: Text(type,style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
                            )),
                      ],
                    ),
                    Text(rating, style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        ),),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
