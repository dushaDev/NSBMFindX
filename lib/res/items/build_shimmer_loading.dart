import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BuildShimmerLoading extends StatefulWidget {
  const BuildShimmerLoading({super.key});

  @override
  State<BuildShimmerLoading> createState() => _BuildShimmerLoadingState();
}

class _BuildShimmerLoadingState extends State<BuildShimmerLoading> {
  @override
  Widget build(BuildContext context) {
    return _buildShimmerLoading();
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.surface,
      highlightColor: Theme.of(context).colorScheme.onSurface.withAlpha(1),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shimmering placeholder for an image
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(height: 20),
            // Shimmering placeholder for text
            Container(
              width: double.infinity,
              height: 20,
              color: Colors.white,
            ),
            SizedBox(height: 10),
            // Shimmering placeholder for text
            Container(
              width: 200,
              height: 20,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            // Shimmering placeholder for a list
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Shimmering placeholder for a list item image
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        SizedBox(width: 10),
                        // Shimmering placeholder for list item text
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 20,
                                color: Colors.white,
                              ),
                              SizedBox(height: 10),
                              Container(
                                width: 100,
                                height: 20,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
