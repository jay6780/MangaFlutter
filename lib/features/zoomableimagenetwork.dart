import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:manga/colors/app_color.dart';
import 'package:shimmer/shimmer.dart';

class ZoomableImageNetwork extends StatelessWidget {
  final String url;

  const ZoomableImageNetwork(this.url, {super.key});

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      boundaryMargin: EdgeInsets.all(0.0),
      minScale: 0.1,
      maxScale: 4.0,
      child: CachedNetworkImage(
        imageUrl: url,
        errorWidget: (context, url, error) => Icon(Icons.error),
        fit: BoxFit.fill,
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: AppColors.grey!,
          highlightColor: AppColors.grey!,
          child: Container(color: AppColors.white),
        ),
      ),
    );
  }
}
