import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';

class ShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            title: Container(height: 20, width: 200, color: Colors.white),
          );
        },
      ),
    );
  }
}
